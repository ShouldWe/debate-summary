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
  $('.twitter-share').click((e)->
    isSidebar = $(e.target).parents('#sidesocial').length > 0
    params = []
    params.push "hashtags=DebateSummary"
    if isSidebar
      params.push "text=#{[shareTitle(),shareText()].join(':').substring(0,120)}"
    else
      params.push "text=#{shareTitle()}"
    params.push "url=#{urlLocation(isSidebar)}"
    params = params.join('&')
    url    = "https://twitter.com/share?#{params}"
    sharePopup('twitter',url)
  )

  $('.facebook-share').click((e)->
    isSidebar = $(e.target).parents('#sidesocial').length > 0
    redirectUri = encodeURIComponent("#{window.location.protocol}//#{window.location.host}/popupclose.html")
    params = []
    params.push "app_id=<%= ENV['FACEBOOK_API_KEY'] %>"
    params.push "link=#{urlLocation(isSidebar)}"
    params.push "image=#{shareImage()}"
    params.push "name=#{shareTitle()}"
    params.push "description=#{shareText()}" if isSidebar
    params.push "redirect_uri=#{redirectUri}"
    params.push "display=popup"
    params = params.join('&')
    url    = "https://www.facebook.com/dialog/feed?#{params}"
    sharePopup('facebook',url)
  )

  $('.linkedin-share').click((e)->
    isSidebar = $(e.target).parents('#sidesocial').length > 0
    params = []
    params.push "mini=true"
    params.push "title=#{shareTitle()}"
    params.push "summary=#{shareText()}"
    params.push "url=#{urlLocation(isSidebar)}"
    params.push "source=#{location.protocol}//#{location.host}"
    params = params.join('&')

    url = "http://www.linkedin.com/shareArticle?#{params}"
    sharePopup('linkedin',url)
  )

shareImage = ->
  return encodeURIComponent($('#share-image').prop('src'))

shareTitle = ()->
  theText = $('.issue-header')
  if theText.length > 0
    theText = $.trim(theText.text())
  else
    theText = $('.userHeading h2')
    if theText.length > 0
      theText = $.trim(theText.text())
    else
      theText = $('.heading h2')
      if theText.length > 0
        theText = $.trim(theText.text())
      else
        theText = "Debate Summary: Croudsource Arguments and Debates"

  return encodeURIComponent(theText)

shareText = ->
  escape $.trim($('#statement_body').text())

sharePopup = (name, url) ->
  width  = 575
  height = 400
  left   = ($(window).width()  - width)  / 2
  top    = ($(window).height() - height) / 2
  options = []
  options.push "status=1"
  options.push "width=#{width}"
  options.push "height=#{height}"
  options.push "top=#{top}"
  options.push "left=#{left}"
  options = options.join(',')
  window.open(url, name, options)

urlLocation = (isSidebar)->
  if isSidebar
    url = $('#detail_target_href').val()
  else
    url = location.protocol + "//" + location.host + location.pathname
  return encodeURIComponent(url)
