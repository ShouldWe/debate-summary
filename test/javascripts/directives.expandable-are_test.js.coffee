describe("ExpandableArea",->
  fixture = $('<div id="fixture"></div>')
  beforeEach(->
    $('body').append(fixture)
  )

  afterEach(->
    $('body #fixture').empty()
    $('body #fixture').remove()
  )
  describe("onClick 'delete-argument'",->
    it("displays confirmation on 'delete-argument'",->
      button = $("<button class='delete-argument'></button>")
      fixture.append(button)
      button.trigger('click')
      expect($(".bootbox .modal-body").text()).toEqual("Are you sure you would like to remove this argument?")
      expect($(".bootbox .modal-body").is(":visible")).toBeTruthy()
    )

    it("deletes element on 'delete-argument' confirmation",->

      button = $("<button class='delete-argument'></button>")
      container = $("<div class=\"area-container\"/>")
      container.append("<div class='area-content'/>")
      container.append("<div class='area-content'/>")
      container.find('.area-content').append(button)
      fixture.append(container)
      button.trigger('click')
      expect($(".area-content").length).toEqual(2)
      $(".bootbox .btn-primary").trigger('click')
      expect($(".area-content").length).toEqual(1)

    )

    it("clears the last element on 'delete-argument' confirmation",->
      button = $("<button class='delete-argument'>Delete</button>")
      container = $("<div class=\"area-container\"/>")
      content = $("<div class='area-content'/>")
      container.append(content)
      content.append("<input type='text' name='example' value='testing'/>")
      content.append("<div contenteditable=true>hello world</div>")
      container.find('.area-content').append(button)
      fixture.append(container)
      button.trigger('click')

      $(".bootbox .btn-primary").trigger('click')

      expect($(".area-content [contenteditable]").html()).toEqual("")
      expect($(".area-content input").val()).toEqual("")
      expect(button.text()).toEqual("Delete")
      expect($(".area-content").length).toEqual(1)
    )
  )

  describe("onNewAssignment",->
    it("adjusts the height of container",->
      box = $("<div class='area-boxes'><div style='position:absolute;height:50px;'>testing<br/>testing</div></div>")
      fixture.append(box)

      $(document).trigger('newAssignment')
      expect($('.area-boxes:first').css('height')).toEqual('50px')
    )
  )

  describe("onClick/onFocus 'area-arrow'",->
    container = null
    beforeEach(->
      button = $("<button class='delete-argument'>Delete</button>")
      container = $("<div class=\"area-box\"/>")
      content = $("<div class='area-content'>open</div>")
      content.append("<div class='area-arrow'/>")
      content.append("<input type='text' name='example' value='testing'/>")
      container.append(content)
      content.append("<div contenteditable=true>hello world</div>")
      container.find('.area-content').append(button)
      fixture.append(container)
    )
    describe("onClick",->
      it("shows content",->
        $('.area-arrow').trigger('click')

        expect($('.area-content').hasClass('open')).toBeTruthy()
        expect($('.area-box').hasClass('open')).toBeTruthy()
      )

      it("shows content and hides others",->
        fixture.append(container.clone())

        $('.area-arrow:first').trigger('click')
        $('.area-arrow:last').trigger('click')

        expect($('.area-content:first').hasClass('open')).toBeFalsy()
        expect($('.area-box:first').hasClass('open')).toBeFalsy()

        expect($('.area-content:last').hasClass('open')).toBeTruthy()
        expect($('.area-box:last').hasClass('open')).toBeTruthy()
      )
    )

    describe("onFocus",->
      it("shows content", (done)->
        $(':input').trigger('focus')
        setTimeout(->
          expect($('.area-content').hasClass('open')).toBeTruthy()
          expect($('.area-box').hasClass('open')).toBeTruthy()
          done()
        )
      )

      it("shows content and hides others",->
        fixture.append(container.clone())

        $(':input:first').trigger('focus')
        $(':input:last').trigger('focus')

        expect($('.area-content:first').hasClass('open')).toBeFalsy()
        expect($('.area-box:first').hasClass('open')).toBeFalsy()

        expect($('.area-content:last').hasClass('open')).toBeTruthy()
        expect($('.area-box:last').hasClass('open')).toBeTruthy()
      )
    )
  )

  describe("onClick 'new-argument'",->
    beforeEach(->
      button = $("<button class='delete-argument'>Delete</button>")
      container = $("<div class=\"area-box\"/>")
      content = $("<div class='area-content' data-id='1'>open</div>")
      content.append("<div class='area-arrow'/>")
      content.append("<input type='text' name='param[1][title]' value='testing'/>")
      container.append(content)
      content.append("<div contenteditable=true>hello world</div>")
      container.find('.area-content').append(button)
      container.append('<button class="new-argument"/>')
      fixture.append(container)
    )
    it("clones and appends last argument",->
      $('.new-argument').click()
      expect($('.area-content:last :input').val()).toEqual("")
      expect($(".area-content:last [contenteditable]").html()).toEqual("")
      expect($('.area-content:last :input').prop('name')).not.toEqual("param[1][title]")
      expect($('.area-content').length).toEqual(2)

      $('.new-argument').click()

      expect($('.area-content:last :input').prop('name')).not.toEqual($('.area-content:eq(1) :input').prop('name'))
      expect($('.area-content').length).toEqual(3)
    )
  )
)
