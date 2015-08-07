###
Debate Summary - Croudsource arguments and debates
Copyright (C) 2015 Policy Wiki Educational Foundation LTD <hello@shouldwe.org>

This file is part of Debate Summary.

Debate Summary is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Debate Summary is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Debate Summary.  If not, see <http://www.gnu.org/licenses/>.
###
$ ->

# This builds the form elements on the Issue page, for, against, alternative and relative data sections
  
  renderField = (container) ->
    data = container.data()
    data = $.extend data, {fieldTimestamp: (new Date).getTime()}
    render = window.HoganTemplates['issues/detail_field'].render(data)
    container.find('.collapsable').hide()
    container.find('.holding').append(render)
    if parseInt(heightFor) > parseInt(heightAgainst)
      newheight = heightFor
    else
      newheight = heightAgainst
    $('#argumentBoxes').css("height", newheight)
  
  detailTypes = ["detail_alternatives", "detail_data"]
  
  $('.new-detail').on "click", (e) ->
    e.preventDefault()
    el = $(this)

    if el.data("detail-type") == "for-argument"
      forContainer = el.parent().parent().parent().find('#forContainer')
      el.parent().parent().parent().parent().find('.slide-arrow').removeClass("rotatearrow")
      renderField forContainer
      heightFor = el.parent().parent().parent().parent().parent().parent().parent().find('#forContainer').css("height")
      heightAgainst = el.parent().parent().parent().parent().parent().parent().parent().find('#againstContainer').css("height")
      if parseInt(heightFor) > parseInt(heightAgainst)
        newheight = heightFor
      else
        newheight = heightAgainst
      el.parent().parent().parent().parent().parent().parent().parent().find('#argumentBoxes').css("height", newheight)
    
    else if el.data("detail-type") == "against-argument"
      againstContainer = el.parent().parent().parent().find('#againstContainer')
      renderField againstContainer
      heightFor = el.parent().parent().parent().parent().parent().parent().parent().find('#forContainer').css("height")
      heightAgainst = el.parent().parent().parent().parent().parent().parent().parent().find('#againstContainer').css("height")
      if parseInt(heightFor) > parseInt(heightAgainst)
        newheight = heightFor
      else
        newheight = heightAgainst
      el.parent().parent().parent().parent().parent().parent().parent().find('#argumentBoxes').css("height", newheight)
      
    else if (detailTypes.some (word) -> el.data("detail-type").indexOf word)
      container = el.parent().parent()
      renderField container
   
  if $('#againstContainer').children('.argument-field').size() == 0
    heightAgainst = "460px"
    renderField $('#againstContainer')
  if $('#forContainer').children('.argument-field').size() == 0
    heightFor = "460px"
    renderField $('#forContainer')
  if $('#alternativePerspectivesContainer').children('.argument-field').size() == 0
    renderField $('#alternativePerspectivesContainer')
  if $('#relevantDataContainer').children('.argument-field').size() == 0
    renderField $('#relevantDataContainer')
    
    
  #if $('#linksHolder').children().size() == 0
  #  $('.add-another-link').click()
