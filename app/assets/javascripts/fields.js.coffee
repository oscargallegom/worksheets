# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# fertigation is only shown for option 1 and 2
displayFertigation = ->
  if $("#field_irrigation_id option:selected").val() is '0' or $("#field_irrigation_id option:selected").val() is '3'
    $("#fertigation_n").hide()
  else
    $("#fertigation_n").show()

# fertigation is only shown for any option selected
displayEfficiency = ->
  if $("#field_irrigation_id option:selected").val() is '0'
    $("#efficiency").hide()
    $("#field_efficiency").prop('required', false)
  else
    $("#efficiency").show()
    $("#field_efficiency").prop('required', true)

# update the silt percents
updateSiltPercents = ->
  if $.isNumeric($("#field_soils_attributes_0_clay").val()) and $.isNumeric($("#field_soils_attributes_0_sand").val())
    $("#field_soils_attributes_0_silt").val(100 - $("#field_soils_attributes_0_clay").val() - $("#field_soils_attributes_0_sand").val())
  if $.isNumeric($("#field_soils_attributes_1_clay").val()) and $.isNumeric($("#field_soils_attributes_1_sand").val())
    $("#field_soils_attributes_1_silt").val(100 - $("#field_soils_attributes_0_clay").val() - $("#field_soils_attributes_1_sand").val())
  if $.isNumeric($("#field_soils_attributes_2_clay").val()) and $.isNumeric($("#field_soils_attributes_2_sand").val())
    $("#field_soils_attributes_2_silt").val(100 - $("#field_soils_attributes_2_clay").val() - $("#field_soils_attributes_2_sand").val())

# if not use default map, acres is required
acresRequired = ->
  if $("#field_acres_use_map_true").is(":checked")
    $("#field_acres").prop('required', false)
  else
    $("#field_acres").prop('required', true)

$(document).ready ->

  acresRequired()
  displayFertigation()
  displayEfficiency()

  $("#field_irrigation_id").change ->
    displayFertigation()
    displayEfficiency()

  $("#field_acres_use_map_false").change ->
    acresRequired()
  $("#field_acres_use_map_true").change ->
    acresRequired()

  # if data is changed, update the silt percent
  $("input").change ->
    updateSiltPercents()

  # show/hide details for soil 1
  $(".detailsLink1").click ->
    $(".liSoil1").toggle()
    $(this).text (if $(this).text() is "(show details)" then "(hide details)" else "(show details)")
    return false

  # show/hide details for soil 2 (if any)
  $(".detailsLink2").click ->
    $(".liSoil2").toggle()
    $(this).text (if $(this).text() is "(show details)" then "(hide details)" else "(show details)")
    return false

  # show/hide details for soil 3 (if any)
  $(".detailsLink3").click ->
    $(".liSoil3").toggle()
    $(this).text (if $(this).text() is "(show details)" then "(hide details)" else "(show details)")
    return false

$(document).on "nested:fieldRemoved", (event) ->
  field = event.field
  # remove the required field(otherwise Chrome complains)
  field.find('input').prop('required', false)
