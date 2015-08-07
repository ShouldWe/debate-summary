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
rangy.createModule('SafeWrapLink', (api,module)->
  replaceTargetWith = ((target, selectionText, href)->
    target = $(target)
    currentLink = target.prop('href')
    parentNode = target.parent()
    fullText = target.text()

    before = fullText.match(new RegExp("^(.*)" + selectionText))[1]
    after = fullText.match(new RegExp(selectionText + "(.*)$"))[1]

    # Build link for before selection
    beforeLink = $('<a>',
      href: currentLink
      text: before
    )

    # Build link to insert
    link = $('<a>', 
      href: href
      text: selectionText
    )
    
    # Build link for after selection
    afterLink = $('<a>',
      href: currentLink
      text: after
    )

    # Append the links in order
    target.after(link)
    target.remove()

    link.before(beforeLink) if beforeLink.text().length > 0
    link.after(afterLink) if afterLink.text().length > 0
    link.parent()

  )

  insertWith = ((range,href)->
    fragments = range.extractContents()
    link = $("<a>",
      href: href
    )
    for child in fragments.childNodes
      link.text( link.text() + $(child).text() )
    
    range.insertNode(link[0])
    unless range.collapsed
      range.removeContents()

  )

  surroundSelectionWithLink = ((range, href) ->
    if typeof range is "string"
      # get current page selection
      href = range
      range = window.rangy.getSelection().getRangeAt(0)

    selectionText = range.toString()
    target = range.commonAncestorContainer
    target = target.parentNode if target.nodeType isnt 1

    if target.nodeName is "A"
      replaceTargetWith(target,selectionText,href)

    else if target.childNodes.length > 1 and target.childNodes[0].nodeName isnt "#text"
      insertWith(range,href)

    else
      try
        link = $("<a>",
          href: href
        )[0]
        range.surroundContents(link)
      catch err
        bootbox.alert("Sorry the selection you have made can not be wrapped with a link.\nPlease make a different selection.")

  )

  api.util.extend(api,{
    surroundSelectionWithLink: surroundSelectionWithLink
  })
)
