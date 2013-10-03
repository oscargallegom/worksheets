# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


updateIndexes = ->
  $(".fields:visible").find(".commercial_operation_index").each (index) ->
    $(this).text(index + 1)
  $(".fields:visible").find(".end_of_season_index").each (index) ->
    $(this).text(index + 1)
  $(".fields:visible").find(".grazing_livestock_index").each (index) ->
    $(this).text(index + 1)
  $(".fields:visible").find(".manure_operation_index").each (index) ->
    $(this).text(index + 1)
  $(".fields:visible").find(".tillage_operation_index").each (index) ->
    $(this).text(index + 1)

# if the field type is permanent pasture or hay then the crop category is determined
updateCropCategory = ->
  if ($("#field_type_id").val() is '2')
    $('#crop_rotation_crop_category_id option').each () ->
      if $(this).val() isnt '4'
        $(this).remove() # remove all other options
  else if($("#field_type_id").val() is '3')
    $('#crop_rotation_crop_category_id option').each () ->
      if $(this).val() isnt '5'
        $(this).remove() # remove all other options
#$("#crop_rotation_crop_category_id").attr('disabled', true)

# ajax call to retrieve list of crops given the crop category
updateCrops = ->
  $.getJSON "/crop_categories/" + $("#crop_rotation_crop_category_id").val() + "/crops.json", (crops) ->
    crop_id = $("#crop_rotation_crop_id").val()
    items = []
    items.push "<option value>Select Crop</option>"
    $.each crops, (key, crop) ->
      if crop.id is Number(crop_id)
        items.push "<option value=\"" + crop.id + "\" selected='selected'>" + crop.name + "</option>"
      else
        items.push "<option value=\"" + crop.id + "\">" + crop.name + "</option>"
    $("#crop_rotation_crop_id").html items.join("")
    $("#crop_rotation_crop_id").removeAttr("disabled")

# the precision feeding checkbox is only available for dairy cows
updatePrecisionFeeding = (caller) ->
  componentNumber = getComponentNumber(caller.attr('id'), 'crop_rotation_grazing_livestocks_attributes_')
  #li_precision_feeding = selectElement.closest('.li_precision_feeding')
  #componentNumber = getComponentNumber(selectElement.attr('id'), 'crop_rotation_grazing_livestocks_attributes_')
  if caller.val() is '2'
    $("#crop_rotation_grazing_livestocks_attributes_" + componentNumber + "_precision_feeding").closest('li').show()
    #li_precision_feeding.show()
    #updateAnimalUnits($("#crop_rotation_grazing_livestocks_attributes_" + componentNumber + "_precision_feeding"))
  else
    $("#crop_rotation_grazing_livestocks_attributes_" + componentNumber + "_precision_feeding").closest('li').hide()

#li_precision_feeding.hide()
#$("#crop_rotation_grazing_livestocks_attributes_" + componentNumber + "_animal_units").closest('li').hide()
#$("#crop_rotation_grazing_livestocks_attributes_" + componentNumber + "_hours_grazed").closest('li').hide()
# not required
#$("#crop_rotation_grazing_livestocks_attributes_" + componentNumber + "_animal_units").closest('li').prop('required', false)
#$("#crop_rotation_grazing_livestocks_attributes_" + componentNumber + "_hours_grazed").closest('li').prop('required', false)

# update animal units, hours grazed
#updateAnimalUnits = (caller) ->
#  componentNumber = getComponentNumber(caller.attr('id'), 'crop_rotation_grazing_livestocks_attributes_')
#  if caller.is(":checked")
#    $("#crop_rotation_grazing_livestocks_attributes_" + componentNumber + "_animal_units").closest('li').show()
#    $("#crop_rotation_grazing_livestocks_attributes_" + componentNumber + "_hours_grazed").closest('li').show()
#    # make them required
#    $("#crop_rotation_grazing_livestocks_attributes_" + componentNumber + "_animal_units").closest('li').prop('required', true)
#    $("#crop_rotation_grazing_livestocks_attributes_" + componentNumber + "_hours_grazed").closest('li').prop('required', true)
#  else
#    $("#crop_rotation_grazing_livestocks_attributes_" + componentNumber + "_animal_units").closest('li').hide()
#    $("#crop_rotation_grazing_livestocks_attributes_" + componentNumber + "_hours_grazed").closest('li').hide()
#    # not required
#    $("#crop_rotation_grazing_livestocks_attributes_" + componentNumber + "_animal_units").closest('li').prop('required', false)
#    $("#crop_rotation_grazing_livestocks_attributes_" + componentNumber + "_hours_grazed").closest('li').prop('required', false)


# checkboxes based on dairy, poultry or swine
updateTreatmentTypesCheckboxes = (caller) ->
  componentNumber = getComponentNumber(caller.attr('id'), 'crop_rotation_manure_fertilizer_applications_attributes_')
  manure_type_category = $("option:selected", caller).closest('optgroup').prop('label')

  $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_is_precision_feeding").closest('li').hide()
  $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_is_phytase_treatment").closest('li').hide()
  $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_is_poultry_litter_treatment").closest('li').hide()

  if (manure_type_category is 'Dairy')
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_is_precision_feeding").closest('li').show()
  if (manure_type_category is 'Poultry') or (manure_type_category is 'Swine')
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_is_phytase_treatment").closest('li').show()
  if (manure_type_category is 'Poultry')
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_is_poultry_litter_treatment").closest('li').show()

# incorporated checked, show dates and depth
updateIncorporatedForCommercial = (caller) ->
  componentNumber = getComponentNumber(caller.attr('id'),
    'crop_rotation_commercial_fertilizer_applications_attributes_')
  if caller.is(":checked")
    # show options
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_year").closest('li').show()
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_depth").closest('li').show()
    # make them required
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_year").prop('required',
      true)
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_month").prop('required',
      true)
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_day").prop('required',
      true)
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_depth").prop('required',
      true)
  else
    # hide options
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_year").closest('li').hide()
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_depth").closest('li').hide()
    # make them optional
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_year").prop('required',
      false)
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_month").prop('required',
      false)
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_day").prop('required',
      false)
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_depth").prop('required',
      false)

# incorporated checked, show dates and depth
updateIncorporatedForManure = (caller) ->
  componentNumber = getComponentNumber(caller.attr('id'), 'crop_rotation_manure_fertilizer_applications_attributes_')
  if caller.is(":checked")
    # show options
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_year").closest('li').show()
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_depth").closest('li').show()
    # make them required
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_year").prop('required',
      true)
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_month").prop('required',
      true)
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_day").prop('required',
      true)
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_depth").prop('required',
      true)
  else
    # hide options
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_year").closest('li').hide()
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_depth").closest('li').hide()
    # make them optional
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_year").prop('required',
      false)
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_month").prop('required',
      false)
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_day").prop('required',
      false)
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_depth").prop('required',
      false)

# update liquid units
updateLiquidUnits = (caller) ->
  componentNumber = getComponentNumber(caller.attr('id'), 'crop_rotation_manure_fertilizer_applications_attributes_')
  # if liquid then show liquid units
  if caller.val() == '265'
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_liquid_unit_type_id").closest('li').show()
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_liquid_unit_type_id").prop('required',
      true)
  else    # solids
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_liquid_unit_type_id").closest('li').hide()
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_liquid_unit_type_id").prop('required',
      false)
  updateUnitsLabels(caller)

# update the units tons or gallons
updateUnitsLabels = (caller) ->
  componentNumber = getComponentNumber(caller.attr('id'), 'crop_rotation_manure_fertilizer_applications_attributes_')
  if ($("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_manure_consistency_id").val() is '265') and ($("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_liquid_unit_type_id").val() is '1')
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_total_n_concentration").next().text('lb/1000 gallons')
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_p_concentration").next().text('lb/1000 gallons')
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_application_rate").next().text('1000 gallons/ac')
  if (($("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_manure_consistency_id").val() is '266') or (($("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_manure_consistency_id").val() is '265') and ($("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_liquid_unit_type_id").val() is '2')))
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_total_n_concentration").next().text('lb/T')
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_p_concentration").next().text('lb/T')
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_application_rate").next().text('T/ac')


updateEndOfSeason = (caller) ->
  componentNumber = getComponentNumber(caller.attr('id'), 'crop_rotation_end_of_seasons_attributes_')
  if caller.val() is '626' or caller.val() is ''      # 'harvest only'
    $("#li_end_of_season_button").show() # could add more
    $("#li_is_harvest_as_silage").show() # show option for harvest
    $("#crop_rotation_end_of_seasons_attributes_" + componentNumber + "_is_harvest_as_silage").closest('li').show()
    return
  if caller.val() is '626451'
    $("#li_end_of_season_button").hide()
    $("#crop_rotation_end_of_seasons_attributes_" + componentNumber + "_is_harvest_as_silage").closest('li').show()     # show option for harvest and kill
  else if caller.val() is '451'
    # kill so no button to add more
    $("#li_end_of_season_button").hide()
    $("#crop_rotation_end_of_seasons_attributes_" + componentNumber + "_is_harvest_as_silage").closest('li').hide()

  # delete all end of season after the one just modified
  i = 0
  deleteSection = false
  while i < $('#div_end_of_season').find('.class_end_of_season_type_id').length
    # if ($('#div_end_of_season').find('select').get(i).id.indexOf('end_of_season_type_id') > -1)
    if deleteSection
      # turn off warning message
      $('#div_end_of_season').find('.icon-delete')[i].removeAttribute('data-confirm')
      # simulate click
      $('#div_end_of_season').find('.icon-delete')[i].click()
    if componentNumber is getComponentNumber($('#div_end_of_season').find('.class_end_of_season_type_id').get(i).id,
      'crop_rotation_end_of_seasons_attributes_')
      deleteSection = true
    i++

# select change listener
selectListener = (caller) ->
  updatePrecisionFeeding(caller) if caller.attr('id').indexOf("animal_id") > -1
  updateTreatmentTypesCheckboxes(caller) if caller.attr('id').indexOf("manure_type_id") > -1
  updateLiquidUnits(caller) if caller.attr('id').indexOf("manure_consistency_id") > -1
  updateUnitsLabels(caller) if caller.attr('id').indexOf("liquid_unit_type_id") > -1
  updateEndOfSeason(caller) if caller.attr('id').indexOf("end_of_season_type_id") > -1

# checkbox change listener
checkboxListener = (caller) ->
  updateIncorporatedForCommercial(caller) if (caller.attr('id').indexOf("is_incorporated") > -1) and (caller.attr('id').indexOf("crop_rotation_commercial_fertilizer_applications_attributes") > -1)
  updateIncorporatedForManure(caller) if (caller.attr('id').indexOf("is_incorporated") > -1) and (caller.attr('id').indexOf("crop_rotation_manure_fertilizer_applications_attributes") > -1)
#updateAnimalUnits(caller) if (caller.attr('id').indexOf("precision_feeding") > -1) and (caller.attr('id').indexOf("crop_rotation_grazing_livestocks_attributes") > -1)
#updateEndOfSeason(caller) #if (caller.attr('id').indexOf("is_harvest_as_silage") > -1) and (caller.attr('id').indexOf("crop_rotation_end_of_seasons_attributes") > -1)

# given the whole HTML id, return the extracted number
getComponentNumber = (componentId, prefix) ->
  withoutPrefix = componentId.replace(prefix, '')
  withoutPrefix.substring(0, withoutPrefix.indexOf('_'))

# only show the cover crop section if yes
showCoverCropSection = ->
  # if no end of season operation but ansers yes
  if ($(".fields:visible").find(".end_of_season_index").length == 0)
    $("#li_cover_crop_warning_id").show()
  $("#li_cover_crop_id").show()
  $("#li_cover_crop_planting_method_id").show()
  $("#crop_rotation_cover_crop_id").prop('required', true)
  $("#crop_rotation_cover_crop_planting_method_id").prop('required', true)

hideCoverCropSection = ->
  $("#li_cover_crop_warning_id").hide()
  $("#li_cover_crop_id").hide()
  $("#li_cover_crop_planting_method_id").hide()
  $("#crop_rotation_cover_crop_id").prop('required', false)
  $("#crop_rotation_cover_crop_planting_method_id").prop('required', false)


$(document).ready ->

  # TODO: remove
  $("#input_xml").text(vkbeautify.xml($("#input_xml").text().trim()))
  $("#output_xml").text(vkbeautify.xml($("#output_xml").text().trim()))
  if typeof(prettyPrint) is 'function'
    prettyPrint()

  updateIndexes()
  updateCropCategory()

  if typeof $("#crop_rotation_crop_category_id").val() isnt 'undefined' and $("#crop_rotation_crop_category_id").val().length > 0
    updateCrops()

  if ($('#crop_rotation_is_cover_crop_false').is(':checked'))
    hideCoverCropSection()

  $("#crop_rotation_crop_category_id").change ->
    updateCrops()

  $("select").change ->
    selectListener($(this))

  $(":checkbox").change ->
    checkboxListener($(this))

  # update the page checkbox before select (see precision feeding)
  $(":checkbox:visible").each (index) ->
    checkboxListener($(this))

  $("select:visible").each (index) ->
    selectListener($(this))

  $("#crop_rotation_is_cover_crop_true").change ->
    showCoverCropSection()

  $("#crop_rotation_is_cover_crop_false").change ->
    hideCoverCropSection()


# when  removing extra sections
$(document).on "nested:fieldRemoved", (event) ->
  updateIndexes()
  field = event.field
  # remove the required field(otherwise Chrome complains)
  field.find('input').prop('required', false)
  field.find('select').prop('required', false)
  # if removed all end of season, make sure the Add button is shown
  if ($(".fields:visible").find(".end_of_season_index").length == 0)
    $("#li_end_of_season_button").show()

$(document).on "nested:fieldAdded", (event) ->
  updateIndexes()
  # register new select
  $("select").change ->
    selectListener($(this))

  # register new checkboxes
  $(":checkbox").change ->
    checkboxListener($(this))

  # update the page
  $(":checkbox:visible").each (index) ->
    checkboxListener($(this))
  $("select:visible").each (index) ->
    selectListener($(this))


