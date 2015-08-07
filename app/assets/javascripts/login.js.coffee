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
# Code for model login box

$ ->
  $('body').on "click", '#loginLink', (e) ->
    e.preventDefault()
    width = 1028
    height = 480
    left = (screen.width/2)-(width/2)
    top = (screen.height/2)-(height/2)
    newWindow = window.open(
      "/sm_login/pick_method",
      "sm_login",
      "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width=#{width}, height=#{height}, top=#{top}, left=#{left}"
    )
    if(window.focus)
      newWindow.focus()
