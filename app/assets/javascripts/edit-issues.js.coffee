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
#= require jquery.all-linked

$ ->

  # Allocate sidebar to variable, save initial content to Data model.
  sidebar = $('#popup-sidebar')
  $('body').data('edit-sidebar-title', sidebar.find('#helpSidebarTitle').text())
  $('body').data('edit-sidebar-description', sidebar.find('#helpSidebarBody').text())
  $('body').data('edit-sidebar-thinkabout', sidebar.find('#thinkAboutContainer').text())


# Cick on arrow next to boxes on for / against form expands box over other, roatates arrow, collapses any open text boxes and resets hight of container

$(document).on("click", ".slide-arrow", ->
  el = $(this).parent().parent()
  unless el.hasClass("active")
    el.parent().find(".active").removeClass "active"
    el.addClass "active"
  if $(this).hasClass("rotatearrow")
    $(this).parent().parent().parent().parent().find('.collapsable').hide()
    $(this).parent().parent().parent().find('.slide-arrow').removeClass("rotatearrow")
    $(this).parent().find('.slide-arrow').removeClass("rotatearrow")
    el.removeClass "active"
  else
    $(this).parent().parent().parent().parent().find('.collapsable').hide()
    $(this).parent().find('.collapsable').show()
    $(this).parent().parent().parent().find('.slide-arrow').removeClass("rotatearrow")
    $(this).parent().find('.slide-arrow').show().addClass("rotatearrow")

  heightFor = $(this).parent().parent().parent().parent().parent().find('#forContainer').css("height")
  heightAgainst = $(this).parent().parent().parent().parent().parent().find('#againstContainer').css("height")
  if parseInt(heightFor) > parseInt(heightAgainst)
    newheight = heightFor
  else
    newheight = heightAgainst
  # $("#result").html("That div is <span style='color:" + newheight + ";'>" + newheight + "</span>.")
  $(this).parent().parent().parent().parent().parent().find('#argumentBoxes').css("height", newheight)
)
$(document).on('blur', '.text input', (e) ->
  $(this).find('argumentBoxes').hide()
)

# Collapsing boxes END
$ ->
  # Handle updating based on form field, on focus
  $('#issueForm').on('focus', 'input[type="text"], .editable', (e) ->
    title = $(this).data("field-title")
    description = $(this).data("field-description")
    thinkAbout = $(this).data("think-about")
    Utils.resetEditSidebar(sidebar, title, description, thinkAbout)
    $('#popup-sidebar').show()
  ).on('blur', 'input[type="text"], .editable', (e) ->
    title = $('body').data('edit-sidebar-title')
    description = $('body').data('edit-sidebar-description')
    thinkAbout = $('body').data('edit-sidebar-thinkabout')
    Utils.resetEditSidebar(sidebar, title, description, thinkAbout)
  )

# Save Anonymoysly button on Issue Edit form popup box

  $('.editable, .area-contenteditable').on "hover", (e) ->
    $(@).find('a').each ->
      issueEditTip = $(@).attr('href')
      $(@).tooltip({ title: issueEditTip })


# Just check for unliked text in detail and context box
# Check the vadility of form
# http://jsfiddle.net/halfcube/L4dfK/
#
$(document).on('click', '#check', ->
  force_should
  unlinked = 0
  tagText = document.getElementById('issue_tag_list').value
  tagHash = /#/g.test(tagText)

  if tagHash isnt false
    return alert("Please make sure not to use the hash symbol (#) when adding Tags.")

  $(this).parents('form').submit()
)

force_should = (title_field)->
  title = title_field.val()
  if title[0] isnt 'S'
    title = title[0].toUpperCase() + title.substring(1)
    title_field.val(title)
  title_ok = /^Should\s/.test(title)
  if title_ok isnt true
    title = title[0].toLowerCase() + title.substring(1)
    title = "Should " + title
    title = title.replace(" hould ", " ")
    title_field.val(title)

append_question_mark = (elm) ->
  unless /\?$/.test(elm.val())
    elm.val(elm.val() + '?')

$('#issue_title').each ->
  elem = $(this)

  # Look for changes in the value
  elem.bind "propertychange keyup input paste", (event) ->
    force_should(elem)

  elem.on 'blur', (event) ->
    append_question_mark(elem)


$ ->
# Social share button on User login / signup page
  $(document).ready ->
    setInterval goBox, 120

  $ goBox = ->
    heightFor = $('#forContainer').css("height")
    heightAgainst = $('#againstContainer').css("height")
    if parseInt(heightFor) > parseInt(heightAgainst)
      newheight = heightFor
    else
      newheight = heightAgainst
    $('#argumentBoxes').css("height", newheight)




  $('body').on "click", "a#socialShare", (e) ->
    bootbox.animate false
    bootbox.alert "This is disabled while we are testing.", (confirmed) ->

# Image upload warning popup box

  $('form').on "change", "input[type=file]", (e) ->
    bootbox.animate false
    bootbox.confirm "You must have permission to upload this image.  Please only continue if you have permission from the copyright owner.", (confirmed) ->
      if confirmed
      else
        $('input[type=file]').replaceWith('<input id="issue_image" name="issue[image]" type="file" />')

# Delete argument button

  $('form').on "click", "input.removeArgument", (e) ->
    e.preventDefault()
    bootbox.animate false
    bootbox.confirm "Are you sure you want to delete that?", (confirmed) ->
      if confirmed
        setTimeout ->
          heightFor = e.html()
          alert(heightFor)
        , 110
        target = $(e.target).parent().parent().parent().parent()
        window.undo_html = {content: target.clone(), index: target.index(), target: target.parent()}
        target.remove()
        window.notif = noty
          text: "<a href='#' id='restoreArgument'>Click here to Undo</a>",
          type: "error",
          closeWith: ['button']
          timeout: 2000


# Restore argument notify button

  $('body').on "click", "a#restoreArgument", (e) ->
    e.preventDefault()
    undo_html.target.insertAt(undo_html.index, undo_html.content)
    notif.close()

  $(document).on 'click', '.save-changes, #cancel-btn', ->
    window.btn_clicked = true

  $(window).on 'beforeunload', ->
    if $('.area-contenteditable').length && not window.btn_clicked
      return "If you leave this page, you will loose any unsaved changes."
