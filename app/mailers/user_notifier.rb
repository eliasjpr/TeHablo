class UserNotifier < ActionMailer::Base
  default from: "contact@tehablo.com"
  layout "email"

  def welcome_email(user)
    @user = user
    puts "====== Sending Customer Welcome Email ========"
    @from = @user.agent.email || "contact@tehablo.com"
    mail(:from => @from, :to => @user.email, :subject => "Welcome to TeHablo.com") do |format|
      format.html
    end

  end

  def agent_new_account(user)
    @user = user
    @agent= user.agent
    puts "====== Sending Agent New Account Confirmation Email ========"

    mail(:from => @user.agent.email, :to => @agent.email, :subject => "New account created!") do |format|
      format.html
    end

  end


  def recharge_email(receipt)
    @user     = receipt.user
    @receipt  = receipt
    puts "====== Sending Customer Recharge Email ========"
    mail(:from => @receipt.agent.email, :to => @user.email, :subject => "Your account has been recharged successfully ") do |format|
      format.html
    end
  end

  def agent_recharge_email(receipt)
    @receipt = receipt
    @agent= receipt.agent
    puts "====== Sending Agent Recharge Email ========"
    mail(:from => @receipt.agent.email, :to => receipt.agent.email, :subject => "Customer recharge account") do |format|
      format.html
    end
  end

  def forgot_password(user, random_password)
    @user = user
    @random_password = random_password

    puts "====== Sending user password ========"

    mail(:from => @user.agent.email, :to => @user.email, :subject => "Password reset!") do |format|
      format.html
    end

  end

  # Todo transfer notification

end
