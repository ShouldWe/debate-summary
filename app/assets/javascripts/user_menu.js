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

// Code for the dropdown 'Share This' menu shown on all pages

(function () {
  'use strict';
  var count = 1;

  function shareClick(){
    if(count === 0) { 
      count++;
      $( "#block1" ).animate( { height: "145px" }, { queue: false, duration: 500 });
    } else  { 
      count = 0;
    }
  }


  $(document).on('click', 'body', function() {
    $( "#block1" ).animate({ height: "50px"});
  });

  function shareHover(){
    count++;
    $( "#block1" ).animate( { height: "145px" }, { queue: false, duration: 500 });
  }

  $(document).on('click', '#go1', shareClick);
  $(document).on('mouseover', '#go1', shareHover);

}).call(this);
