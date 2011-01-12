require 'spec_helper'

describe Category do

  fixtures :users, :categories

  it "should be valid" do
    [:food, :hotdog, :coke, :transport, :gas, :other, :gifts].each do |name|
      categories(name).should be_valid
    end
  end

end





