class ImportsController < ApplicationController

  before_filter :require_user
  before_filter :load_defaults

  def new
  end

  def extract_records

    delimiter = params[:delimiter] || "\t"
    values = params[:values].to_s.split "\n"
    records = values.map do |value|
      value = value.split(delimiter).map(&:strip)
    end
    records = extract_empty_values(records)

  end

  def validate

    records = extract_records
    render :partial => "entries", :locals => {:entries => records}

  end

  def import

    fields = params[:fields]
    entries = params[:entries]

    records = {}

    entries.each do |index, values|
      if values["import"] === "1"
        entry = Entry.new
        fields.each do |field, attribute|
          case attribute
            when "date"
              entry.date = to_date(values[field])
            when "value"
              entry.value = to_number(values[field])
            else
              entry.send(:"#{attribute}=", values[field]) unless attribute.blank?
          end
        end
        entry.user = current_user
        entry.account = @account
        entry.category_id = values["category_id"]
        records[index] = entry
      end
    end

    #validar registros e apresentar erros para cada um
    records.values.map(&:save)

  end

  private 

  def load_defaults
    #@account = Account.from_user(current_user).find(params[:account_id])
    @account = current_user.accounts.first
    @categories = Category.from_user(current_user).roots.all
  end

  def extract_empty_values(records)
    columns_with_data = {}
    records.each do |record|
      record.each_with_index do |column, index|
        columns_with_data[index] ||= !column.strip.blank?
      end
    end
    records.collect do |record|
      column_index = -1
      record.select do |column|
        columns_with_data[column_index += 1]
      end
    end
  end

end
