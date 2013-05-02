# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


displayFertigation = ->
  if $("#field_irrigation_id option:selected").val()==''
    $("#fertigation_n").hide()
  else
    $("#fertigation_n").show()

$(document).ready ->

  displayFertigation()

  $("#field_irrigation_id").change ->
    displayFertigation()

