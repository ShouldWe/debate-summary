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
# Code for search box on main page

$ ->
	$('.search-form').submit (e) ->
		e.preventDefault()

	$('.search-form [name=search]').keydown (e) ->
    if e.keyCode == 38 or e.keyCode == 40
      if $('#searchContainer').is(':visible')
        e.preventDefault()
    else
		  query = $(this).val()
		  if query.length < 3
			  $('#searchContainer').hide()
		  else if query.length > 2
        $('#searchDropdown').html("Searching...")
        $('#searchContainer').show()
        $.ajax
          url: '/search?search=' + encodeURIComponent(query)
          type: 'get',
          success: (data) ->
            $('#searchDropdown').html(HoganTemplates['search/result'].render(data))
            $('#searchContainer').show()
          error: (data,error_text,errorThrown) ->
            console.log data
            console.log error_text
            console.log errorThrown

  $('#searchDropdown').mouseenter (e) ->


  $('body').click (e) ->
    $('#searchContainer').hide()
    $('.search-form').find('[name=search]').val("")

  $('#searchDropdown').click (e) ->
    e.stopPropagation()

# Disable Enter key in main search box
  $('#searchHome').keypress (event) ->
    event.preventDefault()  if event.which is 13
# Disable Enter key in top nav search box
  $('#search').keypress (event) ->
    event.preventDefault()  if event.which is 13
