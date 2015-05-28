desc 'Transfer commission earned to agents bank account'

task :transfer_money => :environment do
  Receipt.transfer_money
end