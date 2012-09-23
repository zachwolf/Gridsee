console = window.console

do (window = window) ->

  g = ( el, parameters ) ->
    $ = el

    if typeof $ is "string"
      if !!$.match(/(<\/?[^>]+>)/gi)
        $ = document.createElement el.replace(/[^a-zA-Z]/gi, "")
      else
        $ = document.getElementsByTagName el

    el[attr] = val for attr, val of parameters if parameters?

    $ extends g::
    $

  g:: = 
    addClass : (c) ->
      console.log @, c
      @

  g.fn = g::

  window.g = g