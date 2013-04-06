# bug in rails with browsers not supporting HTML 5.
# remove the required attribute
$(document).ready ->
  $("form [required]").addClass("required").removeAttr "required"  if $(".checkHTML5")[0].type isnt "date"
