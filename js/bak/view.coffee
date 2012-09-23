class Gridsee.View
  constructor: () ->
    console.log "view", @

    makeA = (type, parameters) ->
      el = document.createElement type
      x = parameters
      el

    @$ = 
      canvas  : makeA( "canvas", { x : "y" })

