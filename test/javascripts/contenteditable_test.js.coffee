describe("contenteditable", ->
  textarea = $('<textarea></textarea>')
  contenteditable = $('<div contenteditable="true"></div>')
  tag_list = $('<input type="text" id="issue_tag_list" />')
  fixture = $('<div id="fixture"></div>')
  beforeEach(->
    textarea.val('')
    contenteditable.empty()
    tag_list.empty()
    fixture.empty()
    fixture.prepend(textarea)
    fixture.append(contenteditable)
    fixture.append(tag_list)

    $('body').append(fixture)
  )

  afterEach(->
    $("body #fixture").empty()
    $('body #fixture').remove()
    # contenteditable.empty()
    contenteditable.removeData('before')
  )

  describe("onFocus", ->
    xit("sets data-before to the current content", ->
      string = '<a href="http://example.com/">Hello World</a>'
      contenteditable.append(string)
      contenteditable.trigger('focus')
      expect(contenteditable.data('before').toLowerCase()).toEqual(string.toLowerCase())
    )
  )

  describe("onBlur", ->
    it("sets data-before to the current content", ->
      string = '<a href="http://example.com/">Hello World</a>'
      contenteditable.append(string)
      contenteditable.trigger('blur')
      expect(contenteditable.data('before').toLowerCase()).toEqual(string.toLowerCase())
    )

    it("sets textarea to the current content", ->
      string = '<a href="http://example.com/">Hello World</a>'
      contenteditable.append(string)
      contenteditable.trigger('blur')
      expect(textarea.val().toLowerCase()).toEqual(string.toLowerCase())
    )
  )

  describe("#tag_list onKeyPress", ->
    it("disables # on tag-list field", ->
      tag_list.val('#something')
      tag_list.trigger('keypress')
      expect(tag_list.val()).toEqual("#something")
    )
  )

  describe("#tag_list onKeyUp", ->
    it("doesn't modify the user input", ->
      tag_list.val('#something')
      tag_list.trigger('keyup')
      expect(tag_list.val()).toEqual("#something")
    )
  )

  describe("#tag_list blur", ->
    it("removes Hash characters", ->
      tag_list.val('#something')
      tag_list.trigger('blur')
      expect(tag_list.val()).toEqual("something")
    )
  )

  describe("[contenteditable] onKeyDown", ->
    it("adds a line break on return",->
      contenteditable.html("hello world<span id=end></span>")
      range = window.rangy.createRange()
      range.setStartBefore($('#end')[0])
      range.setEndBefore($('#end')[0])
      contenteditable.trigger('focus')
      sel = window.rangy.getSelection()
      sel.removeAllRanges()
      sel.addRange(range)
      $('#end').remove()
      event = $.Event('keydown', {keyCode: 13, which: 13})
      contenteditable.trigger(event)
      expect(contenteditable.html().toLowerCase()).toEqual("hello world<br>")
    )
  )

  describe("[contentediable] onKeyUp", ->
    it("sets data-before to the current content", ->
      string = '<a href="http://example.com/">Hello World</a>'
      contenteditable.append(string)
      contenteditable.trigger('keyup')
      expect(contenteditable.data('before').toLowerCase()).toEqual(string.toLowerCase())
    )

    it("sets textarea to the current content", ->
      string = '<a href="http://example.com/">Hello World</a>'
      contenteditable.append(string)
      contenteditable.trigger('keyup')
      expect(textarea.val().toLowerCase()).toEqual(string.toLowerCase())
    )
  )

  describe("onPaste", ->
    it("sets textarea to the current content", (done)->
      string = '<a href="http://example.com/">Hello World</a>'
      contenteditable.append(string)
      event = $.Event('paste')
      contenteditable.trigger(event)
      setTimeout(->
        expect(textarea.val().toLowerCase()).toEqual(string.toLowerCase())
        done()
      , 100)
    )

    it("sanitizes content", (done)->
      anchor = '<a href="http://example.com/">Hello World</a>'
      string = '<table><tr><td>'+anchor+'</td></tr></table> something else'
      contenteditable.append(string)
      event = $.Event('paste')
      contenteditable.trigger(event)
      expected = "#{anchor} something else"
      setTimeout(->
        expect(contenteditable.html().toLowerCase()).toEqual(expected.toLowerCase())
        expect(textarea.val().toLowerCase()).toEqual(expected.toLowerCase())
        done()
      , 100)
    )
  )
)
