# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# fertigation is only shown for option 1 and 2
displayFertigation = ->
  if $("#field_irrigation_id option:selected").val() is '' or $("#field_irrigation_id option:selected").val() is '3'
    $("#fertigation_n").hide()
  else
    $("#fertigation_n").show()

# if not use default map, acres is required
acresRequired = ->
  if $("#field_acres_use_map_true").is(":checked")
    $("#field_acres").prop('required', false)
  else
    $("#field_acres").prop('required', true)

$(document).ready ->

  acresRequired()
  displayFertigation()

  $("#field_irrigation_id").change ->
    displayFertigation()

  $("#field_acres_use_map_false").change ->
    acresRequired()
  $("#field_acres_use_map_true").change ->
    acresRequired()

