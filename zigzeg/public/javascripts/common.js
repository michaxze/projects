$(document).ready(function(e) {
  $.validator.addMethod("validTelno", function(value, element) {
     var reg = new RegExp(/^[0-9\d=.+-]+$/);
     return this.optional(element) || reg.test(value);
  }, "Enter only numbers(0-9), dash(-) or dot(.)");
	var customizeForDevice = function(){
    var ua = navigator.userAgent;
    var checker = {
      iphone: ua.match(/(iPhone|iPod|iPad)/),
      blackberry: ua.match(/BlackBerry/),
      android: ua.match(/Android/)
    };
    if (checker.android || checker.iphone || checker.blackberry){
       $('#logInLink').attr('href','/login').attr('name','');
    }
	}
customizeForDevice();
});


function doSomething() {
		$("#boxes .window").each(function(){
				if($(this).css('display')=="block"){
						var idS = "#"+$(this).attr('id');
						$('a[name=modal]').each(function(){
							var id = $(this).attr('href');
								if(id==idS){
								if(idS == "#reportDialog"||idS == "#reportSuccess"){
									var offset = $('#reportPage').offset();
								}else{
									var offset = $(this).offset();
								}
								var tLeft = offset.left;
								var tTop = offset.top;
								var modW = $(idS).width()-50;
								var winW = $(window).width();
								$(idS).css('left',tLeft-(modW*.8));
									if(idS == "#loginDialog" || idS=="#loginMessage" || idS=="#zigMessagePop"){
										$(idS).css({'top':tTop+40});
									}else if(id == "#accountSettings"){
										$(idS).css({'top':tTop+36});
										$(idS).css('left',tLeft-220+(35+$(this).width()));
									}else if(id == '#updatesListing'){
										$(idS).css({'top':tTop+37});
										$(idS).css('left',tLeft-(Math.abs(modW-($(this).width()+20))));
									}else{
										$(idS).css({'top':tTop+45});
									}
							
								
								//alert(modW);
							}
						});
				}
		});	
};
var addthis_config = {
ui_click: true,
data_use_flash: false
}
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
						$('a[name=modal]').live('click',function(e) {
							$('.window').hide();
							//Cancel the link behavior
							e.preventDefault();
							if($(this).hasClass('logged')){
								$('a.logged').removeClass('selected');
								$(this).addClass('selected');
							}
							//Get the A tag
							var id = $(this).attr('href');
							var modW = $(id).width();
							if(id=="#reportDialog"||id=="#reportSuccess"){
									var offset = $('#reportPage').offset();
							}else{
								var offset = $(this).offset();
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
							$(id).css('left',tLeft-(modW*.8));
							if(id == "#loginDialog" || id=="#loginMessage" || id=="#zigMessagePop"){
								$(id).css({'top':tTop+40});
							}else if(id == "#accountSettings"){
								$(id).css({'top':tTop+36});
								if($(this).hasClass('map'))
									$(id).css('left',tLeft-220+(25+$(this).width()));
								else if($(this).hasClass('pgSet')){
									$(id).css({'top':tTop+46});
									$(id).css('left',tLeft-220+(35+$(this).width()));
								}else
									$(id).css('left',tLeft-220+(35+$(this).width()));
								
							}else if(id == '#updatesListing'){
								if($(this).hasClass('pgUp'))
									$(id).css({'top':tTop+45});
								else
									$(id).css({'top':tTop+37});
									
								$(id).css('left',tLeft-(Math.abs(modW-($(this).width()+20))));
							}else{
								$(id).css({'top':tTop+35});
							}
							$(this).addClass('selected');
							//transition effect
							$(id).slideDown(200); 
							$('#loginfrm input.email').focus()
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
							$('.logged,a[name=modal]').removeClass('selected');
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
							       }else if(data.slice(0,6) == "verify" ) {
							         location.replace(data);
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
							
								$('#advanceSearchBtn').click(function(){
										if($(this).hasClass('gray')){
											$('.sResult .closeBtn').click();
											$('#advanceSearchBtn').removeClass('gray');
											$('#aSearchContainer').animate({"height": "toggle", "opacity": "toggle"}).css({'display':'inline-block'});
										}else{									
											$('#advanceSearchBtn').addClass('gray');
											$('#aSearchContainer').slideUp();	
										}
								});
						$('.advanceButtons div').click(function(e) {
								$(this).toggleClass('selected');
								if($(this).hasClass('selected'))
									$(this).find('input.chkBx').attr('checked',true);
								else
									$(this).find('input.chkBx').attr('checked', false);
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
	$('#noHoverF').unbind('mouseover').unbind('mouseleave');

	
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


