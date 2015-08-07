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

# This is old JS for adjudication process that is no longer used although the link ID is still used

	$('a#adjudicationRequest').click (e) ->
		e.preventDefault()
		$.get "/pages/dispute-process.json", (data) ->
			html = HoganTemplates['issues/request_adjudication'].render(data)
			$.fancybox
				content: html,
				padding: 20
	
	$('body').on "click", '#cancelAdjudicationRequest', (e) ->
		$.fancybox.close()
		e.preventDefault()
	
	$('body').on "click", '#requestAdjudicationRequest', (e) ->
		$.fancybox.close()
		$.get window.location.pathname + ".json", (data) ->
			html = HoganTemplates['issues/select_for_adjudication'].render(data)
			$.fancybox
				content: html,
				padding: 20
		e.preventDefault()
