# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

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

$(document).ready ->
  if typeof $("#crop_category_crop_category_id").val() isnt 'undefined' and $("#crop_category_crop_category_id").val().length > 0
    updateCrops()

  $("#crop_category_crop_category_id").change ->
    updateCrops()

  $("select").change ->
    updatePrecisionFeeding($(this))


    # first_part_of_select_animal_id = "crop_rotation_grazing_livestocks_attributes_"
    # last_part_of_select_animal_id = "_animal_id"
    # index = $(this).attr('id').replace(first_part_of_select_animal_id, "").replace(last_part_of_select_animal_id, "")
    # if not isNaN(index)
      # if $(this).val() is '2'
        # $("#li_precision_feeding_" + index).show()
      # else
        # $("#li_precision_feeding_" + index).hide()
    # alert number(index)==


# when  removing extra sections
$(document).on "nested:fieldRemoved", (event) ->
  field = event.field
  # remove the required field(otherwise Chrome complains)
  field.find('input').prop('required', false)
  field.find('select').prop('required', false)

$(document).on "nested:fieldAdded", (event) ->
  # register new select
  $("select").change ->
    updatePrecisionFeeding($(this))
