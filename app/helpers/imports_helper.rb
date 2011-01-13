module ImportsHelper

  def entry_attributes_options

    options_for_select [
      ["Ignorar", ""],
      ["Data", "date"],
      ["Valor", "value"],
      ["Descrição", "description"],
      ["Pago?", "paid"]
    ]

  end

end
