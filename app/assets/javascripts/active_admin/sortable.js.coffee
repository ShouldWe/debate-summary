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

# controlpanel/settings code fro sorting results numbers and settings

	container = $('.sortableSettings')
	$('#settingsSorter').on "click", "a", (e) ->
		e.preventDefault()
		$('#settingsSorter').find('.selected').removeClass("selected")
		container.find('input').attr('disabled', 'disabled')
		if $(this).data("category") == "All"
			container.children('li').show()
			container.find('input').removeAttr('disabled')
		else
			container.children('li').hide()
			show_fields = container.find('li[data-categorisation="'+$(this).data("category")+'"]')
			show_fields.find('input').removeAttr('disabled')
			show_fields.show()
		$(this).parent('li').addClass("selected")