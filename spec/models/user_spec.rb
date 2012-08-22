require "spec_helper"

describe User do

  fixtures :users

  it "should be valid" do
    users(:admin).should be_valid
  end

end
