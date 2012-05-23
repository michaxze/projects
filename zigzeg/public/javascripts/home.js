$(window).load(function () {
	if($(window.location.hash).length) {
		$(window.location.hash).click();
	}
});
$(document).ready(function () { 
  filter ='';
			$('#slides').slides({
				preload: true,
				preloadImage: '/images/loading.gif',
				generateNextPrev: true,
				play: 5000,
				pause: 2500,
				hoverPause: true,
				generatePagination: false
			});
  $('#timeOpen').click(function(e) {
    e.preventDefault();
    params = $("#page_params").val();

    if($('#timeOpen').hasClass('selected')){
      params = "";
    }else{
      params += "&time=1";
    }
    location.href="/?" + params
  });

$('#pageNumber').val('1');
 list_type = 'thumb';  
		if ($('#noresults').length == 0) {
		$('#liPlaces').click(function(e) { $("#depSlide").slider("option", "value", 32); });
		$('#liDeals').click(function(e) { $("#depSlide").slider("option", "value", 66); });
		$('#liEvents').click(function(e) { $("#depSlide").slider("option", "value", 100); });
		$('#liLatest').click(function(e) { $("#depSlide").slider("option", "value", 0); });
		}
});
$(function() {
	$("#content").preloader();
	$("#search").autocomplete("/search_autocomplete", {
    width: '100%',
    selectFirst: false,
		resultsClass:'s_result grid_12'
  });
  $( "#tabs" ).tabs();
	$( "#depSlide" ).slider({
			max: 100,	value:0,
			stop: function(event, ui) { 
				var val = ui.value;
				var setVal = 0,uival=0;
						if(val >= 84){setVal = 100; uival=3; }
						else if(val >= 50 && val <= 83){	setVal = 66;uival=2;}
						else if(val >= 17 && val <= 49){	setVal = 32;uival=1;}
				$( "#depSlide" ).slider( "option", "value", setVal );
				$( "#tabs" ).tabs( "select", uival );
			},change: function(event,ui){
				var val = ui.value;
				var setVal = 0,uival=0;
						if(val >= 84){setVal = 100; uival=3; }
						else if(val >= 50 && val <= 83){	setVal = 66;uival=2;}
						else if(val >= 17 && val <= 49){	setVal = 32;uival=1;}
				$( "#tabs" ).tabs( "select", uival );	
		  }
	});
});
        var loaded_page2 = false;
	$(window).scroll(function(){
      if  ($(window).scrollTop() == $(document).height() - $(window).height()){
      if($('#ui-tabs-3').hasClass('ui-state-active') || !$('#ui-tabs-3').hasClass('ui-tabs-hide') ){
				filter = 'event';
			}else if($('#ui-tabs-2').hasClass('ui-state-active') || !$('#ui-tabs-2').hasClass('ui-tabs-hide')  ){
				filter = 'deal';
			}else if($('#ui-tabs-1').hasClass('ui-state-active')  || !$('#ui-tabs-1').hasClass('ui-tabs-hide') ){
				filter = 'place';
			}else{
				filter = 'all';
			}
			var pgNum = document.getElementById('pageNumber').value;
			if(pgNum==1 && loaded_page2 == false){
                          loaded_page2 = true;
                          loadContent(filter);
                        }
		}
	});
	$(function() {
		$( "#tabs" ).tabs({
           select: function(event, ui) {
            $('#pageNumber').val('1');
               if (ui.index == 0){
                  npage = $("#tabAll .selecterContent ul li").length / constant_per_page
                  if (($("#tabAll .selecterContent ul li").length % constant_per_page) > 0)
                  npage = npage + 1;
                 $('#pageNumber').val(npage);
                            
  			    $("#showMore").show();
                            tab_id = "tabAll"
                          }else if(ui.index == 1){
                            tab_id = "ui-tabs-1"
                          }else if(ui.index == 2){
                            tab_id = "ui-tabs-2"
                          }else if(ui.index == 3){
                            tab_id = "ui-tabs-3"
                          }
                        },
			ajaxOptions: {
				error: function( xhr, status, index, anchor ) {
					$( anchor.hash ).html(
						"Couldn't load this tab. We'll try to fix this as soon as possible. ");
				},
				beforeSend: function(){
				  $("#showMore").show();
          $(".imageLoader").removeClass("dispNone");  
				 },
				 complete: function(){
           id_class = "#" + tab_id + " .selecterContent ul li";
           if ($(id_class).length < constant_per_page) {
             $("#showMore").hide();
  	   }else{
             $("#showMore").show();
           }

					if (list_type == "index") {					  
  					$("ul.listview").removeClass('imglist');
					}else{
  					$("ul.listview").addClass('imglist');					  
					}
						 $(".imageLoader").addClass("dispNone");
				 }
			}
		});
	});
	
	function loadContent(filter){
          $("#allView li").each(function() {
            $(this).removeClass("new");
          });

	  params = $("#page_params").val();
		var pgNum = document.getElementById('pageNumber').value;
			$.ajax({
				type:'GET',
  				url: '/showmore?',
          data:'page='+pgNum+'&type='+filter + params,
  				success: function(data){
				 if(data == "") {
  				    $("#showMore").hide();
         }
	document.getElementById('pageNumber').value = (parseInt(pgNum)+1);
            if (filter == "place") {
              $("#ui-tabs-1 .selecterContent #allView").append(data).fadeIn();
            }else if (filter == "event"){
              $("#ui-tabs-3 .selecterContent #allView").append(data).fadeIn();
            }else if(filter == "deal") {
              $("#ui-tabs-2 .selecterContent #allView").append(data).fadeIn();
            }else{
              $("#"+filter+"View").append(data).fadeIn();
            }
            $(".imageLoader").addClass("dispNone");

           if ($("#allView li.new").length < constant_per_page) {
             $("#showMore").hide();
           }else{
             $("#showMore").show();
  	   }


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
				filter = 'event';
			}else if($('#ui-tabs-2').hasClass('ui-state-active') || !$('#ui-tabs-2').hasClass('ui-tabs-hide')  ){
				filter = 'deal';
			}else if($('#ui-tabs-1').hasClass('ui-state-active')  || !$('#ui-tabs-1').hasClass('ui-tabs-hide') ){
				filter = 'place';
			}else{
				filter = 'all';
			}
			loadContent(filter);
		});	
var padLeft = Math.floor(($('#content').width()-(170*(Math.floor($('.selecterContent').width()/175))))/2);
								$('.mainTabContainer').css({'padding-left':padLeft});
	$("a.switch_thumb").click(function(ev){
		ev.preventDefault();
		if(list_type == "thumb") {list_type = "index";}else{list_type = "thumb";}
	});
	if ($('#noresults').length == 0) {
	$("a.switch_thumb").toggle(function(ev){
		ev.preventDefault();
		$(this).addClass("swap");
		$("ul.listview").fadeOut("fast", function() {
	  	$(this).fadeIn("fast").removeClass("imglist");
			$('#page_wrap').removeClass('container_12').addClass('fcontainer_12');
			$('.mainTabContainer').css({'padding':'0'});
		 });
	  }, function () {
    $(this).removeClass("swap");  
	  $("ul.listview").fadeOut("fast", function() {
			$(this).fadeIn("fast").addClass("imglist"); 
			$('#page_wrap').removeClass('fcontainer_12').addClass('container_12');
			$('.mainTabContainer').css({'padding-left':padLeft});
		});
	}); 
	}
var padLeft = Math.floor(($('#content').width()-(170*(Math.floor($('.selecterContent').width()/175))))/2);
			$('.mainTabContainer').css({'padding-left':padLeft});
		$('#cover').remove();
		});
function hoverJSin(id){
	$('.hover'+id+'').addClass('hover');
}
function hoverJSout(){
	$('.listJsH').removeClass('hover');
}
