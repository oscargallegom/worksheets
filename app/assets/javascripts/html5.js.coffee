# bug in rails with browsers not supporting HTML 5.
# remove the required attribute
$(document).ready ->
  $(".nn-form").attr('novalidate', 'novalidate') if $(".checkHTML5")[0].type isnt "date"
  $("form [required]").addClass("required").removeAttr("required")  if $(".checkHTML5")[0].type isnt "date"

