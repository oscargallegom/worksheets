# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# ajax call to retrieve list of crops given the crop category
updateCrops = ->
  $.getJSON "/crop_categories/" + $("#crop_category_crop_category_id").val() + "/crops.json", (crops) ->
    crop_id = $("#crop_rotation_crop_id").val()
    items = []
    $.each crops, (key, crop) ->
      if crop.id is Number(crop_id)
        items.push "<option value=\"" + crop.id + "\" selected='selected'>" + crop.name + "</option>"
      else
        items.push "<option value=\"" + crop.id + "\">" + crop.name + "</option>"
    $("#crop_rotation_crop_id").html items.join("")
    $("#crop_rotation_crop_id").removeAttr("disabled")

# the precision feeding checkbox is only available for dairy cows
updatePrecisionFeeding = (selectElement) ->
  if selectElement.attr('id').indexOf("animal_id") > -1
    li_precision_feeding = selectElement.parent().parent().find('.li_precision_feeding')
    if selectElement.val() is '2'
      li_precision_feeding.show()
    else
      li_precision_feeding.hide()

updateTreatmentTypesCheckboxes = (caller) ->
  componentNumber = getComponentNumber(caller.attr('id'), 'crop_rotation_manure_fertilizer_applications_attributes_')
  manure_type_category = $("option:selected", caller).closest('optgroup').prop('label')

  $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_is_precision_feeding").parent().hide()
  $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_is_phytase_treatment").parent().hide()
  $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_is_poultry_litter_treatment").parent().hide()

  if (manure_type_category is 'Dairy')
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_is_precision_feeding").parent().show()
  if (manure_type_category is 'Poultry') or (manure_type_category is 'Swine')
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_is_phytase_treatment").parent().show()
  if (manure_type_category is 'Poultry')
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_is_poultry_litter_treatment").parent().show()

updateIncorporatedForCommercial = (caller) ->
  componentNumber = getComponentNumber(caller.attr('id'), 'crop_rotation_commercial_fertilizer_applications_attributes_')
  if caller.is(":checked")
    # show options
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_year").parent().show()
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_depth").parent().show()
    # make them required
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_year").prop('required', true)
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_month").prop('required', true)
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_day").prop('required', true)
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_depth").prop('required', true)
  else
    # hide options
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_year").parent().hide()
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_depth").parent().hide()
    # make them optional
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_year").prop('required', false)
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_month").prop('required', false)
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_day").prop('required', false)
    $("#crop_rotation_commercial_fertilizer_applications_attributes_" + componentNumber + "_incorporation_depth").prop('required', false)

updateIncorporatedForManure = (caller) ->
  componentNumber = getComponentNumber(caller.attr('id'), 'crop_rotation_manure_fertilizer_applications_attributes_')
  if caller.is(":checked")
    # show options
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_year").parent().show()
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_depth").parent().show()
    # make them required
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_year").prop('required', true)
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_month").prop('required', true)
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_day").prop('required', true)
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_depth").prop('required', true)
  else
    # hide options
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_year").parent().hide()
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_depth").parent().hide()
    # make them optional
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_year").prop('required', false)
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_month").prop('required', false)
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_date_day").prop('required', false)
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_incorporation_depth").prop('required', false)

updateLiquidUnits = (caller) ->
  componentNumber = getComponentNumber(caller.attr('id'), 'crop_rotation_manure_fertilizer_applications_attributes_')
  $("#total_n_concentration_unit_" + componentNumber).text('hello')
  # if liquid then show liquid units
  if caller.val() == '1'
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_liquid_unit_type_id").parent().show()
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_liquid_unit_type_id").prop('required', true)
  else    # solids
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_liquid_unit_type_id").parent().hide()
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_liquid_unit_type_id").prop('required', false)
  updateUnitsLabels(caller)

# update the units tons or gallons
updateUnitsLabels = (caller) ->
  componentNumber = getComponentNumber(caller.attr('id'), 'crop_rotation_manure_fertilizer_applications_attributes_')
  if ($("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_manure_consistency_id").val() is '1') and ($("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_liquid_unit_type_id").val() is '1')
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_total_n_concentration").next().text('lb/1000 gallons')
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_p_concentration").next().text('lb/1000 gallons')
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_application_rate").next().text('1000 gallons/ac')
  if (($("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_manure_consistency_id").val() is '2') or (($("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_manure_consistency_id").val() is '1') and ($("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_liquid_unit_type_id").val() is '2')))
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_total_n_concentration").next().text('lb/T')
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_p_concentration").next().text('lb/T')
    $("#crop_rotation_manure_fertilizer_applications_attributes_" + componentNumber + "_application_rate").next().text('T/ac')


updateEndOfSeason = (caller) ->

  return if caller.val() == '1'

  componentNumber = getComponentNumber(caller.attr('id'), 'crop_rotation_end_of_seasons_attributes_')

  # delete all end of season after the one just modified
  i=0
  deleteSection = false
  while i<$('#div_end_of_season').find('.class_end_of_season_type_id').length
    # if ($('#div_end_of_season').find('select').get(i).id.indexOf('end_of_season_type_id') > -1)
    if deleteSection
      # turn off warning message
      $('#div_end_of_season').find('.icon-delete')[i].removeAttribute('data-confirm')
      # simulate click
      $('#div_end_of_season').find('.icon-delete')[i].click()
    if componentNumber is getComponentNumber($('#div_end_of_season').find('.class_end_of_season_type_id').get(i).id, 'crop_rotation_end_of_seasons_attributes_')
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

# given the whole HTML id, return the extracted number
getComponentNumber = (componentId, prefix) ->
  withoutPrefix = componentId.replace(prefix, '')
  withoutPrefix.substring(0, withoutPrefix.indexOf('_'))


$(document).ready ->
  if typeof $("#crop_category_crop_category_id").val() isnt 'undefined' and $("#crop_category_crop_category_id").val().length > 0
    updateCrops()

  $("#crop_category_crop_category_id").change ->
    updateCrops()

  $("select").change ->
    selectListener($(this))

  $(":checkbox").change ->
    checkboxListener($(this))

  # update the page
  $("select").each (index) ->
    selectListener($(this))
  $(":checkbox").each (index) ->
    checkboxListener($(this))

# when  removing extra sections
$(document).on "nested:fieldRemoved", (event) ->
  field = event.field
  # remove the required field(otherwise Chrome complains)
  field.find('input').prop('required', false)
  field.find('select').prop('required', false)

$(document).on "nested:fieldAdded", (event) ->
  alert(JSON.stringify(event.field))
  # register new select
  $("select").change ->
    selectListener($(this))

  # register new checkboxes
  $(":checkbox").change ->
    checkboxListener($(this))
    #alert($(this).attr('id'))
    #test = $(this).attr('id').replace('crop_rotation_manure_fertilizer_applications_attributes_', '')
    #alert(test.substring(0, test.indexOf('_')))
    #alert(getComponentNumber($(this).attr('id'),'crop_rotation_manure_fertilizer_applications_attributes_' ))

  # update the page
  $("select").each (index) ->
    selectListener($(this))
  $(":checkbox").each (index) ->
    checkboxListener($(this))