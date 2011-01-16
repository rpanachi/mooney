class OverviewController < ApplicationController

  before_filter :require_user
  before_filter :load_defaults

  ALLOWED_MONTHLY_ORDERS = ["accounts.name", "categories.name", "entries.description", "entries.date", "entries.value", "entries.paid"]

  def index
    @accounts = Account.from_user(current_user).all
    @categories = Category.from_user(current_user).roots(:include => :children)
    @date = Date.today.beginning_of_month
    @pending_entries = Entry.from_user(current_user).all(:conditions => {:paid => false})
    @recent_entries = Entry.from_user(current_user).all(:order => "updated_at desc", :limit => 10)
    render :layout => "application"
  end

=begin
  def monthly
    @order = ALLOWED_MONTHLY_ORDERS.include?(params[:order]) ? params[:order] : "entries.date"
    @entries = Entry.from_user(current_user).in_month(Date.today).find(:all, :joins => [:account, :category], :order => @order)
  end
=end

  def account
    @accounts = Account.from_user(current_user).all
  end

  def category
    @categories = Category.from_user(current_user).roots
    @totals = {}
    @months.each do |month|
      @totals[month] = Entry.from_user(current_user).in_month(month).sum("value", :conditions => {:paid => true})
    end
  end

  def category_balance
    @category = Category.from_user(current_user).find(params[:category_id])
    respond_to do |format|
      format.html do
        render(:update) do |page|
          page.replace "category-balance-#{@category.id}", render(:partial => "category_balance", :locals => {:category => @category, :expand => params[:expand]})
          page.remove ".subcategory-balance-#{@category.id}" if !params[:expand]
        end
      end
    end    
  end

  def charts
    expenses = Entry.expenses.from_user(current_user).in_month(Date.today).find(:all,
      :select => 'sum(entries.value) as value, entries.category_id', :group => 'categories.parent_id',
      :include => :category, :joins => :category, :order => "value, categories.parent_id")

    @data = expenses.map do |expense| 
      ["#{expense.category.parent.name}", expense.value.abs.round(2)]
    end
  end

  private

  def load_defaults
    @months = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"].collect { |m| "01-#{m}-#{Date.today.year}".to_date }
  end
end
