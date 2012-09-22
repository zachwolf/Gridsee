do(window = window, $ = jQuery) ->
  $ ->
    Gridsee         =
    window.Gridsee  =
      origin  : 
        x       : 0
        y       : 0
      colors  :
        rule    : "#f0f"

    key       = {}
    rules     = {}
    _selected = {}

    console   = window.console # delete me

    ns        = "gridsee"
    cssClass  =
      rule        : "#{ns}-rule"
      active      : "#{ns}-rule-active"
      ruler       : "#{ns}-ruler"

    elements  = 
      body        : $ document.body
      window      : $ @
      wrap        : $("<div />",
                      id    : "#{ns}-wrap"
                    ).appendTo document.body
      headrule    : $("<div />",
                      id    : "#{ns}-head-rule"
                      class : cssClass.ruler
                    ).appendTo document.body
      siderule    : $("<div />",
                      id    : "#{ns}-side-rule"
                      class : cssClass.ruler
                    ).appendTo document.body
      cornerrule  : $("<div />",
                      id    : "#{ns}-corner-rule"
                      class : cssClass.ruler
                    ).appendTo document.body
      rules       : -> 
                      arr = []
                      for key, rule of rules
                        arr[arr.length] = rule.element
                      return arr
      selected    : (type) -> 
                      arr = []
                      for key, rule of _selected
                        if rule.name is type then arr[arr.length] = rule
                      return arr
    
    objLength   = (obj) ->
                    size = 0
                    for key of obj
                      if obj.hasOwnProperty(key) then size++
                    return size

    key.compare = (e, keys) ->
                    modList = ["alt","ctrl","meta","shift"]
                    for mod in modList
                      mod = "#{mod}Key"
                      if keys.indexOf(mod) >= 0
                        if !e[mod]
                          return false
                      else
                        if e[mod]
                          return false
                    return true

    zIndex    =
      base        : 10e5
      activeGuide : 10e5 + 1
      setter      : 10e5 + 2
      ruler       : 10e5 + 3
      pixelMarker : 10e5 + 4

    keys      =
      up          : 38
      down        : 40
      left        : 37
      right       : 39

    class __Rules
      constructor   : ->

      get           : ->
        return ( =>
          arr = []
          for key, rule of @
            if rule.element
              arr[arr.length] = rule.element
          return arr
        )()
      
      clear         : ->
        console.log @

    selectTest = new __Rules()

    # class Rules 
    #   constructor   : ->
    #   save          : ->

    class Timer
      constructor   : ->
        @tick    = ->
        @enabled = false
        window.requestAnimFrame = ( ->
                                    @requestAnimationFrame       || 
                                    @webkitRequestAnimationFrame || 
                                    @mozRequestAnimationFrame    || 
                                    @oRequestAnimationFrame      || 
                                    @msRequestAnimationFrame     || 
                                    (callback) ->
                                      @setTimeout callback, 1000 / 60
                                      return
                                  )()
      start         : ->
        @enabled = true
        animloop = =>
          requestAnimFrame animloop if @enabled is true
          @tick()
          return
        animloop()
        return
        
      stop          : ->
        @enabled = false      

    class Rule
      constructor   : ->
        @name               = "Rule"
        @selected           = false
        @id                 = objLength rules
        @element            = $ "<div />",
                                class   : cssClass.rule
                              .on "mousedown", (e) =>
                                allTheRightKeys = key.compare e, ["shiftKey", "metaKey"]

                                if allTheRightKeys
                                  if @selected
                                    @deselect.call @
                                  else 
                                    @select()
                                else
                                  if !@selected
                                    if !!objLength _selected
                                      @deselect.call _selected
                                    @select()
                                return         
        @pos  =
          x : undefined
          y : undefined

        rules[@id] = @
        selectTest[@id] = @

        console.log selectTest "yeah", selectTest.get()

        @mover = new Mover @element

        @mover.init       = (e) ->
          @origin   =
            x : e.pageX
            y : e.pageY
          @moveThese =
            x : elements.selected "Hrule"
            y : elements.selected "Vrule"

          if @moveThese.y
            for _vrule in @moveThese.y
              _vrule.dif = e.pageY - _vrule.pos.y

          if @moveThese.x
            for _hrule in @moveThese.x
              _hrule.dif = e.pageX - _hrule.pos.x

        @mover.mousemove  = (e) ->
          if @moveThese.y
            for _vrule in @moveThese.y
              _vrule.element.css "top", e.pageY - _vrule.dif

          if @moveThese.x
            for _hrule in @moveThese.x
              _hrule.element.css "left", e.pageX - _hrule.dif

        @mover.mouseup    = (e) ->
          if @moveThese.y
            for _vrule in @moveThese.y
              _vrule.pos.y = e.pageY - _vrule.dif

          if @moveThese.x
            for _hrule in @moveThese.x
              _hrule.pos.x = e.pageX - _hrule.dif

      select        : ->
        @selected   = true
        @element.addClass cssClass.active
        _selected[@id] = @
        return

      deselect      : ->
        _deselect = ->
          @selected   = false
          @element.removeClass cssClass.active
          delete _selected[@id]
        
        if @ is _selected 
          for k, v of @
            _deselect.call v
        else 
          _deselect.call @

      delete        : ->

    class Vrule extends Rule
      constructor   : ->
        super()
        @name = "Vrule"
        @element
          .addClass(@name)
          .css
            height  : 1
            left    : 0
            right   : 0
          .appendTo elements.wrap
      select        : ->
        super()
        @pos =
          y         : parseInt @element.css("top"), 10

    class Hrule extends Rule
      constructor   : ->
        super()
        @name = "Hrule"
        @element
          .addClass(@name)
          .css
            width   : 1
            top     : 0
            bottom  : 0
          .appendTo elements.wrap
      select        : ->
        super()
        @pos = 
          x         : parseInt @element.css("left"), 10

    class Setter extends Timer
      constructor   : ->
        super()
        @el   = {}
        @v    = new Vrule()
        @$v   = @v.element
        @h    = new Hrule()
        @$h   = @h.element
        @pos  =
          x : undefined
          y : undefined
        @prev =
          x : undefined
          y : undefined

        @$v
          .css
            "background"  : "#f0f"
            zIndex        : zIndex.setter
          .hide()
        @$h
          .css
            "background"  : "#f0f"
            zIndex        : zIndex.setter
          .hide()

        @tick = ->
          if @pos.x and @pos.y
            if @prev.x isnt @pos.x then @$h.css "left", @pos.x
            if @prev.x isnt @pos.x then @$v.css "top", @pos.y
          @prev.x = @pos.x
          @prev.y = @pos.y

      start         : ->
        super()
        @$v.show()
        @$h.show()
      stop          : ->
        super()
        @$v.hide()
        @$h.hide()
        Gridsee.origin.x = @pos.x
        Gridsee.origin.y = @pos.y

      update        : (x,y) ->
        @pos.x = x
        @pos.y = y

    class Mover
      constructor   : ($el, trigger) ->
        @$el        = $el
        @init       = ->
        @mousemove  = ->
        @mouseup    = ->

        @$el.on "mousedown.#{ns}", (e) =>
          e.preventDefault()
          @init e
          elements.window
            .on "mousemove.#{ns}", (e) =>
              @mousemove e
            .on "mouseup.#{ns}", (e) =>
              @mouseup e, $el
              elements.window.off "mousemove.#{ns}"
              elements.window.off "mouseup.#{ns}"
        if trigger then $el.trigger "mousedown.#{ns}" 

    $setter = new Setter()

    corner = new Mover elements.cornerrule
    corner.init       = -> 
      $setter.start()
    corner.mousemove  = (e) ->
      $setter.update e.pageX, e.pageY
    corner.mouseup    = ->
      $setter.stop()

    head = new Mover elements.headrule
    head.init       = -> 
      @rule  = new Vrule()
      @rule.deselect.call _selected
      @$rule = @rule.element
    head.mousemove  = (e) ->
      @$rule.css "top", e.pageY
    head.mouseup    = (e, $el) ->
      @rule.pos.y = $el.pageY
      @rule.select()

    side = new Mover elements.siderule
    side.init       = -> 
      @rule  = new Hrule()
      @rule.deselect.call _selected
      @$rule = @rule.element
    side.mousemove  = (e) ->
      @$rule.css "left", e.pageX
    side.mouseup    = (e, $el) ->
      @rule.pos.x = $el.pageX
      @rule.select()

    elements.window.on "keydown", (e) ->
      if key.compare e, []
        switch e.keyCode
          when keys.up
            for k, rule of _selected
              if rule.name is "Vrule"
                top = parseInt(rule.element.css("top"), 10)
                rule.element.css "top", top-1
            return
          when keys.down
            for k, rule of _selected
              if rule.name is "Vrule"
                top = parseInt(rule.element.css("top"), 10)
                rule.element.css "top", top+1
            return
          when keys.left
            for k, rule of _selected
              if rule.name is "Hrule"
                top = parseInt(rule.element.css("left"), 10)
                rule.element.css "left", top-1
            return
          when keys.right
            for k, rule of _selected
              if rule.name is "Hrule"
                top = parseInt(rule.element.css("left"), 10)
                rule.element.css "left", top+1
            return
          
        
      # console.log e.keyCode, allTheRightKeys

    elements.body
    .append "<style>
              .#{cssClass.rule} {
                position    : absolute;
                background  : #{Gridsee.colors.rule};
                z-index     : #{zIndex.base};
              }

              .#{cssClass.rule}:hover {
                cursor      : pointer;
              }

              .#{cssClass.rule}.#{cssClass.active} {
                background  : #000 !important;
                z-index     : #{zIndex.activeGuide};
              }

              .#{cssClass.ruler} {
                z-index     : #{zIndex.ruler};
                position    : absolute;
              }
            </style>".replace(/\s/g, "")

    # for num in [10..1]
    #   $v = new Vrule()
    #   $h = new Hrule()

    #   $v.element.css "top", 7*num + 100
    #   $h.element.css "left", 10*num + 100

    # console.log elements.rules()

    return
  return