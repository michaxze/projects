$(document).ready(function () {    		
	/****  tabs click text  ***/
	$('#liPlaces').click(function(){
  		$( "#tabs" ).tabs( "select",'ui-tabs-3' );
		});
	$('#liDeals').click(function(){
  		$( "#tabs" ).tabs( "select",'ui-tabs-2' );
		});
	$('#liEvents').click(function(){
  		$( "#tabs" ).tabs( "select",'ui-tabs-1' );
		});
	$('#liLatest').click(function(){
  		$( "#tabs" ).tabs( "select",'tabAll' );
		});
	 
});
$(function() {
		$( "#tabs" ).tabs({
			select: function( event, ui ) {
				$( "#depSlide" ).slider( "value", ui.index );
			}
		});
			$( "#depSlide" ).slider({
			min: 0,
			animate: 'fast',
			max: $( "#tabs" ).tabs( "length" )-1,
			slide: function( event, ui ) {
				$( "#tabs" ).tabs( "select", ui.value );
				
			}
		});
});

	
	var filter ='';
	$(window).scroll(function(){
      if  ($(window).scrollTop() == $(document).height() - $(window).height()){
      if($('#ui-tabs-3').hasClass('ui-state-active') || !$('#ui-tabs-3').hasClass('ui-tabs-hide') ){
				filter = 'places';
			}else if($('#ui-tabs-2').hasClass('ui-state-active') || !$('#ui-tabs-2').hasClass('ui-tabs-hide')  ){
				filter = 'deals';
			}else if($('#ui-tabs-1').hasClass('ui-state-active')  || !$('#ui-tabs-1').hasClass('ui-tabs-hide') ){
				filter = 'events';
			}else{
				filter = 'all';
			}
			var pgNum = document.getElementById('pageNumber').value;
				if(pgNum==1){
					loadContent(filter);
				}
			}
	});
	
	
	$(function() {
		$( "#tabs" ).tabs({
			ajaxOptions: {
				error: function( xhr, status, index, anchor ) {
					$( anchor.hash ).html(
						"Couldn't load this tab. We'll try to fix this as soon as possible. ");
				},
				beforeSend: function(){
					$(".imageLoader").removeClass("dispNone");  
				 },
				 complete: function(){
					 $(".imageLoader").addClass("dispNone");  
				 }
			}
		});
	});
	
	function loadContent(filter){
		var pgNum = document.getElementById('pageNumber').value;
			$.ajax({
				type:'POST',
  				url: 'pageload.php',
                data:'page='+pgNum+'&type='+filter,
  				success: function(data) {
					document.getElementById('pageNumber').value = (parseInt(pgNum)+1);
					$("#"+filter+"View").append(data).fadeIn();
						$(".imageLoader").addClass("dispNone");  
					},
					beforeSend: function(){
					$(".imageLoader").removeClass("dispNone");  
				 },
				 complete: function(){
					 $(".imageLoader").addClass("dispNone");  
				 }
			});
	}
	
$(document).ready(function() {
	$('#showMore').click(function(){
			if($('#ui-tabs-3').hasClass('ui-state-active') || !$('#ui-tabs-3').hasClass('ui-tabs-hide') ){
				filter = 'places';
			}else if($('#ui-tabs-2').hasClass('ui-state-active') || !$('#ui-tabs-2').hasClass('ui-tabs-hide')  ){
				filter = 'deals';
			}else if($('#ui-tabs-1').hasClass('ui-state-active')  || !$('#ui-tabs-1').hasClass('ui-tabs-hide') ){
				filter = 'events';
			}else{
				filter = 'all';
			}
			loadContent(filter);
		});	
	$("a.switch_thumb").toggle(function(){
	  $(this).addClass("swap");
	  $("ul.listview").fadeOut("fast", function() {
	  	$(this).fadeIn("fast").removeClass("imglist");
			$('#page_wrap').removeClass('container_12').addClass('fcontainer_12');
		 });
	  }, function () {
    $(this).removeClass("swap");  
	  $("ul.listview").fadeOut("fast", function() {
			$(this).fadeIn("fast").addClass("imglist"); 
			$('#page_wrap').removeClass('fcontainer_12').addClass('container_12');
		});
	}); 

});
	$(function(){
			$('#slider2').anythingSlider({
				resizeContents      : false, // If true, solitary images/objects in the panel will expand to fit the viewport
				navigationSize      : 2,     // Set this to the maximum number of visible navigation tabs; false to disable
				expand       : true,
				onSlideComplete: function(slider) {
					// keep the current navigation tab in view
					slider.navWindow( slider.currentPage );
				}
			});
		});
