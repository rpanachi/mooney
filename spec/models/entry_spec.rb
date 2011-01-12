require 'spec_helper'

describe Entry do

  fixtures :users, :accounts, :categories, :entries

  it "should be valid" do

    [:one, :two, :three].each do |name|
      entries(name).should be_valid
    end

  end

  it "should be overdue if unpaid and past date" do

    entry = Entry.new(:paid => false, :date => Date.today - 1.days)
    entry.should be_overdue

  end

  it "should not be overdue if unpaid and not past date" do

    entry = Entry.new(:paid => false, :date => Date.today)
    entry.should_not be_overdue

  end

  it "should be pending if unpaid and future date" do

    entry = Entry.new(:paid => false, :date => Date.today + 1.days)
    entry.should be_pending
  
  end

  it "should not be pending if unpaid and not future date" do
  
    entry = Entry.new(:paid => false, :date => Date.today)
    entry.should_not be_pending

  end

end
