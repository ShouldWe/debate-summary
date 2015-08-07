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
# A lot of different sections of code for a number of elements on the main Issue page


# sidebar_hover_on = ($elem) ->
#   statement_id = $elem.attr('class').match(/detail_[0-9]+/)
#   $('#sidebar_options').hide()
#   $('#sidebar_statement_detail').show()
#   $('#sidebar_statement_detail .' + statement_id).show()

# sidebar_hover_off = ->
#   $('#sidebar_statement_detail').hide()
#   $('#sidebar_statement_detail .statement_expanded').hide()
#   $('#sidebar_options').show()

# disable_actions = ->
#   $('.statement_up').removeClass('disabled')
#   $('.statement_down').removeClass('disabled')

#   $('.statements_collection').find('.statement-row:first').find('.statement_down').removeClass('disabled')
#   $('.statements_collection').find('.statement-row:last').find('.statement_up').removeClass('disabled')

#   $('.statements_collection').find('.statement-row:first').find('.statement_up').addClass('disabled')
#   $('.statements_collection').find('.statement-row:last').find('.statement_down').addClass('disabled')

# Code for popup window for statement popup information

sidebar_hover_on = ($elem) ->
  $('.popup-box #statement_body').text($elem.text())
  $('.popup-box #statement_source').text($elem.attr('href'))
  $('.popup-box #statement_source').attr('href', $elem.attr('href')).attr('target', '_blank')
  $('.popup-box #statement_source').attr('name', $elem.attr('name'))
  $('#info-sidebar').hide()
  scrollPosition = window.pageYOffset
  windowHeight = $(window).height()
  if scrollPosition > 190
    blockheight = windowHeight - 150
  else
    blockheight = windowHeight - 310
  dataid = $elem.parents().find('.datafileid').attr('data-file')
  commentNumber = $elem.parents().find('.datafileid').attr('data-file-comment-number')
  detailHref = "#{location.protocol}//#{location.host}#{location.pathname}##{$elem.prop('name')}"
  $('#detail_target_href').val(detailHref)
  $('.popup-box #boxcommentlink').text("Comments (" + commentNumber + ")").prop('href', dataid)
  $('.boxover').css('max-height', blockheight)
  if $.browser.msie
    $('.boxover').css('height', blockheight)

  $('#popup-sidebar').show()

# Hover off for statement popup

sidebar_hover_off = ->
  $('.block a, .textblock a').removeClass('activeStatementLightBlue')
  $('#popup-sidebar, .popup-box .close').hide()
  $('#info-sidebar').show()

# Code for title vote box (orginally was a sibar popup which is what it has sidebar in the name)

sidebar_vote_hover_on = ($elem) ->
  $('.issue_vote_box').hide()
  ($elem).parent().parent().find('.issue_vote_box').show()

sidebar_vote_hover_off = ->
  $('.issue_vote_box').hide()

$ ->

  $('.fancybox').fancybox()

  $('[rel="tooltip"]').tooltip()
  $('input[rel="right-tooltip"]').tooltip
    placement: "right"
    trigger: "focus"
  $('[rel="left-tooltip"]').tooltip
  	placement: "left"

  $('.rateit').rateit()
  $('.arguments-area, .area-contenteditable').wordLimitCounter()

  $('.editable, .editable-wide').change (e) ->
	  $(this).sanitizeHTML()

# Page rating ajax code

  $('div.rateit').bind 'rated', (e) ->
    ri = $(this)
    value = $(this).rateit 'value'
    $.ajax
      url: '/ratings',
      data: {rating: {rateable_id: ri.data('rateable-id'), rateable_type: ri.data('rateable-type'), score: value}}
      type: 'POST',
      success: (data) ->
        ri.rateit('value', data.current_score)
        $('#issueRatingsMade').html(data.current_votes)
      error: (jxhr, msg, err) ->

  # $('.statement_name').blur ->
  #   statement_names = $('.statement_name').map ->
  #     if $(this).val() != ""
  #       return $(this).val()
  #
  #   if statement_names.length > (_.uniq statement_names).length
  #     alert "The statement names must be unique."
  #
  # disable_actions()

  $('.statement').hoverIntent ->
    sidebar_hover_on($(this))
  , ->
    sidebar_hover_off()

  $('.statement').click ->
    $('.statement_expanded').hide()
    sidebar_hover_on($(this))
    $('#sidebar_fix_cancel').show()
    $('.statement').off('hover')

  $('#sidebar_fix_cancel').on 'click', ->
    $('#sidebar_fix_cancel').hide()

    sidebar_hover_off()

    $('.statement').hoverIntent ->
      sidebar_hover_on($(this))
    , ->
      sidebar_hover_off()

# New activity comment button

  $('.new_activity_comment').click ->
    comment_form = $('#templates #new_activity_comment_form').clone()
    activity_id = $(this).attr('class').match(/activity_([0-9]+)/)
    comment_form.find('.commentable_id').val(activity_id[1])
    comment_form.find('.commentable_type').val('Activity')
    $(this).parent().parent().append(comment_form)

# New comment button

  $('.new_comment').click ->
    comment_form = $('#templates #new_comment_form').clone()
    issue_id = $(this).attr('class').match(/issue_([0-9]+)/)
    comment_form.find('.commentable_id').val(issue_id[1])
    comment_form.find('.commentable_type').val('Issue')
    $(this).parent().parent().append(comment_form)

# Cancel comment button

  $('a.cancel_comment').on 'click', (e) ->
    $(this).closest('form').remove()

# Unused

  $('.proposed_edit_check:checkbox').change ->
    p_e_ids = $("input#proposed_edit_ids").val().split(",")
    proposed_edit_id = $(this).attr('class').match(/proposed_edit_([0-9]+)/)
    if $(this).is(':checked')
      p_e_ids.push(proposed_edit_id[1])
    else
      index_of_id = p_e_ids.indexOf(proposed_edit_id[1])
      if index_of_id
        p_e_ids.splice(index_of_id, 1)
    $("input#proposed_edit_ids").val(p_e_ids)

# Unused

  $('.activity').hover ->
    $(this).find('.activity-options').show()
  , ->
    $(this).find('.activity-options').hide()

# On hover code for statement title voting reveal

  $('.detail_title a').hoverIntent ->
    sidebar_vote_hover_on($(this))

  $('.title_box').hoverIntent ->
    null
  , ->
    sidebar_vote_hover_off()

  # $('.detail_title a').click (e) ->
  #   e.preventDefault()
  #   $('.issue_vote_box').hide()
  #   if $('title').data("sidebar-locked") == true
  #     $('.block a, .textblock a').removeClass('activeStatementLightBlue')
  #     sidebar_vote_hover_on($(this))
  #   else
  #     $('title').data("sidebar-locked", true)
  #   $(this).addClass('activeStatementLightBlue')
  #   $('.popup-box .close').show()
  #   $('.detail_title a').off('hover')
  #
  # $('#close-vote-popup').live 'click', (e) ->
  #   e.preventDefault()
  #   $('title').data("sidebar-locked", false)
  #   sidebar_vote_hover_off()
  #   $('.detail_title a').hoverIntent ->
  #     sidebar_vote_hover_on($(this))
  #   , ->
  #     sidebar_vote_hover_off()

# On hover code for statement vote reveal

  $('.detail_body a').hoverIntent ->
    sidebar_hover_on($(this))
  , ->
    sidebar_hover_off()

# On hover + on click code for statement body sidebar view

  $('.detail_body a').click (e) ->
    e.preventDefault()
    if $('body').data("sidebar-locked") == true
      $('.block a, .textblock a').removeClass('activeStatementLightBlue')
      sidebar_hover_on($(this))
    else
      $('body').data("sidebar-locked", true)
    $(this).addClass('activeStatementLightBlue')
    $('.popup-box .close').show()
    $('.detail_body a').off('hover')

# Universal colse popup button on sidebar popup

  $('#close-popup').on 'click', (e) ->
    e.preventDefault()
    $('body').data("sidebar-locked", false)
    sidebar_hover_off()
    $('.detail_body a').hoverIntent ->
      sidebar_hover_on($(this))
    , ->
      sidebar_hover_off()

  # $('.new-detail').live 'click', (e) ->
  #    e.preventDefault()
  #    if $(this).data("detail-role") is "for-argument"
  #      #For first
  #      detail_type = $(this).data("detail-tyoe")
  #      target = $(this).parent().parent().children('.holding')
  #      template = $(this).data('partial')
  #      time = new Date().getTime()
  #      new_content = template.replace(/detail\[/g, detail_type + '['+time+'][')
  #      target.append(new_content)
  #      #Against now
  #      selector = $('.new-detail[data-detail-role="against-argument"]')
  #      detail_type = selector.data("detail-type")
  #      target = selector.parent().parent().children('.holding')
  #      template = selector.data('partial')
  #      time = new Date().getTime()
  #      new_content = template.replace(/detail\[/g, detail_type + '['+time+'][')
  #      target.append(new_content)
  #    else if $(this).data("detail-role") is "against-argument"
  #      #For first
  #      detail_type = $(this).data("detail-tyoe")
  #      target = $(this).parent().parent().children('.holding')
  #      template = $(this).data('partial')
  #      time = new Date().getTime()
  #      new_content = template.replace(/detail\[/g, detail_type + '['+time+'][')
  #      target.append(new_content)
  #      #Against now
  #      selector = $('.new-detail[data-detail-role="for-argument"]')
  #      detail_type = selector.data("detail-type")
  #      target = selector.parent().parent().children('.holding')
  #      template = selector.data('partial')
  #      time = new Date().getTime()
  #      new_content = template.replace(/detail\[/g, detail_type + '['+time+'][')
  #      target.append(new_content)
  #    else
  #      detail_type = $(this).data('detail-type')
  #      target = $(this).parent().parent().children('.holding')
  #      template = $(this).data('partial')
  #      time = new Date().getTime()
  #      new_content = template.replace(/detail\[/g, detail_type + '['+time+'][')
  #      target.append(new_content)



  query = $('#newsList').data("query")
  #getNews(query)

# Remove link from the 'On PolicyWiki' link section on Issue Edit page

  $('body').on 'click', '.removeLink', (e) ->
    e.preventDefault()

    name = $(this).parent().find('input[name^="issue[issue_links_attributes]"]').attr('name').replace(/\[[^\[\]]*\]$/, '[_destroy]')
    delete_this_link = $('<input type=hidden name="' + name + '" value="true">')
    $(this).parent().parent().parent().parent().append(delete_this_link)

    $(this).parent().parent().parent().remove()

# Hide dropdown search box when click on body

  $('body').click (e) ->
    $('#onPWsearchContainer').hide()
    # This sets text in search box back to nil when anything else is clicked
    # $("input[name='search-on-policy-wiki']").val("")

# On Policy Wiki search code END

  $('.activity-unflag').click (e) ->
    e.preventDefault()
    noty(
      text: 'Are you sure that you want to unflag that edit?',
      buttons: [
        {
          addClass: 'btn btn-primary btn-small',
          text: 'Yes',
          onClick: ($noty) =>
            $noty.close()
            $("#unflag-form-rule-break-report-#{$(this).data('rbr-id')}").submit()
        },
        {
          addClass: 'btn btn-danger btn-small',
          text: 'Cancel',
          onClick: ($noty) ->
            $noty.close()
        }
      ]
    )

  # This was in this selector:
  # $('#disable_edit, #disable_create').fancybox({
  # this caused an infinite loop, because when you clicked it clicked again
  # so we've had do to this hacky thing instead
  # we need the if because fancybox barfs and says it can't find the content box
  # on pages without it, which didn't matter when we had a JQ selector
  # puts "fun " * 9
  for name in ['#disable_edit','#disable_create']
    if $(name).length
      $.fancybox({
      href: '#disable_edit'
      'closeBtn': false
      'closeClick': false
      'afterLoad' : ->
        setTimeout(
          -> $("#fancybox-overlay").unbind()
          400)
      }).click()


# Disable Enter key in edit-form form
  $('#issue_title').keypress (event) ->
    event.preventDefault()  if event.which is 13

  $('#issueForm .text').keypress (event) ->
    event.preventDefault()  if event.which is 13

  $('#search-on-policy-wiki').keypress (event) ->
    event.preventDefault()  if event.which is 13

# Disable Enter key in new_issue form
  $('.new_issue').keypress (event) ->
    event.preventDefault()  if event.which is 13

# Add Should to new Page Title field
  $(document).ready ->
    title = $("#issue_title")
    if title.length and title.val() is ""
      title.val("Should ")

#Prevent deletetion of text in Page Title field
  $("#issue_title").keydown (evt) ->
    title = $("#issue_title")
    if title.length and title.val().length <= 6
      title.val(title.val() + " ")
      keycode = evt.charCode or evt.keyCode
      false  if keycode is 8 || 46


# Copy [contenteditable] data to nearby Form Textarea
#
$(document).on('focus','[contenteditable]',->
  target = $(@)
  target.data('before', target.html())
  target
)

$(document).on("blur", "#issue_tag_list", ->
  target = $(@)
  text = target.val().replace('#','')
  target.val(text)
  target
)

$(document).on('keydown', '[contenteditable]', (event)->
  if event.keyCode is 13
    lineBreak = document.createElement("br")
    sel = window.rangy.getSelection()
    range = sel.getRangeAt(0)
    # Remove last instance or LineBreak
    event.target.innerHTML = event.target.innerHTML.replace(/<br>$/,'') # Fix for Opera
    range.insertNode(lineBreak)
)

$(document).on('blur keyup','[contenteditable]',(event)->
  target = $(@)
  target.data('before', target.html())
  target.parent().find('textarea').val(target.html())
  target
)

$(document).on('paste','[contenteditable]',->
  target = $(@)
  setTimeout ->
    target.sanitizeHTML()
    target.parent().find('textarea').val(target.html())
    target
  , 10
)

# $(".editable").on("keydown", (e) ->
#   if e.which is 13
#     lineBreak = "<br>&nbsp;"
#     document.execCommand "insertHTML", false, lineBreak
#     $(this).html $(this).html().replace(/(<br>&nbsp;)/g, "<br>").replace(/(<br><br>)/g, "<br>")
#     false
# )

$(document).on("click",".add_source",(e) ->
  fallBackContenteditbale = $(@).parent().parent().find('[contenteditable]')
  if typeof document.getSelection is 'function'
    method = document
  else
    method = rangy

  sel =  method.getSelection()

  # Early exit if no selection is made.
  return if sel.rangeCount is 0

  range = sel.getRangeAt(0)

  # Do not display prompt if selection is blank.
  return if range.toString().length is 0

  processLink = ((link)->
    if link and link.length > 0
      rangy.surroundSelectionWithLink(range,link)

      if range.startContainer.nodeType isnt 1
        st = range.startContainer.parentNode
      else
        st = range.startContainer

      $(st).trigger('keyup')
      if st.parentNode.nodeName is "#document-fragment"
        $(fallBackContenteditbale).trigger('keyup')
  )

  currentURL = ""
  urlPlaceholder = "http://www.example.org/"
  target = range.commonAncestorContainer
  if target.nodeType isnt 1
    target = target.parentNode

  target = $(target)
  if target.prop('nodeName') is "A" and target.text() is range.toString()
    urlPlaceholder = target.prop('href')
    currentURL = " - Current URL: " + urlPlaceholder

  bootbox.animate(false)
  form = $('<div/>')
  form.append("<input autocomplete=off type=url placeholder=#{urlPlaceholder} autofocus>")
  div = bootbox.dialog(form, [
    {
      label: 'Cancel'
      callback: ->
        processLink(null)
    },
    {
      label: 'Add Link'
      callback: ->
        processLink(form.find('input').val())
    }
  ],
    header: '<style>.modal-header .close{display:none;}</style>Enter the URL of evidence which supports this statement '
  )
  div

  # bootbox.prompt("<style>.modal-header .close{display:none;}</style>Enter the URL of evidence which supports this statement " + currentURL, "Cancel", "Add Link", processLink, urlPlaceholder)
)

$(document).on("keydown", "input[name='search-on-policy-wiki']", (event) ->
  query = $(this).val()
  if query.length < 3
    $('#onPWsearchContainer').hide()
  else if query.length > 2
    $.ajax(
      url: '/search?search=' + encodeURIComponent(query)
      type: 'get',
      success: ((data) ->
        exclude_titles = $.map $('#linksHolder .statement-row [id$="title"]'), (elem) ->
          elem.value
        exclude_titles.push $('#linksHolder').data('current-issue-title')
        filtered_data = {results: []}
        $.each data.results, (i, elem)->
          if elem != undefined && $.inArray(elem['searchable']['title'], exclude_titles) is -1
            filtered_data.results.push data.results[i] #data.results.splice(i,1)

        $('#onPWsearchDropdown').html(HoganTemplates['issues/onpwresult'].render(filtered_data))
        $('#onPWsearchContainer').show()
      )
    )
)

$(document).on('click', ":not(#onPWsearchContainer)", ->
  $("#onPWsearchContainer").hide()
)

$(document).on('click', ".onpwresult_links", (event) ->
  event.preventDefault()
  id = event.target.getAttribute('data-id')

  tpl = $('#linksHolder .related-issue-template').clone()
  tpl.removeClass('related-issue-template')
  tpl.find('input').val(id)
  tpl.find('.title').text(event.target.getAttribute('title'))
  tpl.find('img').prop('src',$(event.target).find('img').prop('src'))
  tpl.find('a.remove-temp-related-issue').on('click', (e)->
    e.preventDefault()
    $(this).parents('.statement-row').remove()
  )
  tpl.show()
  $('#linksHolder').append(tpl)
)

$(document).on('click', "#statement_source", (e) ->
  sha = e.target.name
  e.preventDefault()
  window.open(window.location.origin + '/external_link/' + sha)
)

# infinite scroll for activity rendering
jQuery ->
  document.pageNum = 0
  document.loadingActivity = false
  if $('#activities').length > 0
    $(window).scroll ->
      if $(window).scrollTop() > $(document).height() - $(window).height() - 50 && document.pageNum >= 0 && !document.loadingActivity
        document.pageNum++
        document.loadingActivity = true
        $.getScript(window.location + ".js?page=" + document.pageNum)
  $('#clickOrScrollForMore').click( ->
    $(window).scroll()
    false
    )
  $('#modalAfterSaveShare').modal()
  url_pieces = window.location.href.split("#")
  if url_pieces.length == 2
    if tag = $('a')[url_pieces[1]]
      console.log tag
      tag.scrollIntoView()
      tag.click()
      tag.click() # twice to make it turn the sidebar on

  # When a Location Hash if provided, scroll to location with enough padding
  # for the header.
  if location.hash.length
    hash = location.hash
    elm = $("a[name=#{hash.split('#')[1]}]")
    if elm.length
      elm.trigger('click')
      elm.trigger('click')
      $('html,body').animate(
        {
          scrollTop: elm.offset().top - 125
        }
        500
      )

  if $('#newsList').length
    id = $('#newsList').data('id')
    $.ajax(
      dataType: 'json'
      url:"/api/issues/#{id}/other_sources"
      headers:
        'Authorization': 'Basic c2hvdWxkd2U6dHVlc2RheSFyZWQzMg=='
    ).success((response)->
      $.each(response, (index, item)->
        if(index < 4)
          date = new Date(item.updatedAt)
          dateString = $.datepicker.formatDate('d M yy', date)
          li = """
          <li>
            <a href="#{item.href}" target="_blank">
              <h3>#{item.title}</h3>
              <span class="publisher_text">#{item.source} #{dateString}</span>
            </a>
          </li>
          """
          elm = $(li)
          elm.hide()
          $('#newsList').append(elm)
      )
      $('#newsList li').each((index,elm) ->
        $(@).slideDown()
      )
    )
