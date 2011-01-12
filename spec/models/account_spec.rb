require 'spec_helper'

describe Account do

  fixtures :users, :accounts

  it "should be valid" do
    [:bank, :card, :money].each do |name|
      accounts(name).should be_valid
    end
  end

end
