jQuery(document).ready(function($) {

  $("a[rel=fancybox]").fancybox({
  		'transitionIn'		: 'none',
  		'transitionOut'		: 'none',
  		'titlePosition' 	: 'over',
  		'titleFormat'       : function(title, currentArray, currentIndex, currentOpts) {
  		    return '<span id="fancybox-title-over">' + title + '</span>';
  		}
  	});

})