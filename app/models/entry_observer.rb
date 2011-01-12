class EntryObserver < ActiveRecord::Observer

  observe :entry

  def after_save(entry)
    update_account_balance(entry)
  end

  def after_destroy(entry)
    cancels_account_balance(entry)
  end

  protected 

  #TODO as vezes, usar TDD deixa o codigo meio confuso #LOL
  def update_account_balance(entry)

    current_balance = entry.account.balance || 0

    if entry.paid?

      if entry.value_changed?
        current_balance -= entry.value_was || 0
        current_balance += entry.value
      end

      if entry.paid_changed?
        current_balance += entry.value_changed? ? entry.value_was || 0 : entry.value
      end

    elsif (entry.paid_changed? && entry.paid_was)

      unless (entry.created_at_changed? && !entry.created_at_was)
        current_balance -= entry.value || 0
      end

    end

    if entry.changed?

      RAILS_DEFAULT_LOGGER.debug("Entry saved: updating account[#{entry.account.id}] balance from [#{entry.account.balance}] to [#{current_balance}]")

      entry.account.balance = current_balance
      entry.account.save

    end

  end

  def cancels_account_balance(entry)

    if entry.paid? || (entry.paid_changed? && entry.paid_was)

      value = entry.value_changed? ? entry.value_was : entry.value
      current_balance = entry.account.balance
      current_balance += value * -1

      RAILS_DEFAULT_LOGGER.debug("Entry destroyed: updating account[#{entry.account.id}] balance from [#{entry.account.balance}] to [#{current_balance}]")

      entry.account.balance = current_balance
      entry.account.save

    end

  end

end
