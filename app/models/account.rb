#encoding: UTF-8
class Account < ActiveRecord::Base

  DEFAULT_ACCOUNTS = ["Dinheiro", "Conta Corrente", "Cartão de Crédito"]

  scope :from_user, lambda { |user|
    where("user_id = ?", user)
  }

  validates_presence_of :user
  validates_length_of :name, :within => 4..20
  validate :accounts_limit

  belongs_to :user
  has_many :entries

  before_destroy :destroy_entries

  def pending
    Entry.from_user_and_account(user, id).sum(:value, :conditions => ["not paid"])
  end

  def balance_in_month(date = Date.today)
    Entry.from_user_and_account(user, id).in_month(date).sum(:value, :conditions => ["paid"])
  end

  def self.can_create?(user)
    Account.from_user(user).count < 5
  end

  def to_param
    "#{id}-#{name.urlize}"
  end

  private

  def accounts_limit
    errors.add_to_base("Limite de 5 contas por usuário atingido!") if new_record? && !Account.can_create?(user)
  end

  def destroy_entries
    Entry.from_user_and_account(user, id).destroy_all
  end

end
