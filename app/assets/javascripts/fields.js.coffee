# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


# update the strip indexes and show/hide length option
updateIndexes = ->
  $(".fields:visible").find(".strip_index").each (index) ->
    $(this).text(index+1)
  $(".fields:visible").find(".livestock_index").each (index) ->
    $(this).text(index+1)
  $(".fields:visible").find(".poultry_index").each (index) ->
    $(this).text(index+1)

    if $(".fields:visible").length == 1   # hide the stip number and length  option
      $(".fields:visible").find(".div_length").hide()
    else   # show length option
      $(".fields:visible").find(".div_length").each ->
        $(this).show()

# fertigation is only shown for option 1 and 2:
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
    if $("#field_irrigation_id").val() is '500'
      $("#default_efficiency").text('typically 70%-80%')
    if $("#field_irrigation_id").val() is '530'
      $("#default_efficiency").text('typically 80%-95%')
    if $("#field_irrigation_id").val() is '502'
      $("#default_efficiency").text('typically 50%-70%')

    $("#field_efficiency").prop('required', true)

# update the silt percents
updateSiltPercents = ->
  if $.isNumeric($("#field_soils_attributes_0_percent_clay").val()) and $.isNumeric($("#field_soils_attributes_0_percent_sand").val())
    $("#field_soils_attributes_0_percent_silt").val(100 - $("#field_soils_attributes_0_percent_clay").val() - $("#field_soils_attributes_0_percent_sand").val())
  if $.isNumeric($("#field_soils_attributes_1_percent_clay").val()) and $.isNumeric($("#field_soils_attributes_1_percent_sand").val())
    $("#field_soils_attributes_1_percent_silt").val(100 - $("#field_soils_attributes_0_percent_clay").val() - $("#field_soils_attributes_1_percent_sand").val())
  if $.isNumeric($("#field_soils_attributes_2_percent_clay").val()) and $.isNumeric($("#field_soils_attributes_2_percent_sand").val())
    $("#field_soils_attributes_2_percent_silt").val((100 - $("#field_soils_attributes_2_percent_clay").val() - $("#field_soils_attributes_2_percent_sand").val()).toFixed(1))

# if not use default map, acres is required
acresRequired = ->
  if $("#field_acres_use_map_true").is(":checked")
    $("#field_acres").prop('required', false)
  else
    $("#field_acres").prop('required', true)

# clicked forest buffer
isForestBufferClicked = ->
  $("#div_is_forest_buffer").toggle()
  if $("#div_is_forest_buffer").is(":visible")
    $("#field_forest_buffer_average_width").prop('required', true)
    $("#field_forest_buffer_length").prop('required', true)
  else
    $("#field_forest_buffer_average_width").prop('required', false)
    $("#field_forest_buffer_length").prop('required', false)

# clicked forest buffer
isGrassBufferClicked = ->
  $("#div_is_grass_buffer").toggle()
  if $("#div_is_grass_buffer").is(":visible")
    $("#field_grass_buffer_average_width").prop('required', true)
    $("#field_grass_buffer_length").prop('required', true)
  else
    $("#field_grass_buffer_average_width").prop('required', false)
    $("#field_grass_buffer_length").prop('required', false)


# clicked wetland
isWetlandClicked = ->
  $("#div_is_wetland").toggle()
  if $("#div_is_wetland").is(":visible")
    $("#field_wetland_area").prop('required', true)
    $("#field_wetland_treated_area").prop('required', true)
  else
    $("#field_wetland_area").prop('required', false)
    $("#field_wetland_treated_area").prop('required', false)

# clicked streambank
isStreambankRestorationClicked = ->
  $("#div_is_streambank_restoration").toggle()
  if $("#div_is_streambank_restoration").is(":visible")
    $("#field_streambank_restoration_length").prop('required', true)
  else
    $("#field_streambank_restoration_length").prop('required', false)


$(document).ready ->

  updateIndexes()
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

  $("#field_is_forest_buffer").change ->
    isForestBufferClicked()

  $("#field_is_grass_buffer").change ->
    isGrassBufferClicked()

  $("#field_is_wetland").change ->
    isWetlandClicked()

  $("#field_is_streambank_restoration").change ->
    isStreambankRestorationClicked()

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
  updateIndexes()
  field = event.field
  # remove the required field(otherwise Chrome complains)
  field.find('input').prop('required', false)


$(document).on "nested:fieldAdded", (event) ->
  updateIndexes()
