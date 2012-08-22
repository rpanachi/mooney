#encoding: UTF-8
class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :accounts,   :dependent => :destroy
  has_many :categories, :dependent => :destroy
  has_many :entries,    :dependent => :destroy

  validates_acceptance_of :terms_of_service

  def load_accounts
    Account::DEFAULT_ACCOUNTS.each do |account_name|
      Account.new(:user => self, :name => account_name, :balance => 0.0).save
    end
    Rails.logger.info "Accounts sucessfully created for user #{id} => #{email}"
  end

  def load_categories
    Category::DEFAULT_CATEGORIES.each_with_index do |root_entry, root_index|
      root = Category.new(:name => root_entry[0], :user => self, :position => root_index)
      root.save
      root_entry[1].each_with_index do |child_name, child_index|
        Category.new(:name => child_name, :parent => root, :user => self, :position => child_index).save
      end
    end
    Rails.logger.info "Categories sucessfully created for user #{id} => #{email}"
  end

  def activate!
    self.update_attribute(:confirmed_at, Time.now)
    Mailer.deliver_admin_user_activated(self)
  end

  def active?
    !(self.new_record? || self.confirmed_at.nil?)
  end

  def has_credentials?
    !!crypted_password
  end

  def send_activation_instructions
    self.reset_perishable_token
    self.confirmed_at = nil
    self.confirmation_sent_at = Time.now
    self.save(false)
    Mailer.deliver_activation_instructions(self)
  end

  def send_password_reset_instructions
    self.reset_perishable_token
    self.save(false)
    Mailer.deliver_password_reset_instructions(self)
  end

end
