$(document).ready(function() {
			<!--for tabs-->
			$("#tabMain").tabs();
  		$("#depTabMain").tabs();
	
			 $("a[rel=product_group]").fancybox({
				'transitionIn'	: 'elastic',
				'transitionOut'	: 'elastic',
				'titlePosition'	: 'inside',
				onStart : function( links, index ){  
					this.title = $(links[index]).attr('name');
    		},
				'padding'				: 20
			});
			$("a[rel=service_group]").fancybox({
				'transitionIn'	: 'elastic',
				'transitionOut'	: 'elastic',
				'titlePosition'	: 'inside',
				'padding'				: 20
				
			});
			$("a[rel=brand_group]").fancybox({
				'transitionIn'	: 'elastic',
				'transitionOut'	: 'elastic',
				'titlePosition'	: 'inside',
				'padding'				: 20
			});
			$("a[rel=gallery_group]").fancybox({
				'transitionIn'	: 'elastic',
				'transitionOut'	: 'elastic',
				'titlePosition'	: 'inside',
				'padding'				: 20
			});
			$("#dealsBox").fancybox({
				'titlePosition'		: 'outside',
				'transitionIn'		: 'none',
				'transitionOut'		: 'none'
			});
			$("#branchesBox").fancybox({
				'titlePosition'		: 'outside',
				'transitionIn'		: 'none',
				'transitionOut'		: 'none'
			});
			$("#eventsBox").fancybox({
				'titlePosition'		: 'outside',
				'transitionIn'		: 'none',
				'transitionOut'		: 'none'
			});
			$("#announcementBox").fancybox({
				'titlePosition'		: 'outside',
				'transitionIn'		: 'none',
				'transitionOut'		: 'none'
			});
		$('a.announcement_modal').click(function(ev){
			ev.preventDefault();
			var href = this.href;
			var title = $(this).attr('title');
			$.ajax({
  			  type: "GET",
  			  url: href,
  			  async: false,
  			  success: function(data) {
 			    //AFTER APPEND THE RETRIEVED DATA TO THE MODAL VIEW
			    $('.announceTitle').empty().text(title);
			    $('.announceContent').empty().text(data);
			    $('#announcementBox').click();
  			  }
			});
			
		});
						
	//FOR SETTING THE MAX SIZE OF THE FONT AUTO RESIZING FUNCTION	
	$('.jtextfill').textfill({ maxFontPixels: 35 });
	
	//FUNCTIONALITY FOR SHOWING AND HIDING CONTENTS
	
	/************* ABOUT CONTENT AREA****************/
	$('#aboutShow').click(function(){
				$.ajax({
					url: "aboutappend.html",
					beforeSend: function( xhr ) {
						$('.aboutLoader').show();
					},
					success:function(data) {
						$('#aboutAppend').append(data);
						$('#aboutAppend').fadeIn(data);
						$('#aboutShow').hide();
						$('#aboutHide').show();
						$('.aboutLoader').hide();
					}
				});
		});
		$('#aboutHide').click(function(){
						$('#aboutAppend').fadeOut();
						$('#aboutAppend').html('');
						$('#aboutShow').show();
						$('#aboutHide').hide();
		});
		
	/************* END ABOUT CONTENT AREA****************/
		
 /************* OTHER BRANCHES CONTENT AREA****************/
	$('#otherShow').click(function(){
				$.ajax({
					url: "otherBranch.html",
					beforeSend: function( xhr ) {
						$('.otherLoader').show();
					},
					success:function(data) {
						$('#otherAppend').append(data);
						$('#otherAppend').fadeIn();
						$('#otherShow').hide();
						$('#otherHide').show();
						$('.otherLoader').hide();
					}
				});
		});
		$('#otherHide').click(function(){
						$('#otherAppend').fadeOut();
						$('#otherAppend').html('');
						$('#otherShow').show();
						$('#otherHide').hide();
		});
		
	/************* END OTHER BRANCHES CONTENT AREA****************/
		
		
	/************* WHATS NEW CONTENT AREA****************/
	$('#whatsNewShow').click(function(){
				$.ajax({
					url: "whatsnewappend.html",
					beforeSend: function( xhr ) {
						$('.whatsNewLoader').show();
					},
					success:function(data) {
						$('#whatsNewAppendarea').append(data);
						$('#whatsNewShow').hide();
						$('#whatsNewHide').show();
						$('#whatsNewAppend').fadeIn();
						$('.whatsNewLoader').hide();
					}
				});
		});
		$('#whatsNewHide,#whatsNewHideClick').click(function(){
				$('#whatsNewShow').show();
				$('#whatsNewHide').hide();
				$('#whatsNewAppend').fadeOut();
				$('#whatsNewAppendarea').html('');
				
		});
	/************* END WHATS NEW CONTENT AREA****************/

/**** CHECKING IF TAB SELECTED IS SHOWING ALL OR NOT ****/
$( "#tabMain" ).bind( "tabsshow", function(event, ui) {
		var tabName = getCurrentTab();
		if(jQuery.trim($('#'+tabName+'Appendarea').html()) != ''){
			$('#tabShow').hide();
			$('#tabHide').show();
		}else{
			$('#tabShow').show();
			$('#tabHide').hide();
		}
});


/*********** START TAB CONTENT AREA DISPLAY ***************/
	$('#tabShow').click(function(){	
						$('#prodContain').fadeToggle();
						$(this).toggleClass('hideAll').toggleClass('showAll');
						if($(this).hasClass('showAll'))
							$(this).text('SHOW ALL')
						else
							$(this).text('HIDE');
	});
	$('.tabClickHide').click(function(e) {
    	$('#prodContain').fadeOut();
			$('#tabShow').text('SHOW ALL').removeClass('hideAll').addClass('showAll');
  });
});


function showContactusWindow() {
  $.fancybox.showActivity();
  $.ajax({
    url   : "/listings/contactus",
    type    : "GET",
    data  : $(this).serializeArray(),
    success: function(data) {
      $.fancybox.hideActivity();
      $.fancybox(data,
	{
	'titlePosition'   : 'outside',
	'transition'      : 'none',
	'transitionOut'   : 'none'
	});
    }
  });
}
