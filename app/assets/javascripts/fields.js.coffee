# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


updateSoilPExtractants = ->
  $.getJSON "/soil_p_extractants/" + $("#field_soil_test_laboratory_id").val() + ".json", (soil_p_extractant) ->
    $("#soil_p_extractant_id").text(soil_p_extractant.name)
    $("#p_test_value_unit").text(soil_p_extractant.unit) # unit
    $("#field_soil_p_extractant_id").val(soil_p_extractant.id) # hidden field
#items = []
#items.push "<option value>Select P Test Method</option>"
#$.each soil_p_extractants, (key, soil_p_extractant) ->
#  items.push "<option value=\"" + soil_p_extractant.id + "\">" + soil_p_extractant.name + "</option>"
#$("#field_soil_p_extractant_id").html items.join("")
#$("#field_soil_p_extractant_id").removeAttr("disabled")
#$("#field_soil_p_extractant_id").val($("#current_soil_p_extractant_id").val())
#$("#current_soil_p_extractant_id").val('')   # reset value - only needed on page load

# update the strip indexes and show/hide length option
updateIndexes = ->
  $(".fields:visible").find(".strip_index").each (index) ->
    $(this).text(index + 1)
  $(".fields:visible").find(".bmp_index").each (index) ->
    $(this).text(index + 1)
  $(".fields:visible").find('[id^="addCropButton"]').each (index) ->
    $(this).attr('id', 'addCropButton_' + index)
  $(".fields:visible").find(".livestock_index").each (index) ->
    $(this).text(index + 1)
  $(".fields:visible").find(".poultry_index").each (index) ->
    $(this).text(index + 1)

  if $(".fields:visible").find(".div_length").length == 1   # hide the stip number and length  option
    $(".fields:visible").find(".div_length").hide()
    $(".fields:visible").find("input").each ->
      if $(this).prop("id").indexOf("_length") > 0
        $(this).prop('required', false)
  else   # show length option
    $(".fields:visible").find(".div_length").each ->
      $(this).show()
    $(".fields:visible").find("input").each ->
      if $(this).prop("id").indexOf("_length") > 0
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

# calculate forest buffer area
updateForestBufferArea = ->
  if $.isNumeric($("#field_forest_buffer_average_width").val()) and $.isNumeric($("#field_forest_buffer_length").val())
    $("#forest_buffer_area").val(($("#field_forest_buffer_average_width").val() * $("#field_forest_buffer_length").val() / 43560.0).toFixed(2))
  else
    $("#forest_buffer_area").val('N/A')

updateGrassBufferArea = ->
  if $.isNumeric($("#field_grass_buffer_average_width").val()) and $.isNumeric($("#field_grass_buffer_length").val())
    $("#grass_buffer_area").val(($("#field_grass_buffer_average_width").val() * $("#field_grass_buffer_length").val() / 43560.0).toFixed(2))
  else
    $("#grass_buffer_area").val('N/A')

updateFertilizerApplicationSetbackArea = ->
  if $.isNumeric($("#field_fertilizer_application_setback_average_width").val()) and $.isNumeric($("#field_fertilizer_application_setback_length").val())
    $("#fertilizer_application_setback_area").val(($("#field_fertilizer_application_setback_average_width").val() * $("#field_fertilizer_application_setback_length").val() / 43560.0).toFixed(2))
  else
    $("#fertilizer_application_setback_area").val('N/A')


# now for the future BMP
updateForestBufferAreaFuture = ->
  if $.isNumeric($("#field_forest_buffer_average_width_future").val()) and $.isNumeric($("#field_forest_buffer_length_future").val())
    $("#forest_buffer_area_future").val(($("#field_forest_buffer_average_width_future").val() * $("#field_forest_buffer_length_future").val() / 43560.0).toFixed(2))
  else
    $("#forest_buffer_area_future").val('N/A')

updateGrassBufferAreaFuture = ->
  if $.isNumeric($("#field_grass_buffer_average_width_future").val()) and $.isNumeric($("#field_grass_buffer_length_future").val())
    $("#grass_buffer_area_future").val(($("#field_grass_buffer_average_width_future").val() * $("#field_grass_buffer_length_future").val() / 43560.0).toFixed(2))
  else
    $("#grass_buffer_area_future").val('N/A')

updateFertilizerApplicationSetbackAreaFuture = ->
  if $.isNumeric($("#field_fertilizer_application_setback_average_width_future").val()) and $.isNumeric($("#field_fertilizer_application_setback_length_future").val())
    $("#fertilizer_application_setback_area_future").val(($("#field_fertilizer_application_setback_average_width_future").val() * $("#field_fertilizer_application_setback_length_future").val() / 43560.0).toFixed(2))
  else
    $("#fertilizer_application_setback_area_future").val('N/A')

# when the button add crop is called find out the strip, then submit form
addCrop = (caller) ->
  if (caller.attr('id') isnt undefined and caller.attr('id').indexOf('addCropButton') >= 0)
    $('#addCropForStrip').val(caller.attr('strip_id'));
    $(".nn-form").submit();
    false;

# if not use default map, acres is required
acresRequired = ->
  if $("#field_is_acres_from_map_true").is(":checked")
    $("#field_acres_from_user").prop('required', false)
  else
    $("#field_acres_from_user").prop('required', true)

isPastureAdjacentToStream = ->
  if ($("#field_is_pasture_adjacent_to_stream_true").is(':checked'))
    $("#div_is_pasture_adjacent_to_stream").show()
  else
    $("#div_is_pasture_adjacent_to_stream").hide()
  if $("#div_is_pasture_adjacent_to_stream").is(":visible")
    $("#field_fence_length").prop('required', true)
    #$("#field_is_streambank_fencing_in_place_true").prop('required', true)
    #$("#field_is_streambank_fencing_in_place_false").prop('required', true)
    #if $("#div_is_fencing_in_place").is(":visible")
    #  $("#field_vegetation_type_fence_stream_id").prop('required', true)
    #  $("#field_distance_fence_stream").prop('required', true)
  else
    $("#field_fence_length").prop('required', false)
#$("#field_is_streambank_fencing_in_place_true").prop('required', false)
#$("#field_is_streambank_fencing_in_place_false").prop('required', false)
#$("#field_vegetation_type_fence_stream_id").prop('required', false)
#$("#field_distance_fence_stream").prop('required', false)

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

isFencingInPlaceFuture = ->
  if ($("#field_is_streambank_fencing_in_place_future_true").is(':checked'))
    $("#div_is_fencing_in_place_future").show()
  else
    $("#div_is_fencing_in_place_future").hide()
  if $("#div_is_fencing_in_place_future").is(":visible")
    $("#field_vegetation_type_fence_stream_id_future").prop('required', true)
    $("#field_distance_fence_stream_future").prop('required', true)
  else
    $("#field_vegetation_type_fence_stream_id_future").prop('required', false)
    $("#field_distance_fence_stream_future").prop('required', false)

# clicked forest buffer
isForestBufferClicked = (true_click) ->
  $("#div_is_forest_buffer").toggle() if true_click
  if $("#div_is_forest_buffer").is(":visible")
    $("#field_forest_buffer_average_width").prop('required', true)
    $("#field_forest_buffer_length").prop('required', true)
  else
    $("#field_forest_buffer_average_width").prop('required', false)
    $("#field_forest_buffer_length").prop('required', false)

# clicked forest buffer
isForestBufferFutureClicked = (true_click) ->
  $("#div_is_forest_buffer_future").toggle() if true_click
  if $("#div_is_forest_buffer_future").is(":visible")
    $("#field_forest_buffer_average_width_future").prop('required', true)
    $("#field_forest_buffer_length_future").prop('required', true)
  else
    $("#field_forest_buffer_average_width_future").prop('required', false)
    $("#field_forest_buffer_length_future").prop('required', false)

# clicked grass buffer
isGrassBufferClicked = (true_click) ->
  $("#div_is_grass_buffer").toggle() if true_click
  if $("#div_is_grass_buffer").is(":visible")
    $("#field_grass_buffer_average_width").prop('required', true)
    $("#field_grass_buffer_length").prop('required', true)
  else
    $("#field_grass_buffer_average_width").prop('required', false)
    $("#field_grass_buffer_length").prop('required', false)

# clicked grass buffer
isGrassBufferFutureClicked = (true_click) ->
  $("#div_is_grass_buffer_future").toggle() if true_click
  if $("#div_is_grass_buffer_future").is(":visible")
    $("#field_grass_buffer_average_width_future").prop('required', true)
    $("#field_grass_buffer_length_future").prop('required', true)
  else
    $("#field_grass_buffer_average_width_future").prop('required', false)
    $("#field_grass_buffer_length_future").prop('required', false)

# clicked grass buffer
isFertilizerApplicationSetbackClicked = (true_click) ->
  $("#div_is_fertilizer_application_setback").toggle() if true_click
  if $("#div_is_fertilizer_application_setback").is(":visible")
    $("#field_fertilizer_application_setback_average_width").prop('required', true)
    $("#field_fertilizer_application_setback_length").prop('required', true)
  else
    $("#field_fertilizer_application_setback_average_width").prop('required', false)
    $("#field_fertilizer_application_setback_length").prop('required', false)

# clicked grass buffer
isFertilizerApplicationSetbackFutureClicked = (true_click) ->
  $("#div_is_fertilizer_application_setback_future").toggle() if true_click
  if $("#div_is_fertilizer_application_setback_future").is(":visible")
    $("#field_fertilizer_application_setback_average_width_future").prop('required', true)
    $("#field_fertilizer_application_setback_length_future").prop('required', true)
  else
    $("#field_fertilizer_application_setback_average_width_future").prop('required', false)
    $("#field_fertilizer_application_setback_length_future").prop('required', false)


# clicked wetland
isWetlandClicked = (true_click) ->
  $("#div_is_wetland").toggle() if true_click
  if $("#div_is_wetland").is(":visible")
    $("#field_wetland_area").prop('required', true)
    $("#field_wetland_treated_area").prop('required', true)
  else
    $("#field_wetland_area").prop('required', false)
    $("#field_wetland_treated_area").prop('required', false)

# clicked wetland
isWetlandFutureClicked = (true_click) ->
  $("#div_is_wetland_future").toggle() if true_click
  if $("#div_is_wetland_future").is(":visible")
    $("#field_wetland_area_future").prop('required', true)
    $("#field_wetland_treated_area_future").prop('required', true)
  else
    $("#field_wetland_area_future").prop('required', false)
    $("#field_wetland_treated_area_future").prop('required', false)

# clicked streambank
isStreambankRestorationClicked = (true_click) ->
  $("#div_is_streambank_restoration").toggle() if true_click
  if $("#div_is_streambank_restoration").is(":visible")
    $("#field_streambank_restoration_length").prop('required', true)
  else
    $("#field_streambank_restoration_length").prop('required', false)

# clicked streambank
isStreambankRestorationFutureClicked = (true_click) ->
  $("#div_is_streambank_restoration_future").toggle() if true_click
  if $("#div_is_streambank_restoration_future").is(":visible")
    $("#field_streambank_restoration_length_future").prop('required', true)
  else
    $("#field_streambank_restoration_length_future").prop('required', false)


changeLivestockInputMethodClicked = ->
  $(".li_total_manure").each ->
    $(this).find('input').prop('required', false)
  $(".li_quantity").each ->
    $(this).find('input').prop('required', true)
  $(".days_per_year_confined").each ->
    $(this).find('input').prop('required', true)
  $(".hours_per_day_confined").each ->
    $(this).find('input').prop('required', true)
  $(".average_weight").each ->
    $(this).find('input').prop('required', true)

  # the children need to know the value for the validation
  $(".livestock_input_method_id").val($("#field_livestock_input_method_id").val())
  if $("#field_livestock_input_method_id").val() is '1'
    $(".li_total_manure").show()
    $(".li_quantity").hide()
    $(".days_per_year_confined").hide()
    $(".hours_per_day_confined").hide()
    $(".average_weight").hide()

    $(".li_total_manure").each ->
      $(this).find('input').prop('required', true)
    $(".li_quantity").each ->
      $(this).find('input').prop('required', false)
    $(".days_per_year_confined").each ->
      $(this).find('input').prop('required', false)
    $(".hours_per_day_confined").each ->
      $(this).find('input').prop('required', false)
    $(".average_weight").each ->
      $(this).find('input').prop('required', false)

  if $("#field_livestock_input_method_id").val() is '2'
    $(".li_total_manure").hide()
    $(".li_quantity").show()
    $(".days_per_year_confined").show()
    $(".hours_per_day_confined").show()
    $(".average_weight").show()

    $(".li_total_manure").each ->
      $(this).find('input').prop('required', false)
    $(".li_quantity").each ->
      $(this).find('input').prop('required', true)
    $(".days_per_year_confined").each ->
      $(this).find('input').prop('required', true)
    $(".hours_per_day_confined").each ->
      $(this).find('input').prop('required', true)
    $(".average_weight").each ->
      $(this).find('input').prop('required', true)

# when a BMP type is selected, delete all the following BMP sections
changeBmpListener = (caller) ->
  componentNumber = getComponentNumber(caller.attr('id'), 'field_bmps_attributes_')

  # delete all BMP after the one just modified
  i = 0
  deleteSection = false
  while i < $('#div_bmp').find('.class_bmp_type_id').length
    if deleteSection
      # turn off warning message
      $('#div_bmp').find('.icon-delete')[i].removeAttribute('data-confirm')
      # simulate click
      $('#div_bmp').find('.icon-delete')[i].click()
    if componentNumber is getComponentNumber($('#div_bmp').find('.class_bmp_type_id').get(i).id,
      'field_bmps_attributes_')
      deleteSection = true
    i++

# when a new BMP section is added, the list of BMP types should not contain the ones already selected
updateBmpList = () ->
  # remove all disabled options
  i = 0
  while i < $('#div_bmp').find('.class_bmp_type_id:visible').length
    curentSelect = $('#div_bmp').find('.class_bmp_type_id:visible').get(i)
    # none of the options should be disabled in the first select
    k = 0
    while k < curentSelect.options.length
      curentSelect.options[k].disabled = false
      k++
    i++

  # now disabled appropriate options
  i = 0
  while i < $('#div_bmp').find('.class_bmp_type_id:visible').length
    curentSelect = $('#div_bmp').find('.class_bmp_type_id:visible').get(i)
    currentValue = curentSelect.options[curentSelect.selectedIndex].value

    j = i + 1
    while j < $('#div_bmp').find('.class_bmp_type_id:visible').length
      nextSelect = $('#div_bmp').find('.class_bmp_type_id:visible').get(j)

      k = 0
      while k < nextSelect.options.length

        # Horse pasture management (5) and Prescribed grazing (11) are mutually exclusive
        if (currentValue == '5' && nextSelect.options[k].value == '11')
          nextSelect.options[k].disabled = true
        if (currentValue == '11' && nextSelect.options[k].value == '5')
          nextSelect.options[k].disabled = true

        if (nextSelect.options[k].value == currentValue)
          #nextSelect.remove(k)
          nextSelect.options[k].disabled = true
        k++
      j++
    i++

  # if only one option left, then hide add BMP button
  if($('#div_bmp').find('.class_bmp_type_id').length) > 0
    if ($('#div_bmp').find('.class_bmp_type_id').get($('#div_bmp').find('.class_bmp_type_id').length - 1).options.length == 2)
      $('#addBmpBtn').hide()


# given the whole HTML id, return the extracted number
getComponentNumber = (componentId, prefix) ->
  withoutPrefix = componentId.replace(prefix, '')
  withoutPrefix.substring(0, withoutPrefix.indexOf('_'))


$(document).ready ->
  # TODO: remove
  $("#input_xml").text(vkbeautify.xml($("#input_xml").text().trim()))
  $("#output_xml").text(vkbeautify.xml($("#output_xml").text().trim()))
  if typeof(prettyPrint) is 'function'
    prettyPrint()

  updateIndexes()
  acresRequired()
  displayFertigation()
  displayEfficiency()
  updateBmpList()

  isPastureAdjacentToStream()
  isForestBufferClicked(false)
  isGrassBufferClicked(false)
  isFertilizerApplicationSetbackClicked(false)
  isWetlandClicked(false)
  isStreambankRestorationClicked(false)

  # Future
  isForestBufferFutureClicked(false)
  isGrassBufferFutureClicked(false)
  isFertilizerApplicationSetbackFutureClicked(false)
  isWetlandFutureClicked(false)
  isStreambankRestorationFutureClicked(false)

  changeLivestockInputMethodClicked(false)

  $("select").change ->
    changeBmpListener($(this)) if $(this).attr('id').indexOf("bmp_type_id") > -1

  if typeof $("#field_soil_test_laboratory_id").val() isnt 'undefined' and $("#field_soil_test_laboratory_id").val().length > 0
    updateSoilPExtractants()
    if $("#field_soil_p_extractant_id").val() == 0          # the user didn't select a P extractant
      $("#div_field_soil_p_extractant_id").addClass("field_with_errors")

  $("#field_irrigation_id").change ->
    displayFertigation()
    displayEfficiency()

  $("#field_is_acres_from_map_false").change ->
    acresRequired()
  $("#field_is_acres_from_map_true").change ->
    acresRequired()

  $("#field_is_pasture_adjacent_to_stream_true").change ->
    isPastureAdjacentToStream()
  $("#field_is_pasture_adjacent_to_stream_false").change ->
    isPastureAdjacentToStream()

  $("#field_is_streambank_fencing_in_place_true").change ->
    isFencingInPlace()
  $("#field_is_streambank_fencing_in_place_false").change ->
    isFencingInPlace()

  $("#field_is_streambank_fencing_in_place_future_true").change ->
    isFencingInPlaceFuture()
  $("#field_is_streambank_fencing_in_place_future_false").change ->
    isFencingInPlaceFuture()

  $("#field_is_forest_buffer").change ->
    isForestBufferClicked(true)

  $("#field_is_forest_buffer_future").change ->
    isForestBufferFutureClicked(true)

  $("#field_is_grass_buffer").change ->
    isGrassBufferClicked(true)

  $("#field_is_grass_buffer_future").change ->
    isGrassBufferFutureClicked(true)

  $("#field_is_fertilizer_application_setback").change ->
    isFertilizerApplicationSetbackClicked(true)

  $("#field_is_fertilizer_application_setback_future").change ->
    isFertilizerApplicationSetbackFutureClicked(true)

  $("#field_is_wetland").change ->
    isWetlandClicked(true)

  $("#field_is_wetland_future").change ->
    isWetlandFutureClicked(true)

  $("#field_is_streambank_restoration").change ->
    isStreambankRestorationClicked(true)

  $("#field_is_streambank_restoration_future").change ->
    isStreambankRestorationFutureClicked(true)

  $("#field_livestock_input_method_id").change ->
    changeLivestockInputMethodClicked()

  # if data is changed, update the silt percent
  $("input").keyup ->
    updateSiltPercents()
    updateForestBufferArea()
    updateForestBufferAreaFuture()
    updateGrassBufferArea()
    updateGrassBufferAreaFuture()
    updateFertilizerApplicationSetbackArea()
    updateFertilizerApplicationSetbackAreaFuture()

  # if data is changed, update the silt percent
  $("input").change ->
    updateSiltPercents()
    updateForestBufferArea()
    updateForestBufferAreaFuture()
    updateGrassBufferArea()
    updateGrassBufferAreaFuture()
    updateFertilizerApplicationSetbackArea()
    updateFertilizerApplicationSetbackAreaFuture()

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

  $("#field_soil_test_laboratory_id").change ->
    updateSoilPExtractants()


$(document).on "nested:fieldRemoved", (event) ->
  updateIndexes()
  updateBmpList()

  field = event.field
  # remove the required field(otherwise Chrome complains)
  field.find('input').prop('required', false)


$(document).on "nested:fieldAdded", (event) ->
  updateIndexes()
  updateBmpList()
  changeLivestockInputMethodClicked()

  $("a").click ->
    addCrop($(this))

  $("select").change ->
    changeBmpListener($(this)) if $(this).attr('id').indexOf("bmp_type_id") > -1

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

