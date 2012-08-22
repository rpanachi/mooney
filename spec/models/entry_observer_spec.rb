require 'spec_helper'

describe EntryObserver do

  fixtures :users, :accounts, :categories, :entries

  it "increase account balance on create a paid entry with positive value" do

    @entry = Entry.new(:date => Date.today, :account => accounts(:bank), :category => categories(:coke), :user => users(:admin), :paid => true)
    @entry.value = 5.50
    @entry.save

    accounts(:bank).balance.should == 105.50

  end

  it "descrease account balance on create a paid entry with negative value" do

    @entry = Entry.new(:date => Date.today, :account => accounts(:bank), :category => categories(:coke), :user => users(:admin), :paid => true)
    @entry.value = -5.50
    @entry.save

    accounts(:bank).balance.should == 94.50

  end

  it "increase account balance when update a paid entry with positive value" do

    @entry = entries(:one)

    @entry.value = 10.50 #5.50 to 10.50
    @entry.save #update

    accounts(:bank).balance.should == 105.00

  end

  it "descrease account balance on update a paid entry with negative value" do

    @entry = entries(:two)

    @entry.value = -10.50 #-5.50 to -10.50
    @entry.save #update

    accounts(:bank).balance.should == 95.00

  end

  it "keep same account balance on update a paid entry without changes" do

    @entry = entries(:one)
    @entry.save

    accounts(:bank).balance.should == 100.00

  end

  it "keep same account balance on update a paid entry with the same value" do

    @entry = entries(:one)
    @entry.value = @entry.value.to_f
    @entry.save

    accounts(:bank).balance.should == 100.00

  end

  it "keep same account balance on update a paid entry without change the paid status or value" do

    @entry = entries(:one)
    @entry.date = Date.today
    @entry.category = categories(:gas)
    @entry.description = "keeping the value and paid status"
    @entry.save

    accounts(:bank).balance.should == 100.00

  end

  it "keep same account balance on create an unpaid entry" do

    @entry = Entry.new(:account => accounts(:bank), :date => Date.today, :user => users(:admin))
    @entry.paid = false
    @entry.value = 5.50
    @entry.save

    accounts(:bank).balance.should == 100.00

  end

  it "keep same account balance on update an unpaid entry" do

    @entry = entries(:three)
    @entry.value = -15.50
    @entry.save

    accounts(:bank).balance.should == 100.00

  end

  it "update account balance when update an unpaid entry to paid = true" do

    @entry = entries(:three)
    @entry.paid = true
    @entry.save

    accounts(:bank).balance.should == 85.00

  end

  it "update account balance when update a paid entry to paid = false" do

    @entry = entries(:two)
    @entry.paid = false
    @entry.save

    accounts(:bank).balance.should == 105.50

  end

  it "update account balance on destroy a paid entry with positive value" do

    @entry = entries(:one)
    @entry.destroy

    accounts(:bank).balance.should == 94.50

  end

  it "update account balance on destroy a paid entry with negative value" do

    @entry = entries(:two)
    @entry.destroy

    accounts(:bank).balance.should == 105.50

  end

  it "keep same account balance on destroy an unpaid entry" do

    @entry = entries(:three)
    @entry.destroy

    accounts(:bank).balance.should == 100.00

  end

end
