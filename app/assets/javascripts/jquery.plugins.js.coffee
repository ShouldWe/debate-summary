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
#Sanitize HTML
$ = jQuery
$.fn.extend
  sanitizeHTML: (options) ->
    settings =
      leaveLinks: true
      debug: false

    settings = $.extend settings, options

    log = (msg) ->
      console?.log msg if settings.debug

    $(this).each (i, el) ->
      out = $.htmlClean($(el).html(),
        format: true
        allowedTags: ["a", "br"]
        allowedAttributes: [['href', ['a']]]
        allowedClasses: []
        allowComments: false
        allowEmpty: []
      )
      output = $('<div/>').html(out)
      output.find('a[href^="#_mso"], a[name^=_mso]').remove()
      output.find('a').after(' ')
      html = output.html()
      # extra cleaning Regular Expressions.
      html = html.replace('&nbsp;',' ')
      html = html.replace(/<!--\[[^\]]+\]>[\s|\S]*?<!\[endif\]-->/g,'')
      html = html.replace(/\s{2,}/,' ')

      $(el).html($.trim(html))

$.fn.extend
  insertAt: (index, element) ->
    lastIndex = this.children().size()
    if index < 0
      index = Math.max(0, lastIndex + 1 + index)

    this.append(element)
    if index < lastIndex
      this.children().eq(index).before(this.children().last())
    return this

$.fn.extend
  wordLimitCounter: (options) ->
    settings =
      limit: 200
      hardLimit: true

    settings = $.extend settings, options

    disableForm = (el) ->
      form = el.closest('form')
      if !form.data('prepared')
        form.on "submit", (e) ->
          counts = el.find('[data-word-count]').map(->
            this.getAttribute('data-word-count')
          ).get()
          if $.each(counts,checkCountAgainstSettings)
            return true
          else
            alert "Some of your fields are over #{settings.limit} words long, please correct this and try again."
            e.preventDefault()
      form.data("prepared", true)

    checkCountAgainstSettings = (el, index, array) ->
      el <= settings.limit

    processWordCount = (text, el) ->
      wordcount = 0
      if text
        check = $.trim(text).match(/\S+/g)
        wordcount = check.length if check
      delta = settings.limit - wordcount
      el.attr("data-word-count", wordcount)

      if delta < 0
        el.next('.area-counter').html "<span style='color:#DD0000;'>#{delta} words left. This form will not save unless you delete #{Math.abs(delta)} words.</span>"
      else
        el.next('.area-counter').html "#{delta} words left"


    $(this).each (i, el) ->
      obj = $(el)
      obj.after("<div class='area-counter'>Max. #{settings.limit} words</div>");

      text = obj.text()
      processWordCount(text, obj)
      if settings.hardLimit
        disableForm(obj)

      obj.on "keyup", (e) ->
        text = obj.text()
        processWordCount(text, obj)

      obj.on "paste", (e) ->
        setTimeout (->
          text = obj.text()
          processWordCount(text, obj)
        ), 300
