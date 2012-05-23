function doSomething() {
		$("#boxes .window").each(function(){
				if($(this).css('display')=="block"){
						var idS = "#"+$(this).attr('id');
						$('a[name=modal]').each(function(){
							var id = $(this).attr('href');
							if(id==idS){
								if(idS == "#loginDialog" || idS=="#loginMessage" || idS=="#zigMessagePop"){
									var offset = $(this).offset();
								}else if(idS=="#reportDialog" ||idS =="#reportSuccess"){
									var offset = $(this).offset();
								}else{
									var offset = $("#signUpLink").offset();
								}
								var tLeft = offset.left;
								var tTop = offset.top;
								var modW = $(idS).width()-50;
								var winW = $(window).width();
								$(idS).css('left',tLeft-modW);
								if(id == "#loginDialog" || id=="#loginMessage" || id=="#zigMessagePop"){
								$(idS).css({'top':tTop+40});
								}else if(id == "#accountSettings" || id  == '#updatesListing'){
									$(id).css({'top':tTop+36});
									$(id).css('left',tLeft-(modW/1.5));
								}else{
									$(idS).css({'top':tTop+35});
								}
								
								//alert(modW);
							}
						});
				}
		});	
};

function isLogin(){
  var ret = 0;

  $.ajax({
    url: "/sessions/check_session",
    type: "GET",
    async: false,
    success: function(data) {
      if (data == "true") {
        ret = 1;
      }else{
        ret = 0;
      }
    }
  });

  return ret;
}

var resizeTimer;
$(window).resize(function() {
    clearTimeout(resizeTimer);
    resizeTimer = setTimeout(doSomething, 0);
});
					$(document).ready(function(){  
						$('a[name=modal]').click(function(e) {
							$('.window').hide();
							//Cancel the link behavior
							e.preventDefault();
							if($(this).hasClass('logged')){
								$(this).addClass('selected');
							}
							//Get the A tag
							var id = $(this).attr('href');
							var modW = $(id).width()-50;
							if(id == "#loginDialog" || id=="#loginMessage" || id=="#zigMessagePop"){
								var offset = $(this).offset();
							}else if(id=="#reportDialog"||id=="#reportSuccess"){
									var offset = $('#reportPage').offset();
							}else{
								var offset = $("#signUpLink").offset();
							}
							
							var tLeft = offset.left;
							var tTop = offset.top;
							
							//Get the screen height and width
							var maskHeight = $(document).height();
							var maskWidth = $(window).width();
							$('#mask').css({'width':maskWidth,'height':maskHeight});
							$('#mask').show();	
							//Get the window height and width
							var winH = $(window).height();
							var winW = $(window).width();
							//Set the popup window to center
							if(id=="#forgotDialog"){
								var offset = $("#logInLink").offset();
								var tLeft = offset.left;
								var tTop = offset.top;
							}
							$(id).css('left',tLeft-modW);
							if(id == "#loginDialog" || id=="#loginMessage" || id=="#zigMessagePop"){
								$(id).css({'top':tTop+40});
							}else if(id == "#accountSettings" || id == '#updatesListing'){
								$(id).css({'top':tTop+36});
								$(id).css('left',tLeft-(modW/1.5));
							}else{
								$(id).css({'top':tTop+35});
							}
								

							//transition effect
							$(id).slideDown(200); 
						});
						//if close button is clicked
						$('.window .close').click(function (e) {
							//Cancel the link behavior
							e.preventDefault();
							$('#mask').hide();
							$('.window').hide();
							$('.logged').removeClass('selected');
						});		
						//if mask is clicked
						$('#mask').click(function () {
							$(this).hide();
							$('.window').hide();
							$('.logged').removeClass('selected');
						});	    
					 jQuery.validator.setDefaults({
							debug: true,
							success: "valid"
						});
						 $("#loginfrm").validate({
						   submitHandler: function(form) {
							 $.ajax({
							     type: "post",
							     url: "/signin",
							     data: $(form).serializeArray(),
							     context: document.body,
							     success: function(data){
							       if (data == "error") {
    							         $("#loginfrm .serverError").html("<label class='error'>Incorrect username and password.</label>");
													  $("#loginfrm input:text,#loginfrm input:password").addClass('error');
							       }else{
							         location.replace(data);
							       }
							     }
							 });
					           return false;
						 }
						});
						 $("#forgotFrm").validate({
							 submitHandler: function(form) {
						         $.ajax({
                                                           type: 'POST',
							   url: '/forget_password',
							   data: $(form).serializeArray(),
							   success: function(data) {
							     if (data == "true") {
							       $("#forgotFrm ul").remove();
							       $("#forgotFrm div").removeClass();
							       $("#forgotFrm input[name='cancel']").val('Close');
							     }else{
                                                               $("#forget_password_email").text("Email address not found.");
							     }
							   }
							 });
						 }
						});
						          
								$("#search").autocomplete("/search_autocomplete", {
									width: 260,
									selectFirst: false,
								});

								$("#search").result(function(event, data, formatted) {
                                                                  if (data) {
								    $("#search").val(data[0]);
						 		    //location.href=data[1];
								  }
								});
								$('#advanceSearchBtn').click(function(){
										if($(this).hasClass('gray')){
											$('#advanceSearchBtn').removeClass('gray');
											$('#aSearchContainer').animate({"height": "toggle", "opacity": "toggle"}).css({'display':'inline-block'});
										}else{									
											$('#advanceSearchBtn').addClass('gray');
											$('#aSearchArrow').hide();
											$('#aSearchContainer').slideUp();	
										}
									
								});
								$('#advanceViewMore').toggle(function(){
										$('#advanceViewMoreCat').fadeIn();
										$(this).addClass('open').text('Hide more categories');
									},function () {
										$('#advanceViewMoreCat').fadeOut();
										$(this).removeClass('open');
										$(this).text('View more categories');										
								});
								$('#closeAsearch').click(function(){
											$('#advanceSearchBtn').addClass('gray');
											$('#aSearchArrow').hide();
											$('#aSearchContainer').slideUp();	
								})
								$('.chkBx').click(function(){ 
									var idName = $(this).attr('id')+'Link';
									if($(this).attr('checked')=='checked')
											$('#'+idName).addClass('selected');
									else
											$('#'+idName).removeClass('selected');
								});
								checkSelected();

            });
						//	CHECKS ONLOAD ON CHECKED ITEMS
						function checkSelected() {
							 $('.chkBx').each(function(){
								 if( $(this).is(":checked") ){
											$('#'+$(this).attr('id')+'Link').addClass('selected');
								 }
							});
						}	
						// FOR FONT AUTO RESIZING FUNCIONALITY
(function($) {
	//$(".dpEndPage").preloader();
	$.fn.textfill = function(options) {
		var defaults = {
			maxFontPixels: 40,
			innerTag: 'span'
		};
		var Opts = jQuery.extend(defaults, options);
		return this.each(function() {
			var fontSize = Opts.maxFontPixels;
			var ourText = $(Opts.innerTag + ':visible:first', this);
			var maxHeight = $(this).height();
			var maxWidth = $(this).width();
			var textHeight;
			var textWidth;
			do {
				ourText.css('font-size', fontSize);
				textHeight = ourText.height();
				textWidth = ourText.width();
				fontSize = fontSize - 1;
			} while ((textHeight > maxHeight || textWidth > maxWidth) && fontSize > 3);
		});
	};
})(jQuery);

function createCookie(name,value,days) {
  if (days) {
    var date = new Date();
    date.setTime(date.getTime()+(days*24*60*60*1000));
    var expires = "; expires="+date.toGMTString();
  }
  else var expires = "";
  document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
  var nameEQ = name + "=";
  var ca = document.cookie.split(';');
  for(var i=0;i < ca.length;i++) {
    var c = ca[i];
    while (c.charAt(0)==' ') c = c.substring(1,c.length);
    if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
  }
  return null;
}

function eraseCookie(name) {
  createCookie(name,"",-1);
}


$(document).ready(function(e) {
  $("#zigzegcontactM").fancybox({
    'transitionIn'		: 'none',
    'transitionOut'		: 'none',
    'titlePosition'		: 'none'
  });

  $("#zigzegcontactform").validate({
    submitHandler: function(form) {
      $.ajax({
      url: "/listings/contact_zigzeg",
      type: "POST",
      data: $(form).serializeArray(),
      success: function(data) {
        $("#zsendmessage").show();
 	$("#zigzegcontactform .cform").hide();
        }
      });
    }
  });
});
