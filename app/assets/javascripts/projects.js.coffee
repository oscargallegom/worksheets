# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

updateCounties = (data) ->
  items = []
  $.each data, (key, county) ->
    items.push "<option value=\"" + county.id + "\">" + county.name + "</option>"
  $("#project_site_county_id").html items.join("")
  $("#project_site_county_id").removeAttr("disabled")

add_animal = () ->
  $(".animal").first().prop('required', true)
  $(".animal").first().clone().appendTo("#animals")
  #$(".span_list").last().append($(".span_list").first().clone())

  # $("#animals img").first().clone().appendTo("#animals")
  # $("#add_animal").before('<li>' + $('#original').html() + '</li>')


$(document).ready ->
  $("#project_site_state_id").change ->
    $.getJSON "/states/" + $("#project_site_state_id").val() + "/counties.json", (data) ->
      updateCounties data

  $("#has_animals_yes").change ->
    $("#animals").show()
    $("#label_animals").show()
    $("#add_animal_button").show()


  $("#has_animals_no").change ->
    $("#animals").hide()
    $("#label_animals").hide()
    $("#add_animal_button").hide()

  $("#add_animal_button").click ->
      add_animal()
      $(".remove_animal_button").show()
  # $("#myimage").click ->
  #    alert ''


  $("body").on "click", ".remove_animal_button", (e) ->
    $(this).closest('div').remove()
    $(".remove_animal_button").hide()  if $(".animal").size() is 1
    false

