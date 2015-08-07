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

// Issue edit page preview uploaded image

$('input[type=file]').change(function(e) {
    if(typeof FileReader == "undefined") return true;

    var elem = $(this);
    var files = e.target.files;

    for (var i=0, file; file=files[i]; i++) {
        if (file.type.match('image.*')) {
            var reader = new FileReader();
            reader.onload = (function(theFile) {
                return function(e) {
                    var image = e.target.result;
                    previewDiv = $('.file-preview');
                    bgWidth = previewDiv.width() * 2;
                    previewDiv.css({
                        "background-size":"100%, auto",
                        "background-position":"50%, 50%",
                        "background-image":"url("+image+")",
                    });
                };
            })(file);
            reader.readAsDataURL(file);
        }
    }
});