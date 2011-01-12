function enable_masks() {
 	$("input:text").setMask();
}

function enable_datepicker(date) {
  $("[name='entry[date]']").each(function(index, elem) {
    $(elem).datePicker({
      createButton: false,
      clickInput: true,
      verticalOffset: 22,
      startDate: date
    });
  });
}

function sum_entries(options) {
  total = 0.0
  $("tr[id^='entry-']").each(function(index, entry) {
    entry_id = $(entry).attr("id").replace("entry-", '')
    if ($("[id='entry-id-" + entry_id + "']").attr("checked")) {
      try {
        total += parseFloat($("[id='entry-value-" + entry_id + "']").html().replace(".", '').replace(",", "."))
      } catch (ex) { /* algum engraçadinho alterou o valor na mão */ }
    }
  });
  return total.toFixed(2);
}

function calculate_total_entries() {

  total = sum_entries();
  clazz = total >= 0.00 ? "positive" : "negative"

  elem = $("#entries-total");
  elem.removeClass("positive");
  elem.removeClass("negative");
  elem.addClass(clazz);
  elem.html($.mask.string(total, "signed-decimal"));
}

function select_entries(filter) {

  switch(filter) {

    case "nenhuma": 
      $("input[id^='entry-id']").removeAttr("checked");
      break;

    case "todas": 
      $("input[id^='entry-id']").attr("checked", "checked");
      break;        

    case "pagas":
      select_entries("nenhuma");
      $("input[id^='entry-paid'][checked='checked']").each(function(index, elem) {
        check = $("#entry-id-" + $(elem).attr("id").split('-')[2])
        check.attr("checked", "checked");
      });
      break;

    case "pendentes":
      select_entries("nenhuma");
      $("input[id^='entry-paid']").each(function(index, elem) {
        check = $("#entry-id-" + $(elem).attr("id").split('-')[2])
        $(elem).attr("checked") ? check.removeAttr("checked") : check.attr("checked", "checked");
      });
      break;

    case "créditos":
      select_entries("nenhuma");
      $("span[id^='entry-value'].positive").each(function(index, elem) {
        check = $("#entry-id-" + $(elem).attr("id").split('-')[2])
        check.attr("checked", "checked");
      });
      break;

    case "débitos":
      select_entries("nenhuma");
      $("span[id^='entry-value'].negative").each(function(index, elem) {
        check = $("#entry-id-" + $(elem).attr("id").split('-')[2])
        check.attr("checked", "checked");
      });
      break;
  }

  calculate_total_entries();

}
