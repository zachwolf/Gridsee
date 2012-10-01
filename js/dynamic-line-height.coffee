# <input type="range" id="changer" min="10" max="60" value="18" />

$ do ->
  newCanvas = $ "<canvas />"
  canvas = newCanvas[0];
  context = canvas.getContext('2d');
  dash = 10
  dashColor = "#fe11a5"
    
  sketch = (lh) ->
    canvas.height = lh
    canvas.width = dash
    context.fillStyle = dashColor
    context.fillRect(0,lh-1,dash/2,1)
   
    $(document.body)
      .css({"background": "url(#{canvas.toDataURL()})" })
    
  sketch $("#changer").val()
    
  $("#changer")
    .on "change", (e) ->
      sketch $(this).val()
