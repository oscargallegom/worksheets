# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


# update the strip indexes and show/hide length option
updateIndexes = ->
  $(".fields:visible").find(".strip_index").each (index) ->
    $(this).text(index+1)
  $(".fields:visible").find('[id^="addCropButton"]').each (index) ->
    $(this).attr('id', 'addCropButton_' + index)
  $(".fields:visible").find(".livestock_index").each (index) ->
    $(this).text(index+1)
  $(".fields:visible").find(".poultry_index").each (index) ->
    $(this).text(index+1)

  if $(".fields:visible").length == 1   # hide the stip number and length  option
    $(".fields:visible").find(".div_length").hide()
    $(".fields:visible").find(".textboxMedium").each ->
      $(this).prop('required', false)
  else   # show length option
    $(".fields:visible").find(".div_length").each ->
      $(this).show()
    $(".fields:visible").find(".textboxMedium").each ->
      $(this).prop('required', true)

# fertigation is only shown for option 500 and 530 (center pivot or drip):
displayFertigation = ->
  if $("#field_irrigation_id option:selected").val() isnt '500' and $("#field_irrigation_id option:selected").val() isnt '530'
    $("#fertigation_n").hide()
  else
    $("#fertigation_n").show()

# fertigation is only shown for any option selected
displayEfficiency = ->
  if ($("#field_irrigation_id option:selected").val() is '' or $("#field_irrigation_id option:selected").val() is '0')
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

# calculate forrest buffer area
updateForrestBufferArea = ->
  if $.isNumeric($("#field_forrest_buffer_average_width").val()) and $.isNumeric($("#field_forrest_buffer_length").val())
    $("#forrest_buffer_area").val(($("#field_forrest_buffer_average_width").val() * $("#field_forrest_buffer_length").val() / 43560.0).toFixed(2))

updateGrassBufferArea = ->
  if $.isNumeric($("#field_grass_buffer_average_width").val()) and $.isNumeric($("#field_grass_buffer_length").val())
    $("#grass_buffer_area").val(($("#field_grass_buffer_average_width").val() * $("#field_grass_buffer_length").val() / 43560.0).toFixed(2))

# when the button add crop is called find out the strip, then submit form
addCrop = (caller) ->
  if (caller.attr('id') isnt undefined and caller.attr('id').indexOf('addCropButton')>=0)
    $('#addCropForStrip').val(caller.attr('id').substring(caller.attr('id').indexOf('_')+1));
    $("form").submit();
    false;

# if not use default map, acres is required
acresRequired = ->
  if $("#field_acres_use_map_true").is(":checked")
    $("#field_acres").prop('required', false)
  else
    $("#field_acres").prop('required', true)

isPastureAdjacentToStream = ->
  if ($("#field_is_pasture_adjacent_to_stream_true").is(':checked'))
    $("#div_is_pasture_adjacent_to_stream").show()
  else
    $("#div_is_pasture_adjacent_to_stream").hide()
  if $("#div_is_pasture_adjacent_to_stream").is(":visible")
    $("#field_fence_length").prop('required', true)
    $("#field_is_streambank_fencing_in_place_true").prop('required', true)
    $("#field_is_streambank_fencing_in_place_false").prop('required', true)
    if $("#div_is_fencing_in_place").is(":visible")
      $("#field_vegetation_type_fence_stream_id").prop('required', true)
      $("#field_distance_fence_stream").prop('required', true)
  else
    $("#field_fence_length").prop('required', false)
    $("#field_is_streambank_fencing_in_place_true").prop('required', false)
    $("#field_is_streambank_fencing_in_place_false").prop('required', false)
    $("#field_vegetation_type_fence_stream_id").prop('required', false)
    $("#field_distance_fence_stream").prop('required', false)

isFencingInPlace = ->
  if ($("#field_is_streambank_fencing_in_place_true").is(':checked'))
    $("#div_is_fencing_in_place").show()
  else
    $("#div_is_fencing_in_place").hide()
  if $("#div_is_fencing_in_place").is(":visible")
    $("#field_vegetation_type_fence_stream_id").prop('required', true)
    $("#field_distance_fence_stream").prop('required', true)
  else
    $("#field_vegetation_type_fence_stream_id").prop('required', false)
    $("#field_distance_fence_stream").prop('required', false)

# clicked forrest buffer
isForrestBufferClicked = ->
  $("#div_is_forrest_buffer").toggle()
  if $("#div_is_forrest_buffer").is(":visible")
    $("#field_forrest_buffer_average_width").prop('required', true)
    $("#field_forrest_buffer_length").prop('required', true)
  else
    $("#field_forrest_buffer_average_width").prop('required', false)
    $("#field_forrest_buffer_length").prop('required', false)

# clicked grass buffer
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

  # TODO: remove
  $("#nttxml").text(vkbeautify.xml($("#nttxml").text().trim()))
  if typeof(prettyPrint) is 'function'
    prettyPrint()

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

  $("#field_is_pasture_adjacent_to_stream_true").change ->
    isPastureAdjacentToStream()
  $("#field_is_pasture_adjacent_to_stream_false").change ->
    isPastureAdjacentToStream()

  $("#field_is_streambank_fencing_in_place_true").change ->
    isFencingInPlace()
  $("#field_is_streambank_fencing_in_place_false").change ->
    isFencingInPlace()

  $("#field_is_forrest_buffer").change ->
    isForrestBufferClicked()

  $("#field_is_grass_buffer").change ->
    isGrassBufferClicked()

  $("#field_is_wetland").change ->
    isWetlandClicked()

  $("#field_is_streambank_restoration").change ->
    isStreambankRestorationClicked()

  # if data is changed, update the silt percent
  $("input").keyup ->
    updateSiltPercents()
    updateForrestBufferArea()
    updateGrassBufferArea()

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

  $("a").click ->
    addCrop($(this))


$(document).on "nested:fieldRemoved", (event) ->
  updateIndexes()
  field = event.field
  # remove the required field(otherwise Chrome complains)
  field.find('input').prop('required', false)


$(document).on "nested:fieldAdded", (event) ->
  updateIndexes()
  $("a").click ->
      addCrop($(this))


formatXml = (xml) ->
  formatted = ""
  reg = /(>)(<)(\/*)/g
  xml = xml.replace(reg, "$1\r\n$2$3")
  pad = 0
  jQuery.each xml.split("\r\n"), (index, node) ->
    indent = 0
    if node.match(/.+<\/\w[^>]*>$/)
      indent = 0
    else if node.match(/^<\/\w/)
      pad -= 1  unless pad is 0
    else if node.match(/^<\w[^>]*[^\/]>.*$/)
      indent = 1
    else
      indent = 0
    padding = ""
    i = 0

    while i < pad
      padding += "  "
      i++
    formatted += padding + node + "\r\n"
    pad += indent

  formatted

