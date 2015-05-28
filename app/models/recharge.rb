class Recharge < ActiveRecord::Base

  belongs_to :user
  belongs_to :agent, class_name: "User", foreign_key: "agent_id"

  attr_accessor :card_name, :exp_month, :exp_year, :cvc, :number

  validates :card_name, presence: true
  validates :card_name, presence: true
  validates :exp_month, numericality: {:only_integer => true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12}
  validates :exp_year, numericality: {:only_integer => true, greater_than_or_equal_to: 1, less_than_or_equal_to: 99}
  validates :cvc, :length => {minimum: 3, maximum: 4}
  validates :amount, numericality: {greater_than_or_equal_to: 10, less_than_or_equal_to: 1000, message: "Recharge amount must be between 10.00 abd 500.00."}


  # Class Methods
  def self.recharge_by_credit_card(user: {}, recharge: {})

    amount = (recharge[:amount].to_i * 100)


    if user.stripe_customer_id.nil?
      # Create new stripe customer id
      cc_token = Stripe::Token.create(card: {number: recharge[:number].gsub(/[^0-9]/i, ''),
                                             exp_month: recharge[:exp_month].gsub(/[^0-9]/i, ''),
                                             exp_year: recharge[:exp_year].gsub(/[^0-9]/i, ''),
                                             cvc: recharge[:cvc].gsub(/[^0-9]/i, ''),
                                             name: recharge[:card_name]})

      customer = Stripe::Customer.create({card: cc_token.id, email: user.email, description: " TeHablo customer "})

      cc_charge = Stripe::Charge.create({amount: amount, currency: "USD", customer: customer.id, description: "TeHablo"})

      # Save the customer id to the users table
      user.stripe_customer_id = customer.id
      user.save

    else
      cc_charge = Stripe::Charge.create({amount: amount, currency: "USD", customer: user.stripe_customer_id, description: "TeHablo"})
    end

    # if this is an agent only update the agent balance
    (user.is_agent? || user.is_super_agent?) ? agent_id = 1 : agent_id = user.agent.id

    # Create recharge record
    recharge = self.new({user_id: user.id,
                         agent_id: agent_id,
                         last4: cc_charge.card.last4,
                         card_type: cc_charge.card.type,
                         paid: cc_charge.paid,
                         amount: recharge[:amount],
                         currency: cc_charge.currency,
                         refunded: cc_charge.refunded,
                         fee: (cc_charge.fee/100),
                         captured: cc_charge.captured,
                         failure_message: cc_charge.failure_message,
                         failure_code: cc_charge.failure_code,
                         amount_refunded: cc_charge.amount_refunded,
                         customer: cc_charge.customer,
                         invoice: cc_charge.invoice,
                         description: cc_charge.description,
                         dispute: cc_charge.dispute,
                         card_name: recharge[:card_name],
                         exp_month: recharge[:exp_month].gsub(/[^0-9]/i, ''),
                         exp_year: recharge[:exp_year].gsub(/[^0-9]/i, ''),
                         cvc: recharge[:cvc].gsub(/[^0-9]/i, ''),
                         number: recharge[:number].gsub(/[^0-9]/i, '')
                        })
  rescue Stripe::InvalidRequestError => e
    Recharge.new(recharge)
  end


end
