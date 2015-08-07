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
  $('.commentOnActivity').on "click", (e) ->
    e.preventDefault()
    $(this).parent().parent().parent().parent().find('.comment-form-hidden').addClass('comment-form').removeClass('comment-form-hidden')
    $(this).remove()

#USED?

$ ->
  # used for voting on activities on history/activity page
  $('.vote-for, .vote-against').click (event) ->
    activity_id = $(this).data("activity-id")

    $.post($(this).attr('href'), null, (data) ->
      $('#votes_total_'+activity_id).text("(" + data + ")");
    )
    $('#vote-for-'+activity_id).toggle();
    $('#vote-against-'+activity_id).toggle();
    event.preventDefault()

