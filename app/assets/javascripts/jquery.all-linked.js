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

/*
 * Plugin: allLinked
 * jQuery plugin to check that a text area text is all wrapped with anchor tags
 * http://jsfiddle.net/halfcube/L4dfK/
 *
 * Author: Kyle Welsby
 * http://mekyle.com
 */

(function ($) {
    $.fn.allLinked = function () {
        var o, t, v;
        if (this.is('textarea')) {
          v = this.val();
        } else {
          v = this.html();
        }
        o = $('<div/>').html($.trim(v));
        t = o.text();
        o.find('a').each(function () {
            t = t.replace($(this).text(), "");
        });
        return $.trim(t).length === 0;
    };
})(jQuery);
