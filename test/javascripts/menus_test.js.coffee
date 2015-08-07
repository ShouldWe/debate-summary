describe('menus.js.coffee', ->
  menu = $('<div id="user-menu">Hello World</div>')
  hoverContent = $('<div class="user-box"/>')
  fixture = $('<div id="fixture"/>')
  beforeEach(->
    hoverContent.append(menu)
    fixture.append(hoverContent)
    hoverContent.find('#user-menu').hide()
    $("body").append(fixture)
  )
  afterEach(->
    $('body #fixture').remove()
  )

  describe("bind hoverIntent to user-box", ->
    it("shows the menu", (done)->
      event = $.Event('mouseenter.hoverIntent', pageX: 1, pageY:1 )
      hoverContent.trigger(event)
      setTimeout(->
        event = $.Event('mousemove.hoverIntent', pageX: 10, pageY:10 )
        hoverContent.trigger(event)
        setTimeout(->
          expect(menu.is(':visible')).toBeTruthy()
          done()
        , 300)
      , 100)
    )

    it("hides the menu", (done)->
      event = $.Event('mouseenter.hoverIntent', pageX: 1, pageY:1 )
      hoverContent.trigger(event)
      setTimeout(->
        event = $.Event('mousemove.hoverIntent', pageX: 10, pageY:10 )
        hoverContent.trigger(event)
        setTimeout(->
          event = $.Event('mouseleave.hoverIntent', pageX: 20, pageY:20 )
          hoverContent.trigger(event)
          setTimeout(->
            event = $.Event('mousemove.hoverIntent', pageX: 100, pageY:100 )
            hoverContent.trigger(event)
            setTimeout(->
              expect(menu.is(':visible')).toBeFalsy()
              done()
            , 200)
          , 100)
        , 100)
      , 100)
    )
  )
)
