(function() {

	$.fn.gridsee	=	function($params) {

		var $scripts	=	$('script'),
			$objs 		=	{},
			$target		=	$(this),

		$.each($scripts, function( k, v ){
			var $this	=	$(v),
				$src 	=	$this.attr("src");
			if($src != undefined) {
				if($src.indexOf("grids.ee") != -1) {
					var $query 	=	$src.split("?")[1];

					if($query == undefined) return;

					$query 		=	$src.split("?")[1].split("&");

					$.each($query, function( k, v ){
						$temp	=	v.split("=");
						$objs[$temp[0]]	=	$temp[1];
					});
				}
			}
		});

		grid =	{
			lineHeight 	: 	$params.lineheight 	||	$objs.lineheight	||	20,
			keyCode 	: 	$params.keyCodes	||	$objs.keyCodes 		||	['91','186'],
			keysDown	: 	new Array(),
			target 		: 	$target || $(window),
			isShown		: 	false,

			init 		:	function($newParams){
				var $this =	this;

				if($.isArray(this.keyCode) == false) {
					$strings 		=	this.keyCode.split(",");
					$this.keyCode 	=	[];
					$.each($strings, function( x, y ){
						$this.keyCode.push(parseInt(y));
					});
				}

				this.keyCode 	=	this.keyCode.sort(function(a,b){return a-b});
				this.keyListener($target, this.keyCode);

				this.gridEl = 	$('<div></div>', {
									class: 	"quick-grid",
									css: 	{
												position: 	"absolute",
												top: 		0,	left: 		0,
												right: 		0,	height: 	$(document).height(),
												background: "url('http://grids.ee/make/lines/" + $this.lineHeight + ".png')",
												zIndex: 	1337
											}
								})
								.prependTo("body")
								.hide();

				if($('html').hasClass("touch") == true) {
					$(window).on("touchstart", function(){return true;});

					var $logo 		=	"http://grids.ee/img/gridsee-logo.png";

					if( window.devicePixelRatio >= 2 ){
						$logo 		= 	"http://grids.ee/img/gridsee-logo@2x.png";
					}

					$('<a></a>', {
						class 	: "gridsee-toggle",
						css 	: 	{
										position: 	"absolute",
										top: 	0, 	right: 	20,
										height: 0, width: 	50,
										background: "url(" + $logo + ") center bottom",
										"background-size": "100%",
										zIndex: 	8675309
									}
					})
					.on("touchstart", function(e){
						$this.toggleGrid();
					})
					.animate({
						height: 53
					}, 500)
					.prependTo("body")
				}
			},
			keyListener : 	function($target, $keys){
				var $this	=	this;

				$target.on("keydown", function(e){
					if($.inArray(e.keyCode, $this.keysDown) == -1) {
						$this.keysDown.push(e.keyCode);
					}

					$this.keysDown = $this.keysDown.sort(function(a,b){return a-b});
					if($this.compare($this.keyCode, $this.keysDown) == true) {
						$this.toggleGrid();
					}
				})
				.on("keyup", function(e){
					$this.keysDown = [];
				});
			},
			compare 	: 	function($a, $b) {
				for (var i = $a.length - 1; i >= 0; i--) {
					if($a[i] != $b[i]) return;
					return true;
				};
			},
			toggleGrid 	: 	function(){
				var $this 	=	this;
				if($this.isShown == true) {
					$this.gridEl.hide();
					$this.isShown = false;
				} else {
					$this.gridEl.show();
					$this.isShown = true;
				}
			}
		}

		grid.init();

		return this;
	}
})(jQuery);