class User < ActiveRecord::Base
  include Gravtastic, Plivo

  @@plivo = RestAPI.new('MAZJAZZJRLYTAYYZGWYZ', 'YmFlNTdhNWY2OWMzYWJmMWY2OWYwOGE5NDMxZTYy')

  # Constants
  EXTENSIONS                = ['jpg', 'jpeg', 'gif', 'png']
  COMMISSION_TYPES          = ['Prepaid', 'Subscription', 'Postpaid']
  ROLES                     = ['Agent', 'Customer', 'SuperAgent']
  MINIMUM_ALLOW_CALL_AMOUNT = 10.00


  # Self Join References
  has_many :customers, class_name: "User", foreign_key: "parent_id"
  belongs_to :agent, :class_name => "User", foreign_key: "parent_id"

  has_many :cdrs, class_name: "Call", foreign_key: "agent_id", dependent: :destroy
  has_many :calls, class_name: "Call", foreign_key: "user_id", dependent: :destroy
  has_many :calling_ids, dependent: :destroy
  has_many :receipts, dependent: :destroy
  has_many :sales_receipts, class_name: "Receipt", foreign_key: "agent_id"

  has_many :recharges, dependent: :destroy


  #Validation
  validates :first_name, :last_name, length: { minimum: 3 }, allow_nil: true, allow_blank: true
  validates :email, uniqueness: true, email: true, presence: true
  validates :first_name, :last_name, length: { minimum: 3 }
  validates :password, :password_confirmation, presence: true, length: { minimum: 6 }, on: :create

  with_options :if => :is_agent? do |agent|
    agent.validates :bank_account, :routing_number, :account_number, :tax_id, presence: true, allow_blank: true, allow_nil: true, on: :create
    agent.validates :business_name, presence: true, uniqueness: true
  end


  has_attached_file :logo, :styles => { medium: ["300x300>", :png], thumb: ["100x100>", :png], large: ["600x600>", :png] }, :default_url => "/images/:style/missing.jpg"
  validates_attachment :logo, presence: false, size: { in: 0..2.gigabytes }

  before_post_process :is_valid_image?

  has_secure_password
  gravtastic

  # Database events
  after_create :add_endpoint, :send_email
  before_create :create_plivo_subaccount, :create_plivo_endpoint
  before_destroy :delete_plivo_subaccount, :set_customers_parent_id

  # Class Methods

  #Update Balance for user
  def update_balance(new_balance)
    balance = new_balance + balance
  end


  def full_name
    first_name + ' ' + last_name
  end

  def is_agent?
    roles.eql?(ROLES[0])
  end

  def is_customer?
    roles.eql?(ROLES[1])
  end

  def is_super_agent?
    roles.eql?(ROLES[2])
  end

  def is_active?
    account_status ? "Active" : "Inactive"
  end

  def date_created
    created_at.strftime("%A %B %d %Y %I:%M%P")
  end

  # Check if the user can make a call
  def can_make_call
    if self.balance <= MINIMUM_ALLOW_CALL_AMOUNT && self.balance > 0
      {
          say:      "Your balance is running low. Please recharge.  Please enter Destination number.",
          can_call: true
      }
    elsif self.balance <= 0
      {
          say:      "Sorry you dont have sufficient funds to make this call. Please recharge your account. Thank you.",
          can_call: false
      }
    else
      {
          say:        "Your account balance is #{balance.round(2)} dollars. Please enter Destination number",
          can_call:   true,
          time_limit: 360
      }
    end
  end


  # Gets agent total sales
  def total_sales
    sales_receipts.sum("amount")
  end

  # Gets agent total revenue ( Commission Earned )
  def total_revenue
    sales_receipts.sum("commission_earned")
  end

  def deplete_balance(total_amount)
    self.balance = (self.balance - total_amount)
    self.save
  end

  def increase_balance(total_amount)
    self.balance = (self.balance + total_amount)
    self.save
  end


  def get_agent_commission
    if is_agent? || is_super_agent?

      if self.balance >= 250
        return 10
      elsif self.balance >= 150 and self.balance < 249
        return 7
      else
        return 5
      end
    end
  end


  private


  def is_valid_image?
    extension = self.logo_file_name.split('.').last.downcase
    EXTENSIONS.include?(extension)
  end

  # Create sub account
  def create_plivo_subaccount
    begin
      if is_agent?
        new_subaccount = @@plivo.create_subaccount({ name: self.business_name.gsub(/[^A-Za-z0-9]/i, '') })[1]

        raise "Business already exists" if new_subaccount.class == RestClient::BadRequest
        p new_subaccount
        self.sid        = new_subaccount["auth_id"]
        self.auth_token = new_subaccount["auth_token"]
      end
    rescue Exception => e
      errors.add(:business_name, e.message)
    end
  end


  def create_plivo_endpoint
    if self.is_agent?
      password  = SecureRandom.hex[0..10]
      end_point = @@plivo.create_endpoint({ username: self.business_name.gsub(/[^A-Za-z0-9]/i, ''), password: password, alias: self.business_name })[1]

      self.endpoint_id       = end_point["endpoint_id"]
      self.endpoint_password = password
    end
  end

  def add_endpoint
    if self.is_customer?
      end_point = @@plivo.get_endpoint({ "endpoint_id" => self.agent.endpoint_id })[1]
    else
      end_point = @@plivo.get_endpoint({ "endpoint_id" => self.endpoint_id })[1]
    end

    # Register the endpoint to the calling ids table so the Agent and Agent customer can make and receive calls using SIP
    CallingId.create({ user_id: self.id, call_id: end_point["sip_uri"] })
  end

  def delete_plivo_subaccount
    if is_agent?
      @@plivo.delete_subaccount({ subauth_id: self.business_name.gsub(/[^A-Za-z0-9]/i, '') })
      @@plivo.delete_endpoint({ endpoint_id: self.endpoint_id })
    end
  end

  def set_customers_parent_id
    if is_agent?
      self.customers.each do |customer|
        customer.parent_id = 1
        customer.save
      end
    end
  end


  def send_email
    # Send welcome email
    UserNotifier.welcome_email(self).deliver
  end

end
