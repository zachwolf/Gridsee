console = window.console

do (window = window, doc = document, g = jQuery) -> # temp alias to jQuery, I want to make my own engine in the future

  class Gridsee
    constructor : () ->
      @model()
      @view()
      @controller()

    model       : ->

    view        : ->
      @$ =
        body      : g doc.body
        pageEls   : g("<div />", { id : "y" })
        fakebody  : g "<body />"
        canvas    : g "<canvas />"
        settings  : g "<div />"
        menu      : g "<div />"


    controller  : ->
      do =>
        console.log @$.pageEls
        

  window.Gridsee = new Gridsee()