# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

test = (data) ->
  items = []
  $.each data, (key, county) ->
    items.push "<option id=\"" + county.id + "\">" + county.name + "</option>"
  $("#project_site_county_id").html items.join("")
  $("#project_site_county_id").removeAttr("disabled")


$(document).ready ->
  $("input,select,textarea").change ->
    $.getJSON "/states/" + $("#project_site_state_id").val() + "/counties.json", (data) ->
      test data



