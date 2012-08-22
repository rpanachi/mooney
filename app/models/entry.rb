#encoding: UTF-8
class Entry < ActiveRecord::Base

  default_scope :order => "entries.date, entries.id"

  scope :from_user, lambda { |user|
    { :conditions => { :user_id => user.id } }
  }

  scope :in_month, lambda { |date|
    { :conditions => ["date between ? and ?", date.beginning_of_month, date.end_of_month] }
  }

  scope :from_user_and_account, lambda { |user, account_id|
    { :conditions => { :user_id => user.id, :account_id => account_id } }
  }

  scope :expenses, lambda {
    {:conditions => ["value < 0"]}
  }

  belongs_to :user
  belongs_to :account
  belongs_to :category

  validates_presence_of :account, :message => "Forneça uma conta para o lançamento"
  validates_presence_of :date, :message => "Informe a data do lançamento"
  validates_length_of :description, :maximum => 30, :allow_nil => true, :message => "Forneça uma descrição com no máximo 30 caracteres"
  validates_exclusion_of :value, :in => [0.0], :message => "Informe o valor do lançamento"

  attr_accessible :value, :date, :paid, :user, :account, :category, :description

  def initialize(args = {})
    super({:paid => true}.merge(args))
  end

  def overdue?(current_date = Date.today)
    !paid && date < current_date
  end

  def pending?(current_date = Date.today)
    !paid && date > current_date
  end

end
