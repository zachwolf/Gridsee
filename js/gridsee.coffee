console = window.console

do (window = window, doc = document, g = jQuery) -> # temp alias to jQuery, I want to make my own engine in the future

  ns = "gridsee" # namespace
  
  events = 
    click : "click.#{ns}"

  class Gridsee
    constructor : () ->
      @model()
      @view()
      @controller()

    model       : ->

    view        : ->
      @$ =
        body      : g doc.body
        pageEls   : g("<div />", 
                      {
                        id  : "#{ns}-wrapper"
                      }
                    )
        fakebody  : g "<body />"
        canvas    : g "<canvas />"
        settings  : g "<div />"
        menu      : g "<button />"


    controller  : ->
      class Popup
        constructor : (x) ->
          @isOpen = false
        open      : ->
          @isOpen = true
          console.log "open"
        close     : ->
          @isOpen = false
          console.log "close"
        toggle    : ->
          @[if @isOpen then "close" else "open"]()
          
      popup = new Popup()

      do =>
        @$.menu
          .on events.click, (e) =>
            popup.toggle()
          .appendTo @$.body
        console.log @$.pageEls

      return
        

  window.Gridsee = new Gridsee()