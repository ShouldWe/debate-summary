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
rails_id = ($elem) ->
  tmp = $elem.attr('id').split('_')
  if (tmp.length > 1)
    return tmp[tmp.length - 1]
 
# Old news code for Google news. Now replaced by Bing in Issue controller
   
getNews = (searchTerms) ->
  query = encodeURIComponent searchTerms
  rssurl = ''
  $.ajax 
    url: rssurl,
    dataType: 'jsonp',
    jsonp: 'callback',
    jsonpCallback: 'parseNews'
        
parseNews = (json) ->
  $.each json.responseData.results, (index, result) ->
    title = Utils.htmlDecode result.titleNoFormatting
    publisher = Utils.htmlDecode result.publisher
    if (Utils.htmlDecode result.publisher != '' )
      imageUrl = Utils.htmlDecode result.image.url
    else
      imageUrl = "http://placehold.it/200x140"
    url = result.url
    url1 = url.replace(/%3A/g, ':')
    newurl = url1.replace(/%2F/g, '/')
    link = $('<a/>').text(title).attr('href', newurl).attr('target', 'blank')
    link.append $('<br /><span class="publisher_text">' + publisher + '</span>')
    link.prepend $('<div class="publisher_image"><img src="' + imageUrl + '" class="publisher_image_size"></span>')
    html = $('<li/>').html(link)
    $('#newsList').append(html)
        
window.getNews = getNews
window.parseNews = parseNews


# $ ->
#   $('.intro p').on "click", (e) ->
#     $(this).remove()
    # if $('.intro p').size() == 0
    #   $('.intro').remove()


window.Utils = {}

#Encode HTML Entities
htmlEncode = (value) ->
  if value
    $('<div/>').text(value).html()
  else 
    ''
window.Utils.htmlEncode = htmlEncode
    
#Decode HTML Entities
htmlDecode = (value) ->
  if value
    $('<div/>').html(value).text()
  else
    ''
window.Utils.htmlDecode = htmlDecode

#Reset Sidebar for Issues Page editing
resetEditSidebar = (sidebar, title, description, thinkAbout) ->
  data = {title: title, description: description, thinkabout: thinkAbout}
  html = HoganTemplates['issues/edit-sidebar'].render(data)
  $('#popup-sidebar').replaceWith(html)
window.Utils.resetEditSidebar = resetEditSidebar
