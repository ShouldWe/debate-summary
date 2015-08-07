describe("add_source",->
  fixture = $('<div id="fixture"></div>')
  compatibleMode = $('<meta http-equiv="X-UA-Compatible" id="compatible" content="IE=edge,chrome=1">')
  content = null
  beforeEach((done)->
    $('head').append(compatibleMode)
    $('body').append(fixture)
    setTimeout(done, 1);
  )

  afterEach(->
    $('body #fixture').empty()
    $('head #compatible').remove()
    $('body #fixture').remove()
    $('.bootbox').remove()
  )

  makeSelection = ((select)->
    # add range points
    html = content.html()
    html = html.replace(select, '<span id=start></span>'+select+'<span id=end></span>')
    content.html(html)

    range = rangy.createRange()

    # using range points, create range object
    startEl = $('#start',content)
    range.collapsed = true
    range.setStartBefore(startEl[0])
    endEl = $('#end',content)
    range.setEndAfter(endEl[0])

    content.focus()
    sel = window.rangy.getSelection()
    console.log('selection', sel);
    sel.removeAllRanges()
    sel.addRange(range)

    startEl.remove()
    endEl.remove()
  )

  it("requires rangy", ->
    expect(rangy.version).toEqual('1.3alpha.804')
  )

  it("inserts a new link",->
    content = $('<div contenteditable=true>Linked New Text</div>')
    fixture.append(content)

    makeSelection('New')
    rangy.surroundSelectionWithLink('http://www.example.com/new')

    expect(fixture.find('[contenteditable]').html().toLowerCase()).toEqual('Linked <a href="http://www.example.com/new">New</a> Text'.toLowerCase())
  )

  it("inserts a new link with other linked sections",->
    content = $('<div contenteditable><a href="http://www.example.com/">Before</a> Linked New Text</div>')
    fixture.append(content)

    makeSelection('New')
    rangy.surroundSelectionWithLink('http://www.example.com/new')

    expect(fixture.find('[contenteditable]').html().toLowerCase()).toEqual('<a href="http://www.example.com/">Before</a> Linked <a href="http://www.example.com/new">New</a> Text'.toLowerCase())
  )

  it("inserts a link inside a an exsisting link",->
    content = $('<div contenteditable><a href="http://www.example.com/">Linked New Text</a></div>')
    fixture.append(content)

    makeSelection('New')
    rangy.surroundSelectionWithLink('http://www.example.com/new')

    expect(fixture.find('[contenteditable]').html().toLowerCase()).toEqual('<a href="http://www.example.com/">Linked </a><a href="http://www.example.com/new">New</a><a href="http://www.example.com/"> Text</a>'.toLowerCase())
  )

  it("inserts a link inside a an exsisting link",->
    content = $('<div contenteditable><a href="http://www.example.com/">Linked New Text</a></div>')
    fixture.append(content)

    makeSelection('New')
    range = window.rangy.getSelection().getRangeAt(0)
    rangy.surroundSelectionWithLink(range, 'http://www.example.com/new')

    expect(fixture.find('[contenteditable]').html().toLowerCase()).toEqual('<a href="http://www.example.com/">Linked </a><a href="http://www.example.com/new">New</a><a href="http://www.example.com/"> Text</a>'.toLowerCase())
  )

  it("replaces link",->
    content = $('<div contenteditable><a href="http://www.example.com/">Linked New Text</a></div>')
    fixture.append(content)

    range = makeSelection('Linked New Text')
    rangy.surroundSelectionWithLink('http://www.example.com/replaced')

    expect(fixture.find('[contenteditable]').html().toLowerCase()).toEqual('<a href="http://www.example.com/replaced">Linked New Text</a>'.toLowerCase())
  )

  it("replaces link without effecting other content",->
    content = $('<div contenteditable><a href="http://www.example.com/before">before</a> <a href="http://www.example.com/">Linked New Text</a></div>')
    fixture.append(content)

    range = makeSelection('Linked New Text')
    rangy.surroundSelectionWithLink('http://www.example.com/replaced')

    expect(fixture.find('[contenteditable]').html().toLowerCase()).toEqual('<a href="http://www.example.com/before">before</a> <a href="http://www.example.com/replaced">Linked New Text</a>'.toLowerCase())
  )

  it("insets link wihtin two elements",->
    content = $('<div contenteditable><a href="http://www.example.com/">Linked <span id="start"></span>New</a> <a href="http://www.example.com/next">The<span id="end"></span> Text</a></div>')
    fixture.append(content)

    makeSelection("New The")
    rangy.surroundSelectionWithLink('http://www.example.com/added')

    expect(fixture.find('[contenteditable]').html().toLowerCase()).toEqual('<a href="http://www.example.com/">Linked </a><a href="http://www.example.com/added">New The</a><a href="http://www.example.com/next"> Text</a>'.toLowerCase())
  )

  it("insets link wihtin two elements",->
    # content = $('<div contenteditable><a href="http://www.exmaple.com">Before</a> <a href="http://www.example.com/">Linked <span id="start"></span>New</a> <a href="http://www.example.com/next">The<span id="end"></span> Text</a></div>')
    content = $('<div contenteditable><a href="http://www.exmaple.com/before">Before</a> <a href="http://www.example.com/">Linked <span id="start"></span>New</a> <a href="http://www.example.com/next">The<span id="end"></span> Text</a></div>')
    fixture.append(content)

    makeSelection("New The")
    rangy.surroundSelectionWithLink('http://www.example.com/added')

    expect(fixture.find('[contenteditable]').html().toLowerCase()).toEqual('<a href="http://www.exmaple.com/before">Before</a> <a href="http://www.example.com/">Linked </a><a href="http://www.example.com/added">New The</a><a href="http://www.example.com/next"> Text</a>'.toLowerCase())
  )

  it('accepts and santizes Microsoft Word pasted content', (done)->
    content = $('<div contenteditable=true><a href="http://www.example.com/">Linked New Text</a></div>')
    textarea = $('<textarea id="test"></textarea>')
    button = $("<button>",
      class: "add_source"
      text: "Add Link"
    )
    fixture.append(content)
    content.before(textarea)
    fixture.append(button)

    pasteMeta = """<!--[if gte mso 9]><xml>
     <o:DocumentProperties>
      <o:Template>Normal.dotm</o:Template>
      <o:Revision>0</o:Revision>
      <o:TotalTime>0</o:TotalTime>
      <o:Pages>1</o:Pages>
      <o:Words>15</o:Words>
      <o:Characters>90</o:Characters>
      <o:Company>MeKyel</o:Company>
      <o:Lines>1</o:Lines>
      <o:Paragraphs>1</o:Paragraphs>
      <o:CharactersWithSpaces>110</o:CharactersWithSpaces>
      <o:Version>12.0</o:Version>
     </o:DocumentProperties>
     <o:OfficeDocumentSettings>
      <o:AllowPNG/>
     </o:OfficeDocumentSettings>
    </xml><![endif]--><!--[if gte mso 9]><xml>
     <w:WordDocument>
      <w:Zoom>0</w:Zoom>
      <w:TrackMoves>false</w:TrackMoves>
      <w:TrackFormatting/>
      <w:PunctuationKerning/>
      <w:DrawingGridHorizontalSpacing>18 pt</w:DrawingGridHorizontalSpacing>
      <w:DrawingGridVerticalSpacing>18 pt</w:DrawingGridVerticalSpacing>
      <w:DisplayHorizontalDrawingGridEvery>0</w:DisplayHorizontalDrawingGridEvery>
      <w:DisplayVerticalDrawingGridEvery>0</w:DisplayVerticalDrawingGridEvery>
      <w:ValidateAgainstSchemas/>
      <w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid>
      <w:IgnoreMixedContent>false</w:IgnoreMixedContent>
      <w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText>
      <w:Compatibility>
       <w:BreakWrappedTables/>
       <w:DontGrowAutofit/>
       <w:DontAutofitConstrainedTables/>
       <w:DontVertAlignInTxbx/>
      </w:Compatibility>
     </w:WordDocument>
    </xml><![endif]--><!--[if gte mso 9]><xml>
     <w:LatentStyles DefLockedState="false" LatentStyleCount="276">
     </w:LatentStyles>
    </xml><![endif]-->

    <!--[if gte mso 10]>
    <style>
     /* Style Definitions */
    table.MsoNormalTable
            {mso-style-name:"Table Normal";
            mso-tstyle-rowband-size:0;
            mso-tstyle-colband-size:0;
            mso-style-noshow:yes;
            mso-style-parent:"";
            mso-padding-alt:0cm 5.4pt 0cm 5.4pt;
            mso-para-margin:0cm;
            mso-para-margin-bottom:.0001pt;
            mso-pagination:widow-orphan;
            font-size:12.0pt;
            font-family:"Times New Roman";
            mso-ascii-font-family:Cambria;
            mso-ascii-theme-font:minor-latin;
            mso-fareast-font-family:"Times New Roman";
            mso-fareast-theme-font:minor-fareast;
            mso-hansi-font-family:Cambria;
            mso-hansi-theme-font:minor-latin;
            mso-ansi-language:EN-US;}
    </style>
    <![endif]-->
    """
    fragment = """
    <!--StartFragment-->

    <p class="MsoNormal"><a href="http://gov.uk">Testing
    section</a><o:p></o:p></p>

    <p class="MsoNormal"><o:p>&nbsp;</o:p></p>

    <p class="MsoNormal"><o:p>&nbsp;</o:p></p>

    <p class="MsoNormal"><a href="http://www.gov.uk">Testing another section</a><o:p></o:p></p>

    <!--EndFragment-->"""


    dummy = """
    <!--[if gte mso 9]><xml>
     <o:OfficeDocumentSettings>
      <o:AllowPNG/>
     </o:OfficeDocumentSettings>
    </xml><![endif]-->
    <!--[if gte mso 9]><xml>
      <o:Something>AHH</o:Something>
    </xml><![endif]-->
    <!--[if gte mso 10]><xml>HELLO</xml><![endif]--><p>Hello</p>
    """

    pasteData = pasteMeta + fragment

    fixture.find('[contenteditable]').html(pasteData)
    fixture.find('[contenteditable]').trigger('paste')
    setTimeout(->
      expect(fixture.find('textarea').val()).not.toContain("&nbsp;")
      expect(fixture.find('textarea').val()).toContain('<a href="http://gov.uk">Testing section</a>')
      done();
    , 11)
  )

  it("intergrate with add source click", ->
    content = $('<div contenteditable><a href="http://www.example.com/">Linked New Text</a></div>')
    button = $("<button>",
      class: "add_source"
      text: "Add Link"
    )
    fixture.append(content)
    fixture.append(button)

    makeSelection('New')

    button.click()
    $(".bootbox input").val('http://www.example.com/new')
    $(".bootbox .btn-primary").trigger('click')

    expect(fixture.find('[contenteditable]').html().toLowerCase()).toEqual('<a href="http://www.example.com/">Linked </a><a href="http://www.example.com/new">New</a><a href="http://www.example.com/"> Text</a>'.toLowerCase())
  )

  it("has a default url of http://www.gov.uk", ->
    content = $('<div contenteditable><a href="http://www.example.com/">Linked New Text</a></div>')
    button = $("<button>",
      class: "add_source"
      text: "Add Link"
    )
    fixture.append(content)
    fixture.append(button)

    makeSelection('New')
    button.click()
    expect($('.bootbox input').prop('placeholder')).toEqual("http://www.example.org/")
  )

  it("has a default url of http://www.gov.uk", ->
    content = $('<div contenteditable>Linked New Text</div>')
    button = $("<button>",
      class: "add_source"
      text: "Add Link"
    )
    fixture.append(content)
    fixture.append(button)

    button.click()

    expect($('.bootbox').length).toEqual(0)
  )

  it("sets the placeholder url to the current selected URL", ->
    content = $('<div contenteditable><a href="http://www.example.com/">Linked New Text</a></div>')
    button = $("<button>",
      class: "add_source"
      text: "Add Link"
    )
    fixture.append(content)
    fixture.append(button)

    makeSelection('Linked New Text')
    button.click()

    expect($('.bootbox input').prop('placeholder')).toEqual("http://www.example.com/")
    expect($('.bootbox .modal-header h3').html()).toEqual("<style>.modal-header .close{display:none;}</style>Enter the URL of evidence which supports this statement ")
  )

  it("updates nearby textarea insert within",->
    content = $('<div contenteditable=true><a href="http://www.example.com/">Linked New Text</a></div>')
    textarea = $('<textarea id="test"></textarea>')
    button = $("<button>",
      class: "add_source"
      text: "Add Link"
    )
    fixture.append(content)
    content.before(textarea)
    fixture.append(button)

    makeSelection('New')
    button.click()

    $(".bootbox input").val('http://www.example.com/new')
    $(".bootbox .btn-primary").trigger('click')

    expect(fixture.find('[contenteditable]').html().toLowerCase()).toEqual('<a href="http://www.example.com/">Linked </a><a href="http://www.example.com/new">New</a><a href="http://www.example.com/"> Text</a>'.toLowerCase())
    expect(fixture.find('textarea').val().toLowerCase()).toEqual('<a href="http://www.example.com/">Linked </a><a href="http://www.example.com/new">New</a><a href="http://www.example.com/"> Text</a>'.toLowerCase())
  )

  it("updates nearby textarea with new instart",->
    content = $('<div contenteditable=true>Linked New Text</div>')
    textarea = $('<textarea id="test"></textarea>')
    button = $("<button>",
      class: "add_source"
      text: "Add Link"
    )
    fixture.append(content)
    content.before(textarea)
    fixture.append(button)

    makeSelection('New')
    button.click()

    $(".bootbox input").val('http://www.example.com/new')
    $(".bootbox .btn-primary").trigger('click')

    expect(fixture.find('textarea').val().toLowerCase()).toEqual('Linked <a href="http://www.example.com/new">New</a> Text'.toLowerCase())
  )

  it("updates nearby textarea with repalce type",->
    content = $('<div contenteditable=true>Linked <a href="http://www.example.com/old">New</a> Text</div>')
    textarea = $('<textarea id="test"></textarea>')
    button = $("<button>",
      class: "add_source"
      text: "Add Link"
    )
    fixture.append(content)
    content.before(textarea)
    fixture.append(button)

    makeSelection('New')
    button.click()

    $(".bootbox input").val('http://www.example.com/new')
    $(".bootbox .btn-primary").trigger('click')

    expect(fixture.find('textarea').val().toLowerCase()).toEqual('Linked <a href="http://www.example.com/new">New</a> Text'.toLowerCase())
  )

)
