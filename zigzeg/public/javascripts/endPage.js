$(document).ready(function(e) {
  preview_only = null;
  if(!$('#sidebar').hasClass('pgSide')){
		if($('#main').height() < $('#sidebar').height()){
			var padBot = ($('#sidebar').height()-$('#main').height())-100;
			$('#footerCon').css({'padding-top':padBot+'px'})
		}
	}
	$('.editShout').live('click',function(e){
		e.preventDefault();
		var id = $(this).attr('data-id');
		$(".imageLoader.load"+id).show();
		alert('retrieve shout data on this id:'+id+" using ajax then show it on form");
		$('#shoutTxt').val($('.shoutContent'+id).text().trim())
		$('.shoutAction').text("Edit of Shout "+$(".shoutTitle"+id).text());
		$('input.shout').val('Repost')
		textCounter($('#shoutTxt'),$('#countChar'),250);//for counter changes
		$(".imageLoader.load"+id).fadeOut();
	});
  $('.delShout').live('click',function(e){
		e.preventDefault();
		var id = $(this).attr('data-id');
		$(".imageLoader.load"+id).show();
		alert('Delete shout with this id : '+id);
		$(".imageLoader.load"+id).hide();
		$('.shoutList'+id+", .hr"+id).remove();
		
	});
	if($("#reportDialog input[type='radio']:checked").val() == 'others'){
    $('#reportText').show();
  }else{
    $('#reportText').hide();
  }
	$("#search").autocomplete("/search_autocomplete", {
		width: '100%',
		selectFirst: false,
		resultsClass:'s_result grid_12'
	});	
  $("#main").preloader();
	$('.aboutContent').unbind('click');
	$('.aboutContent').click(function(e){
			e.preventDefault();
			var href =  $(this).attr('href');
			if($(this).hasClass('showAll')){
					$('p'+href).removeClass('limit');
					$(this).addClass('hideAll').removeClass('showAll').text('HIDE');
			}else{
					$(href).addClass('limit');
					$(this).removeClass('hideAll').addClass('showAll').text('SHOW ALL');
			}
	});
	$('#ownZig').click(function(e){$("#msgZigAdd").fadeIn().delay(1500).fadeOut();});
  $('#zigMe').click(function(e){
		var listing_id = $("#zigMe").attr('data-id');
			if(isLogin()){
       $.ajax({
         type: "POST",
         url: "/zigthis",
         data: "listing_id=" + listing_id,
				 success: function(data){
					 	$("#msgZigAdd").fadeIn().delay(1500).fadeOut();
						$("#zigMe").addClass("zigged");
				 }
       });
     }else{$('#zigMessagePop').click();}
  });
$('.listingShow').live('click',function(e){
	e.preventDefault();
	var idElement = $(this).attr('data-id');
	var href = $(this).attr('href');
	if($(this).hasClass('showAll')){
          $(idElement).show();
		$(this).removeClass('showAll').addClass('hideAll').text('HIDE');
	}else{
		$(this).removeClass('hideAll').addClass('showAll').text('SHOW ALL');
          $(idElement).hide();
	}
});
	if( $('#shoutContent').height() > $('#divShoutCon').height() ){
		$('a#shoutLink').show();
	}
	$('a#shoutLink').click(function(e) {
		if($(this).hasClass('showAll')){
			$(this).text('HIDE').removeClass('showAll').addClass('hideAll');
			 $('.extraShout').slideDown();
		}else{
			$(this).text('SHOW ALL').addClass('showAll').removeClass('hideAll');
			 $('.extraShout').slideUp();
		}
  });
	
	if( $('#aboutPlace').height() > $('#divAbountCon').height() ){
		$('a#aboutLink').show();
	}
	$('a#aboutLink').click(function(e) {
		if($(this).hasClass('showAll')){
			$(this).text('HIDE').removeClass('showAll').addClass('hideAll');
			 $('#divAbountCon').css('overflow','visible').css('max-height','none');
		}else{
			$(this).text('SHOW ALL').addClass('showAll').removeClass('hideAll');
			 $('#divAbountCon').css('overflow','hidden').css('max-height','126px');
		}
  });
	if(window.location.hash === "#offersTitle" || window.location.hash === "#eventsTitle") {
   	$(window.location.hash+'Link').click();
		$('html, body').animate({
         scrollTop: $(window.location.hash).offset().top
  	}, 500);
	}

$('.scrollListings').click(function(e){
	e.preventDefault();
	var href = $(this).attr('href');
	$(href+'Link').click();
	$('html, body').animate({
         scrollTop: $(href).offset().top
  }, 500);
});	
$('#proceedLogin').click(function(e){
	$('html, body').animate({
         scrollTop: $("#logInLink").offset().top
  }, 500);
	$('#logInLink').click();
})

$('#proceedRegister').click(function(e){
	$('html, body').animate({
         scrollTop: $("#signUpLink").offset().top
  }, 500);
	$('#signUpLink').click();
})

$("#reportDialog input[type='radio']").click(function(e) {
		if($(this).val() == 'others')
			$('#reportText').show();
		else
			$('#reportText').hide();
});
$("#reportFrm").validate({
  messages:{ 
    report:{
      required:'Unable to send report. Please select a report type below in order to report this page.'
      },
    content:{
      required:'Unable to send report. Please specify the problem noted.'
      }
  },
  rules:{
    content:{
      required: function(element) {
        return $("#reportDialog input[type='radio']:checked").val() == 'others';
      }
    }
  },
  submitHandler: function(form) {
    $.ajax({
      type: "POST",
      url: "/listings/reportthis",
      data: $(form).serializeArray(),
    });

    $('#reportCont').click();
  }
});

$('.jtextfillDeals').textfill({ maxFontPixels: 35 });
  $('.hover-star').rating({
    focus: function(value, link){
    // 'this' is the hidden form element holding the current value
    // 'value' is the value selected
    // 'element' points to the link element that received the click.
    var tip = $('#hover-test');
  },

  blur: function(value, link){
    var tip = $('#hover-test');
    //$('#hover-test').html(tip[0].data || '');
  },

  callback: function(value, link){
    if(isLogin()){
				$('#star_value').text(value+'/10');
				listing_id = $("#listing_id").val();
				$.ajax({
					url: "/ratethis",
					type: "POST",
					data: "listing_id=" + listing_id + "&value=" + value,
                                        success: function(data) {
if (data.status == 'success') {
  $("#listing_rating_value").text(data.rating);
	if(data.total_rates > 1){
		designation = " persons"
	}else{
		designation = " person"
	}$("#listing_total_rates").text("rated by " + data.total_rates+designation);
}
                                        }
				});
		createCookie(global_user_id +'_rated_listing_' + listing_id, listing_id,1)
					$(".hover-star").rating('disable');
		}else{
                  $(".hover-star").rating('select', -1);
                  $('#ratingMessagePop').click();
				}			
    }
	});

	$("a[rel=product_group]").live('mouseover',function() {
			$('a[rel=product_group]').fancybox({
				'transitionIn'	: 'none',
				'transitionOut'	: 'none',
				'titlePosition'	: 'inside',
				onStart : function( links, index ){  
					this.title = $(links[index]).attr('name');
    		},
				'padding'		: 20
			});
	});
	

  $("#contactM").unbind('click');

  $('#contactM').click(function(e){
    e.preventDefault();
    if(isLogin()){
      if (preview_only == undefined ){
        $("#contact_form_link").click();
      }else{
        // do nothing
      }
    
    }else{
      $("#contactPop").click();
    }
  });	
		
	$("#contact_form_link").fancybox({
				'transitionIn'		: 'none',
				'transitionOut'		: 'none',
				'titlePosition'		: 'none',
                                'onClosed' : function(){
                                  $("#contactform").show();
                                  $("#sendmessage").hide();
                                  $("#subject").val('');
                                  $("#ask_message").val('');
                                }
  });

	$("#contactform").validate({
			  submitHandler: function(form) {
          $.ajax({
            url: "/listings/contactus",
			      type: "POST",
			      data: $(form).serializeArray(),
			      success: function(data) {
              $("#sendmessage").show();
							$("#contactform").hide();
			      }
			    });
			  }
			});
			
  $('select#locationChanger').change(function() {
    $('.locationImg').attr('src','/images/'+$(this).val()).fadeIn(1000000);
  }).trigger('change');
	$('#shoutTxt').live('keyup',function(){
			textCounter($(this),$('#countChar'),250);
	});
		function textCounter(field,cntfield,maxlimit) {
			if (field.val().length > maxlimit){ // if too long...trim it!
					text = field.val().substring(0, maxlimit);
					field.val(text);
			}
			else
					cntfield.text(maxlimit - field.val().length);
	}
});
 
$(window).load(function () {
	if(!$('#sidebar').hasClass('pgSide')){
		if($('#main').height() < $('#sidebar').height()){
			var padBot = ($('#sidebar').height()-$('#main').height())-100;
			$('#footerCon').css({'padding-top':padBot+'px'})
		}
	}
	$('#shoutTxt').text('');
});
