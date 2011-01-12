
namespace :mooney do

  desc "Load tests data"
  task :demo => :environment do

    [
      real = Account.new(:name => "C/C REAL"),
      unibanco = Account.new(:name => "C/C UNIBANCO"),
      visa = Account.new(:name => "CARTÃO VISA"),
      dinheiro = Account.new(:name => "DINHEIRO")
    ].each { |account| account.save }

    puts "== Accounts created ============================"

    Entry.new(:account => real, :date => Time.now, :description => "almoço", :value => -15.55, :paid => true).save
    Entry.new(:account => real, :date => Time.now, :description => "impostos", :value => -415.55, :paid => false).save
    Entry.new(:account => real, :date => Time.now, :description => "salário", :value => 1050.55, :paid => true).save

    puts "== Entries created ============================="

  end

end
