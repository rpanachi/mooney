require 'spec_helper'

describe EntriesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/accounts/1/entries" }.should route_to(:controller => "entries", :action => "index", :account_id => "1")
    end

    it "recognizes and generates #new" do
      { :get => "/accounts/1/entries/new" }.should route_to(:controller => "entries", :action => "new", :account_id => "1")
    end

    it "recognizes and generates #show" do
      { :get => "/accounts/1/entries/1" }.should route_to(:controller => "entries", :action => "show", :id => "1", :account_id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/accounts/1/entries/1/edit" }.should route_to(:controller => "entries", :action => "edit", :id => "1", :account_id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/accounts/1/entries" }.should route_to(:controller => "entries", :action => "create", :account_id => "1") 
    end

    it "recognizes and generates #update" do
      { :put => "/accounts/1/entries/1" }.should route_to(:controller => "entries", :action => "update", :id => "1", :account_id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/accounts/1/entries/1" }.should route_to(:controller => "entries", :action => "destroy", :id => "1", :account_id => "1") 
    end
  end
end 
