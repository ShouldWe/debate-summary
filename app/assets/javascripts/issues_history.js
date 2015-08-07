/*
 * Debate Summary - Croudsource arguments and debates
 * Copyright (C) 2015 Policy Wiki Educational Foundation LTD <hello@shouldwe.org>
 *
 * This file is part of Debate Summary.
 *
 * Debate Summary is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Debate Summary is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Debate Summary.  If not, see <http://www.gnu.org/licenses/>.
 */

// Comment dispaly code for Histroy and Statement pages

jQuery(function($) {
    $(".show-more-comments a")
        .click(function(event) {
            var activityId = $(this).data('activityId');

            $("#show-more-comments-loading-"+activityId).show();
            $("#show-more-comments-error-"+activityId).hide();

            $.get($(this).attr('href'))
                .success(function(data) {
                    $("#comment-list-"+activityId).html(data);
                    $("#show-more-comments-"+activityId).hide();
                })
                .error(function(data) {
                    $("#show-more-comments-error-"+activityId).show();
                })
                .complete(function() {
                    $("#show-more-comments-loading-"+activityId).hide();
                });
            event.preventDefault();
        });
});