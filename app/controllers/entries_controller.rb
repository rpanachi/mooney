class EntriesController < ApplicationController

  before_filter :require_user
  before_filter :localize_params, :only => [:create, :update]

  def index
    load_defaults
  end

  def show
    @entry = Entry.from_user(current_user).find(params[:id])
    render(:update) do |page|
      page.replace "entry-#{@entry.id}", :partial => "show", :locals => {:entry => @entry}
    end
  end

  def new
    @entry = Entry.new(:account_id => params[:account_id], :date => Date.today, :user => current_user)
    load_categories(:include => :children)
    render(:update) do |page|
      page.remove "entry-new"
      page.insert_html :before, "footer", :partial => "form", :locals => {:entry => @entry}
      page.call "enable_masks"
      page.call "enable_datepicker", "#{l((Date.today - 1.month).beginning_of_month)}"
      page.select("#entry-new #entry_value").focus()
    end
  end

  def edit
    @entry = Entry.from_user(current_user).find(params[:id])
    load_categories(:include => :children)
    render(:update) do |page|
      page.replace "entry-#{@entry.id}", :partial => "form", :locals => {:entry => @entry}
      page.call "enable_masks"
      page.call "enable_datepicker", "#{l((Date.today - 1.month).beginning_of_month)}"
    end
  end

  def create
    @entry = Entry.new(params[:entry])
    @entry.account_id = params[:account_id]
    @entry.user = current_user
    @entry.paid = params[:entry][:paid] || false

    if @entry.save
      load_defaults
      render(:update) do |page|
        page.replace_html "sidebar", :partial => "sidebar", :locals => {:accounts => @accounts}
        page.replace "entry-new", :partial => "show", :locals => {:entry => @entry}
        page.insert_html :bottom, "entries", tag("tr", :id => "entry-new")
        page.call "calculate_total_entries"
      end
    else
      load_categories(:include => :children)
      render(:update) do |page|
        page.replace "entry-new", :partial => "form", :locals => {:entry => @entry}
        page.call "enable_masks"
        page.call "enable_datepicker", "#{l((Date.today - 1.month).beginning_of_month)}"
      end
    end
  end

  def update
    @entry = Entry.from_user(current_user).find(params[:id])
    @entry.paid = params[:entry][:paid] || false

    if @entry.update_attributes(params[:entry]) && @entry.reload
      load_defaults
      render(:update) do |page|
        page.replace_html "sidebar", :partial => "sidebar", :locals => {:accounts => @accounts}
        page.replace "entry-#{@entry.id}", :partial => "show", :locals => {:entry => @entry}
        page.call "calculate_total_entries"
      end
    else
      load_categories(:include => :children)
      render(:update) do |page|
        page.replace "entry-#{@entry.id}", :partial => "form", :locals => {:entry => @entry}
        page.call "enable_masks"
        page.call "enable_datepicker", "#{l((Date.today - 1.month).beginning_of_month)}"
      end
    end
  end

  def destroy
    @entry = Entry.from_user(current_user).find(params[:id])
    @entry.destroy

    load_defaults
    render(:update) do |page|
      page.replace_html "sidebar", :partial => "sidebar", :locals => {:accounts => @accounts, :tags => @tags}
      page.remove "entry-#{@entry.id}"
    end
  end

  def category_balance
    @date = get_date_or_today
    @category = Category.from_user(current_user).find(params[:category_id])

    render(:update) do |page|
      page.replace "category-balance-#{@category.id}", render(:partial => "category_balance", :locals => {:category => @category, :expand => params[:expand]})
      page.remove ".subcategory-balance-#{@category.id}" if !params[:expand]
    end
  end

  def import
    render(:update) do |page|
      page.replace "entry-new", :partial => "import"
    end
  end

  protected

  def load_defaults
    @account = Account.from_user(current_user).find(params[:account_id])
    @accounts = Account.from_user(current_user).all
    @date = get_date_or_today
    @entries = Entry.from_user_and_account(current_user, @account).in_month(@date)
    load_categories
  end

  def load_categories(options = {})
    @categories = Category.from_user(current_user).roots(:all, options)
  end

  private

  def localize_params
    params[:entry][:date] = to_date(params[:entry][:date]) if params.include?(:entry) && params[:entry].include?(:date)
    params[:entry][:value] = to_number(params[:entry][:value]) if params.include?(:entry) && params[:entry].include?(:value)
  end

  def get_date_or_today
    date = "01-#{params[:date]}".to_date
    date.between?(Date.today.last_year.beginning_of_year, Date.today.next_year.end_of_year) ? date : Date.today
  rescue
    Date.today
  end

end
