require "spec_helper"

describe User do

  fixtures :users
  
  it "should act as authentic" do
    User.should include(Authlogic::ActsAsAuthentic::Base)
  end

  it "should be valid" do
    users(:admin).should be_valid  
  end

end
