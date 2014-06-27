# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

updateCounties = ->
  $.getJSON "/states/" + $("#farm_site_state_id").val() + "/counties.json", (counties) ->
    items = []
    items.push "<option value>Select County</option>"
    $.each counties, (key, county) ->
      items.push "<option value=\"" + county.id + "\">" + county.name + "</option>"
    $("#farm_site_county_id").html items.join("")
    $("#farm_site_county_id").removeAttr("disabled")
    # alert $("#current_site_county_id").val()
    $("#farm_site_county_id").val($("#current_site_county_id").val())

updateTractNumber = ->
  if $("#farm_site_state_id option:selected").text() == 'Maryland'
    $("#tr_tract_number").show()
    $("#farm_tract_number").prop('required', true)
  else
    $("#tr_tract_number").hide()
    $("#farm_tract_number").prop('required', false)

# add_animal = () ->
#  $(".animal").first().prop('required', true)
#  $(".animal").first().clone().appendTo("#animals")
#$(".span_list").last().append($(".span_list").first().clone())

# $("#animals img").first().clone().appendTo("#animals")
# $("#add_animal").before('<li>' + $('#original').html() + '</li>')

showAnimalSection = ->
  $("#livestockSectiona").show()
  $("#livestockSectionb").show()
  $("#livestockSectionc").show()
  $("#addLivestockBtn").click()

hideAnimalSection = ->
  $("#livestockSectiona").hide()
  #$("#livestockSectionb").hide()
  #$("#livestockSectionc").hide()
  i = $(".icon-delete").size() - 1
  while i >= 0
    $(".icon-delete")[i].click()
    i--

$(document).ready ->
  # tract number is only shown for Maryland
  updateTractNumber()
  if typeof $("#farm_site_state_id").val() isnt 'undefined' and $("#farm_site_state_id").val().length > 0
    updateCounties()


  $("#farm_site_state_id").change ->
    updateCounties()
    updateTractNumber()


  $("#has_animals_yes").change ->
    showAnimalSection()

  $("#has_animals_no").change ->
    hideAnimalSection()

  #  $("#label_animals").hide()
  #  # $("#addLivestockBtn").hide()
  #  $(".remove_animal_button").hide()
  #  i = $(".animal").size()-1
  #  while i > 0
  #    $(".animal")[i].remove()
  #    i--
  #  $("#farm_animal_ids option").prop("selected", false)
  #  $("#farm_animal_ids").prepend("<option selected='selected' value>Select animal</option>") if $("#farm_animal_ids option:first").val() isnt ""

  #$("#add_animal_button").click ->
  #    add_animal()
  #    $(".remove_animal_button").show()
  # $("#myimage").click ->
  #    alert ''

  $(document).on "nested:fieldAdded", (event) ->
    $("#livestockSectiona").show()

  $(document).on "nested:fieldRemoved", (event) ->
    if ($(".fields:visible").size() is 0)
      $("#livestockSectiona").hide() # hide 'total animal unit'

  # $("body").on "click", ".icon-deletetttttttttttt", (e) ->
  # alert('')
  # $(".add_nested_fields").hide()  if $(".icon-delete").size() is 1
  # $('#has_animals_yes').prop('checked',true) if $(".animal").size() is 0
  #  false

  # $("#addLivestockBtn").show() if $("#has_animals_yes").is(":checked")

  # show tract number if state is Maryland
  # $("#tr_tract_number").show() if $("#farm_site_state_id option:selected").text()=='Maryland'
  hideAnimalSection() if $("#has_animals_no").is(":checked")

