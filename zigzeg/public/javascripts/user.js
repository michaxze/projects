$(function() {

	$("#search").autocomplete("/search_autocomplete", {
		width: '100%',
		selectFirst: false,
		resultsClass:'s_result grid_12'
	});	

  $.validator.addMethod("validTelno", function(value, element) {
     var reg = new RegExp(/^[0-9\d=.+-]+$/);
     return this.optional(element) || reg.test(value);
  }, "Enter only numbers(0-9), dash(-) or dot(.)");
  
	$('.menuLink-fordeletion').live("click",function(ev){
			$('.menu a.selected').removeClass('selected'); 
				$(this).addClass('selected');
				ev.preventDefault();
				loadPage(this.href);
	});
	function loadPage(path) {
			$("div.mainContainer")
						.append('<div class="loader"></div>')
						.load(path+'');
	}
	$('.moreView').live("click",function(ev){
		ev.preventDefault();
		var href = $(this).attr('href');
		var id = $(this).attr('id');
		if($(this).hasClass('minus')){
			$(href).hide();	
			$(this).removeClass('minus');	
		}else{
			$(href).append('<div class="loader"></div>')
			.load('appends/'+id+'.html').hide().fadeIn();	
			$(this).addClass('minus');
		}
	});
	$('.backBtn').live('click',function(ev){
		ev.preventDefault(); 
			$("div.mainContainer")
						.append('<div class="loader"></div>')
						.load(this.href);
	})
	$('#submitMsg').live('click',function(ev){
			var msg = $('#replyMsg').val();
			var message_thread_id = $('#message_thread_id').val();
			var receiver_id = $('#receiver_id').val();
			var subject = $('#subject').val();
			if( msg != ''){
				$('#replyMsg').removeClass('error');
				$('#replyMsgError').hide();

				$.ajax({
				  type: "POST",
				  url: "/account/messages",
				  data: "content=" + msg + "&message_thread_id=" + message_thread_id + "&receiver_id=" + receiver_id + "&subject=" + subject,
				  async: false,
				  success:function(data){
 			            //replicate success after ajax submit
			            $('#replyMsg').val('');
 			            $('#appendMsg').prepend(data);
				  }
				});
			}else{
				$('#replyMsg').addClass('error');
				$('#replyMsgError').show();
			}
	})
	$('.viewOlderMessage').live('click',function(ev){
		var message_id = $('#message_id').val();
		ev.preventDefault();   
			$('.msgLoader').removeClass('dispNone');
			//RETRIEVE DATA VIA AJAX.
			
				$.ajax({
				  type: "GET",
				  url: "/account/messages/ajax_get_message_threads",
				  data: "id=" + message_id,
				  async: false,
				  success:function(data){
 			            //replicate success after ajax submit
 			            $('.olderMessages').prepend(data);
  				    $('.msgLoader').addClass('dispNone');
  				    $('.viewOlderMessage').empty();
				  }
				});
			
	});
	$('.getMessage').live("click",function(ev){
			ev.preventDefault();
			var id = $(this).attr('id');
			//here you can load the message box dynamically
			// for now it is static
			$("div.mainContainer")
			.append('<div class="loader"></div>')
			.load(this.href+'?id='+id)
                        var n_messages = $("#total_messages span").text();
                        if (n_messages > 0)
                          var total_messages = n_messages - 1;
                        $("#total_messages span").text(total_messages)
	});
	// removing the selected checkbox all on the ziglist and messages
	$('.removeSelected').live('click',function(ev){
          ev.preventDefault();
          //this is where the path for ajax update. href of the button
          var path = $(this.href);
          var length = $("input[name='checkZig']:checked").length;
          var idList = new Array();
          var ctr = 0;//counter of the loop
          if(length > 0){
            $("input[name='checkZig']:checked").each(function(){
              idList[ctr] = $(this).val();
              ctr += 1;
            });

				$.ajax({
				  type: "POST",
				  url: $(".removeSelected").attr('href'),
				  data: "ids=" + idList,
				  success:function(data){
                                    window.location.reload();
				  }
				});
            
          }else {
            url  = $(".removeSelected").attr('href').split("/");
            section = url[url.length - 1]
            if (section == "remove_messages") {
              alert("Unable to delete, no messages selected.");
            }else if (section == "remove_ziglist") {
              alert("Unable to delete, no ziglist selected.");
            }
          }

	});

});
$(document).ready(function(){  
				$('a[name=profInfo]').live('click',function(e) {
              e.preventDefault();
            });
						$('a[name=profInfo]').live('mouseover',function(e) {
							$('.window').hide();
							//Cancel the link behavior
							e.preventDefault();
							
							//Get the A tag
							var img = $(this).attr('href');
							var ttl = $(this).attr('rel');
							var desc = $(this).attr('data-id');
							$('#profInfo div.contents .imgBg').css('background','url('+img+')');
							$('#profInfo div.contents .name').text(ttl);
							$('#profInfo div.contents .detail').html(desc);
						
							var modW = ($("#profInfo").width());
							var modH = ($("#profInfo").height());
							var offset = $(this).offset();
							var tLeft = offset.left;
							var tTop = offset.top;
							//Set the popup window to center
								$("#profInfo").css({'top':tTop-12});
								$("#profInfo").css('left',tLeft+$(this).width()+10);
								
							
							//transition effect
							$("#profInfo").fadeIn(300); 
							$(this).mouseout(function () {
								$('.window').hide();
							});
						});
				
				$('a[name=helpT]').live('click',function(e) {
							$('.window').hide();
							//Cancel the link behavior
							e.preventDefault();
							//Get the A tag
							var id = $(this).attr('href');
							var desc = $(this).attr('title');
							$('#galDialog div.contents').html(desc);
							var modW = ($(id).width());
							var modH = ($(id).height());
							var offset = $(this).offset();
							var tLeft = offset.left;
							var tTop = offset.top;
							//Get the screen height and width
							var maskHeight = $(document).height();
							var maskWidth = $(window).width();
							$('#mask').css({'width':maskWidth,'height':maskHeight});
							$('#mask').show();	
							//Set the popup window to center
								$(id).css({'top':tTop+40});
								$(id).css('left',tLeft/2);
								if(id=='#zigHelpPop'){
									$(id).css('left',tLeft-modW);
								}
							//transition effect
							$(id).fadeIn(300); 
							//if mask is clicked
								 
						});	
			$('a[name=menuM]').click(function(e) {
							$('.window').hide();
							//Cancel the link behavior
							e.preventDefault();
							if($(this).hasClass('logged')){
								$(this).addClass('selected');
							}
							
							var id = $(this).attr('href');
							var modW = $(id).width();
							
							//Get the A tag
							var id = $(this).attr('href');
							var modW = $(id).width();
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
							}else if(id == "#accountSettings"){
								$(id).css({'top':tTop+36});
								$(id).css('left',tLeft-220+(35+$(this).width()));
							}else if(id == '#updatesListing'){
								$(id).css({'top':tTop+37});
								$(id).css('left',tLeft-($(this).width()+105));
								//$(id).css('left',tLeft-(Math.abs(modW-($(this).width()+20))));
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
						
});

function doSomething() {
		$("#boxes .window").each(function(){
				if($(this).css('display')=="block"){
						var idS = "#"+$(this).attr('id');
						$('a[name=modal]').each(function(){
							var id = $(this).attr('href');
							if(id==idS){
								if(idS=="#loginDialog"){
									var offset = $(this).offset();
								}else if(idS=="#reportDialog"){
									var offset = $(this).offset();
								}else{
									var offset = $("#signUpLink").offset();
								}
								var tLeft = offset.left;
								var tTop = offset.top;
								var modW = $(idS).width();
								var winW = $(window).width();
								$(idS).css({'top':tTop+30});
								$(idS).css('left',tLeft-modW);
								//alert(modW);
							}
						});
				}
		});	
};

var resizeTimer;
$(window).resize(function() {
    clearTimeout(resizeTimer);
    resizeTimer = setTimeout(doSomething, 0);
});
