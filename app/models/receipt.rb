class Receipt < ActiveRecord::Base
  belongs_to :user, :class_name => "User", foreign_key: "user_id"
  belongs_to :agent, :class_name => "User", foreign_key: "agent_id"

  RECHARGE_AMOUNTS =[5, 10, 15, 20, 25, 30, 35, 40, 45, 50]

  # make sure the customer is present
  validates :user_id, :presence => true
  # validate recharge amount is not more then agents account balance
  validates :amount, numericality: {greater_than_or_equal_to: 5, less_than_or_equal_to: :agent_balance, message: "You don't have sufficient funds for this recharge. Please add more funds to your account"}

  before_create :calculate_commission_earned, :deplete_agent_balance, :set_customer_balance
  after_create :send_email


  # Instance Methods
  def transfer_label
    case transfer_status
      when "pending"
        "warning"
      when "failed"
        "important"
      when "paid"
        "success"
      else
        ""
    end
  end

  # Class Methods
  def self.transfer_money

    puts "Retrieving new transfer for #{Time.now}..."

    money_transfers = where("transfer_status is null AND transfer_fee is null").group("agent_id")
    receipt_ids = where("transfer_status is null AND transfer_fee is null").select("id")


    puts "Total pending transfers #{money_transfers.count} "

    money_transfers.each do |transfer|
      # Get Commission total for this agent
      total_commission = where("transfer_status is null AND transfer_fee is null and agent_id=?", transfer.agent_id).sum('commission_earned')
      receipt_ids = where("transfer_status is null AND transfer_fee is null and agent_id=? ", transfer.agent_id).select(:id).collect { |x| x.id }

      p receipt_ids

      amount = ((total_commission - 0.5) * 100).to_i
      agent = transfer.agent

      puts "\n\n\n"
      puts "==================== START TRANSFER  ===================="
      puts "Evaluating money transfer for #{agent.full_name}, amount: #{transfer.commission_earned} in cents #{amount}"

      # Transfer money for agents that have bank account
      unless (agent.bank_account.nil? && agent.account_number.nil? && agent.routing_number.nil?)

        puts "Bank account information found for #{agent.full_name}"

        if agent.stripe_recipient_id.nil?
          # Create Stripe Recipient
          recipient = Stripe::Recipient.create({name: agent.full_name,
                                                type: "individual",
                                                bank_account: {country: "US",
                                                               routing_number: agent.routing_number,
                                                               account_number: agent.account_number, email: agent.email}

                                               })
          # get the stripe recipient
          recipient_id = recipient.id
          # Set
          agent.stripe_recipient_id = recipient_id
          # save the recipient
          agent.save()

        else
          recipient_id = agent.stripe_recipient_id
        end
        puts "Submitting transfer for #{agent.full_name}, amount: #{amount}"
        # Create new transfer
        # Transfer Money
        send_transfer = Stripe::Transfer.create({amount: amount, currency: "USD", recipient: recipient_id, description: "TeHablo money transfer", statement_descriptor: "TeHablo"})

        # Set the status for all the receipts
        Receipt.update_all({transfer_status: send_transfer.status, transfer_fee: send_transfer.fee, transfer_id: send_transfer.id}, "ID IN (#{receipt_ids.join(",")})")

      else
        puts "Agent #{agent.full_name} skipped no bank account information"
      end
      puts "==================== END TRANSFER ===================="

      puts "\n\n\n"
    end
  end

  private

  def agent_balance
    self.agent.balance
  end

  def calculate_commission_earned
    self.commission_rate= self.agent.get_agent_commission
    self.commission_earned= (self.amount * (self.commission_rate/100))
  end

  def deplete_agent_balance
    # Deplete the balance
    self.agent.deplete_balance(self.amount - self.commission_earned) unless self.user.is_agent? || self.user.is_super_agent?
  end

  def set_customer_balance
    self.user.increase_balance(self.amount)
  end

  def send_email
    UserNotifier.recharge_email(self).deliver
    UserNotifier.agent_recharge_email(self).deliver
  end


end
