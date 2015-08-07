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
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->

# JS for Suggest title section on main Issue page
	
# Suggest title fancybox

	$('#suggestTitleLink').click (e) ->
		e.preventDefault()
		data = {issue_id: $(this).data("issue-id")}
		html = HoganTemplates['issues/suggest_title'].render(data)
		$.fancybox
			content: html,
			padding: 20

# Vote on tiltle code
	
	$('#voteTitleLink').click (e) ->
		e.preventDefault()
		$.ajax
			url: "/issues/" + $(this).data("issue-id") + "/suggested_titles.json"
			success: (data) ->
				html = HoganTemplates['issues/vote_titles'].render(data)
				$.fancybox
					content: html,
					padding: 20

# Submit vote
					
	$('body').on 'click', 'a.voteForLink', (e) ->
		e.preventDefault()
		title_id = $(this).data('title-id')
		$.ajax
			url: '/issue_titles/' + title_id + '/vote.json',
			type: 'post',
			format: 'json',
			success: (data) ->
				$('a.voteForLink').remove()
				$.each data, (index, item) ->
					html = HoganTemplates['issues/title_votes_cast'].render(item)
					$('li[data-id="'+item.id+'"] h4[data-role="title"]').append(html)
				footer = $('<p/>').text("Thank you for voting.").addClass("footer")
				$('section#titleVoting').append(footer)

# Submit suggested title
					
	$('body').on 'submit', 'form#suggestTitleForm', (e) ->
		e.preventDefault()
		form = $(this)
		$.ajax
			url: "/issue_titles/suggest.json",
			data: form.serialize(),
			type: "post",
			success: (data) ->
				html = HoganTemplates['issues/suggest_success'].render()
				$.fancybox.close()
				$.fancybox
					content: html,
					padding: 20
