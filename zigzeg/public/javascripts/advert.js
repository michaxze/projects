$(document).ready(function() {
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
	$('.validTelno').keyup(function(e) {
			val = $(this).val().replace(/ /g, '');
    	$(this).val(val);
  });
    $.validator.addMethod("validTelno", function(value, element) {
       var reg = new RegExp(/^[0-9\d=.+-]+$/);
       return this.optional(element) || reg.test(value);
    }, "Enter only numbers(0-9), dash(-) or dot(.)");
  	$('.tabO').live('click',function(e){
				e.preventDefault();
				var classO = $(this).attr('href');
				$('.tabO').addClass('gray');
				$(this).removeClass('gray');
				$('.overview .tabs').addClass('dispNone');
				$('.overview .'+classO).removeClass('dispNone');		
		});
		$('.oHours').change(function(e){
				if($(this).val() =='normal'){
					$('.scheduleList').slideDown();
				}else{
					$('.scheduleList').slideUp();
				}
		});
		$('.cbClose').click(function(){
			var pClass = $(this).val();
				if($(this).is(':checked')){
						$('.'+pClass+'Select').attr('disabled','true');
						$('.'+pClass+'Select').val('');
				}else{
						$('.'+pClass+'Select').removeAttr("disabled");
				}
		});
		$('.secondTime').click(function(e) {
      	if($(this).is(':checked')){
						$('.bHours .extra').css('display','block');
				}else{
						$('.bHours .extra').css('display','none');
				}
    });
		$('.applyTime').click(function(e) {
      var fromAm = $('#monFromAm').val();
			var toAm = $('#monToAm').val();
			var fromPm = $('#monFromPm').val();
			var toPm = $('#monToPm').val();

      $('.dayFrom').val(fromAm);
      $('.dayTo').val(toAm);
      $('.dayFromPm').val(fromPm);
      $('.dayToPm').val(toPm);			
			
    });
    $('.catListStyle a.cat').live('click',function(e) {
				$('#category_input_label').hide();
				$(this).addClass('selected');
				var id = $(this).attr('data-id');
				var selected_category_id = $("#selected_category_id").val();
				$('#category_input').val($(this).attr('data-id'));
				$('.catListStyle a.cat').not(this).removeClass('selected').hide();
				$('.catListStyle .selectCategory').show();
				$('.catListStyle .catDetails,#catHelpInfo').hide();
				$('#all_sub').slideDown();
				$.ajax({
				  type: "GET",
				  url: "/business/show_sub_category?id=" + id + "&selected_category_id=" + selected_category_id,
				  success:function(data){
				    $("#sub_category_div").empty().hide().html(data).slideDown();
				    $('#sub_category_' + selected_category_id).trigger('click');
						$.ajax({
							type: "GET",
							url: "/business/show_category_features?id=" + id,
							success:function(data){
								$("#category_features_div").empty().hide().html(data).slideDown();
							
							}
						});  
				  }
				});
				
    });
		$('.catListStyle .selectCategory').live('click',function(){
				$('.catListStyle .catDetails').slideDown();
				$('#catHelpInfo').show();
				$('.catListStyle a.cat').css('display', 'block');
				$('.catListStyle .selectCategory').fadeOut();
		});
		$('.catListStyle a.subCat').live('click',function(e) {
				if($(this).hasClass('selected'))
					$(this).removeClass('selected');
				else
					$(this).addClass('selected');
				
				selectedSubs = "";
				$('.catListStyle a.subCat').each(function(index, element) {
          	if($(this).hasClass('selected')){
							selectedSubs += $(this).attr('data-id')+",";
						}
        });
				$('#subcategory_input').val(selectedSubs);
		});
		$('a.features').live('click',function(e){
		e.preventDefault();
		$(this).toggleClass("selected");
		if($(this).hasClass('selected')){
				checkB = $(this).find('input:checkbox');
				checkB.attr('checked', true);
		}else{
				checkB = $(this).find('input:checkbox');
				checkB.attr('checked', false);
		}
	});
		$('.imageContain.delete').live('click',function(){
					if($(this).find('div.del').hasClass('selected')){
							$(this).find('div.del').removeClass('selected');
							$(this).find('input:checkbox').attr('checked', false);
					}else{
							$(this).find('div.del').addClass('selected');
							$(this).find('input:checkbox').attr('checked', true);
							$('.delImgLnk').show();
					}
		});
		$('.selectAllCB').live('click',function(e){
			e.preventDefault();
				if($(this).hasClass('unselect')){
						$('.imageContain.delete div.del').removeClass('selected');
					$('.imageContain.delete div.del input:checkbox').attr('checked', false);
					$('.selectAllCB').removeClass('unselect').text('Select All');
					$('.delImgLnk').hide();
				}else{
					$('.imageContain.delete div.del').addClass('selected');
					$('.imageContain.delete div.del input:checkbox').attr('checked', true);
					$('.selectAllCB').addClass('unselect').text('Deselect All');
					$('.delImgLnk').show();
				}
		});
		$('.delImgLnk').click(function(e){
			e.preventDefault();
			id_array = new Array();
                        ltype = $(this).attr('data-id');
			$('.delCB').each(function(index) {
		          if($(this).is(':checked')){
		            id_array.push($(this).val());
		          }
	 	        });
                   if (ltype == "deal") {
                     deal_id = $("#deal_id").val();
                     window.location.href = "/business/offers/delete_images?id=" + deal_id + "&picture_ids=" + id_array;
                   }else if(ltype == "event") {
                     event_id = $("#event_id").val();
                     window.location.href = "/business/events/delete_images?id=" + event_id + "&picture_ids=" + id_array;
                   }else {
                     place_id = $("#place_id").val();
                     window.location.href = "/business/delete_images?id=" + place_id + "&picture_ids=" + id_array;
                   }
		});
		$('.upgradePack').click(function(){
				$('.upgradeP').slideToggle();	
				$('#slChk').toggle();	
		});
		$('#slChk').click(function(e) {
				$('.upgradeP').slideToggle();	
				$('#slChk').toggle();	
		});
		$('#checkAll').click(function(){
					if($(this).is(':checked')){
							$('div.body input[name=checkZig]').attr('checked', true);
					}else{
							$('div.body input[name=checkZig]').attr('checked', false);
					}
			});
		$('.getDetails').live("click",function(ev){
			ev.preventDefault();
			var id = $(this).attr('data-id');
			//data id can be used for ajax retrieving of the detailed info.
			//here you can load the message box dynamically
			// for now it is static
			$("div.mainContainer")
				.append('<div class="loader"></div>')
				.load(this.href+'?id='+id)
	});
	$('.galDesc').live('click',function(e){
			var id = $(this).attr('data-id');
			//alert('retrieve particular data on this id:'+id+'\nto be populated on this modal form');
	});
	//TRIGGERS THE UPLOADIFY
	$('.galleryImages div.empty').live('click',function(){
			 $('#file_upload').click();
	});
	$('#imageAdd').live('click',function(){
				$('#imgBtnAdd').click();
	});
	$('#imgBtnAdd').live('change',function(){
				$('#dispImgName').text($(this).val())
	});
	$('.menuBar-fordelete').live("click",function(ev){
				$(this).addClass('selected');
				ev.preventDefault();
				loadPage(this.href);
	});
	$('.menuLink').live("click",function(ev){
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
	$('#btnFileShow,#galleryPop').live('click',function(){
			$('#btnFileHidden').click();
	});
	$('#btnFileHidden').live('change',function(){
			src = $(this).val();
			$('#galleryPop').attr('src',src);
	});
	
	$('#tagClick li').live('click',function(){
	    tags = $("#tagsVal").val();
	    tags_arr = tags.split(",")
	    new_tag = jQuery.trim($(this).text());
            new_str = ""

	    for(i=0; i<tags_arr.length; i++) {
	      clean = jQuery.trim(tags_arr[i])
              if (clean != "") {
               if (clean != new_tag)
  	         new_str += clean + ", "
              }
	    }
	    
			var option = new_str; //$('#tagsVal').val() == "" ? "" : $('#tagsVal').val()+", ";
			var tags = option+$(this).text();
			$('#tagsVal').val(tags).focus();
			$(this).remove();		
	});
	$('#aboutCompany').live('keydown',function(){
			textCounter($(this),$('#countChar'),2500);
	});
	$('#aboutCompany').live('keyup',function(){
			textCounter($(this),$('#countChar'),2500);
	});
	$('.removeSelected').live('click',function(ev){
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
		
			}else{
            url  = $(".removeSelected").attr('href');
            if (url != undefined) {
              url = url.split("/");
              section = url[url.length - 1]
              if (section == "remove_messages") {
                alert("Unable to delete, no messages selected.");
              }else if (section == "remove_ziglist") {
                alert("Unable to delete, no aiglist selected.");
              }else if (section == "remove") {
                alert("Unable to delete. Please select an "+url[2].substring(0, url[2].length-1)+" to delete.");
              }
            }else{ 
              alert("Unable to delete, no ziglist dselected.");
            }

                        }
			ev.preventDefault();
	});


	$('.viewOlderMessage').live('click',function(ev){
		var message_id = $('#message_id').val();
		ev.preventDefault();   
			$('.msgLoader').removeClass('dispNone');
			//RETRIEVE DATA VIA AJAX.
			
				$.ajax({
				  type: "GET",
				  url: "/business/messages/ajax_get_message_threads",
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
				  url: "/business/messages",
				  data: "content=" + msg + "&message_thread_id=" + message_thread_id + "&receiver_id=" + receiver_id + "&subject=" + subject,
				  success:function(data){
 			            //replicate success after ajax submit
			            $('#replyMsg').val('');
 			            $('#appendMsg').prepend(data); 
                                    //$("#msgsent_notice").show().effect("highlight", {}, 1000).fadeOut();
				  }
				});
			}else{
				$('#replyMsg').addClass('error');
				$('#replyMsgError').show().delay(1500).fadeOut();
			}
	})

	$('#submitMsgdelete').live('click',function(ev){
			var msg = $('#replyMsg').val();
			if( msg != ''){
					$('#replyMsg').removeClass('error');
					$('#replyMsgError').hide();
					
					//for ajax submission of the message
					
					//replicate success after ajax submit
					$('#replyMsg').val('');
					$('#appendMsg')
							.append('<div class="user row">'+
                  '<div class="grid_2"><a>Username</a></div>'+
                  '<div class="grid_8">'+msg+'</div>'+
                  '<div class="grid_2">30/10/2011</div>'+
                  '<div class="clear"></div>'+
              '</div>');
							
			}else{
				$('#replyMsg').addClass('error');
				$('#replyMsgError').show();
			}
	})
	
	function textCounter(field,cntfield,maxlimit) {
			if (field.val().length > maxlimit){ // if too long...trim it!
					text = field.val().substring(0, maxlimit);
					field.val(text);
			}
			else
					cntfield.text(maxlimit - field.val().length);
	}
	$('.complete_url').keypress(function(e) {
		$(this).valid();
  });
	jQuery.validator.addMethod("complete_url", function(val, elem) {
		// if no url, don't do anything
    if (val.length == 0) { return true; 
		}else{
    // if user has not entered http:// https:// or ftp:// assume they mean http://
    if(!/^(https?):\/\//i.test(val)) {
			val = val.replace(/www/gi, "");
			val = val.replace(/com/gi, "");
			val = val.replace(/\./g, "");
  var type = $(elem).attr('id');
				if(type == 'fb_url'){
					val = val.replace(/facebook/gi, "");
					val = 'http://www.facebook.com/'+val; // set both the value
				}
				else if(type == 'twitter_url'){
					val = val.replace(/twitter/gi, "");
					val = 'http://www.twitter.com/'+val; // set both the value
				}
				else{
          if (val == "http:/")
            val = "http://"
          else
            val = 'http://'+val; // set both the value
				}
				
        $(elem).val(val); // also update the form element
    }
		}
    return /^(https?):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&amp;'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&amp;'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&amp;'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&amp;'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&amp;'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i.test(val);
}, 'You must enter a valid URL');

});
$(document).ready(function(){  
				$('a[name=modal]').live('mouseover',function(e) {
							$('.window').hide();
							//Cancel the link behavior
							e.preventDefault();
							//Get the A tag
							var id = $(this).attr('href');
							var desc = $(this).attr('data-id');
							$('#galDialog div.contents').html(desc);
							var modW = ($(id).width()*.3);
							var modH = ($(id).height()+45);
							var offset = $(this).offset();
							var tLeft = offset.left;
							var tTop = offset.top;
							//Set the popup window to center
								$(id).css({'top':tTop-modH});
								$(id).css('left',tLeft-modW-50);
								if(id=='#zigHelpPop'){
									$(id).css('left',tLeft-modW-90);
								}
							
							//transition effect
							$(id).fadeIn(300); 
							$(this).mouseout(function () {
								$('.window').hide();
							});
						});
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
					$('a[name=help]').live('click',function(e) {
							$('.window').hide();
							//Cancel the link behavior
							e.preventDefault();
							//Get the A tag
							var id = $(this).attr('href');
							var desc = $(this).attr('title');
							$('#galDialog div.contents').html(desc);
							var modW = ($(id).width()/2);
							var modH = ($(id).height());
							var offset = $(this).offset();
							var tLeft = offset.left;
							var tTop = offset.top;
							
							var maskHeight = $(document).height();
							var maskWidth = $(window).width();
							$('#mask').css({'width':maskWidth,'height':maskHeight});
							//Get the screen height and width
							$('#mask').show();	
							
							//Set the popup window to center
								$(id).css({'top':tTop-modH/2});
								$(id).css('left',tLeft+35);
								if(id=='#zigHelpPop'){
									$(id).css('left',tLeft-modW-90);
								}
								if(id=='#eventPricingH'){
									$(id).css('left',tLeft-modW-100);
									$(id).css({'top':tTop-modH-50});
								}
								if(id=="#howGetOffer"){
									$(id).css('left',tLeft-(modW+110));
									$(id).css({'top':tTop+(modH-100)});
								}
							//transition effect
							$(id).fadeIn(300); 
							//if mask is clicked
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
						//if close button is clicked
						$('.window .close').click(function (e) {
							//Cancel the link behavior
							e.preventDefault();
							$('.window').hide();
							
						});		
						$('#mask').click(function () {
							$(this).hide();
							$('.window').hide();
							$('.logged').removeClass('selected');
						});
						$('a[name=helpInfo]').live('click',function(e) {
							//Cancel the link behavior
							e.preventDefault();
							//Get the A tag
							var id = $(this).attr('href');
							var title = $(this).attr('data-id');
							$(id+' p.helpContent').html(title);
							var modW = ($(id).width()/2);
							var modH = ($(id).height());
							var offset = $(this).offset();
							
							var tLeft = offset.left;
							var tTop = offset.top;
							//Get the screen height and width
							var maskHeight = $(document).height();
							var maskWidth = $(window).width();
							$('#mask').css({'width':maskWidth,'height':maskHeight});
							//Set heigth and width to mask to fill up the whole screen
							$('#mask').show();	
							//Get the window height and width
							var winH = $(window).height();
							var winW = $(window).width();
							//Set the popup window to center
								$(id).css({'top':tTop-modH-50});
								$(id).css('left',tLeft-modW);
							//transition effect
							$(id).fadeIn(); 
						});	   
							$('a[name=menuM]').click(function(e) {
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
							$('#mask').css({'width':'95%','height':maskHeight});
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
								if($(this).hasClass('pgSet')){
									$(id).css({'top':tTop+46});
									$(id).css('left',tLeft-220+(35+$(this).width()));
								}else
								$(id).css('left',tLeft-185+($(this).width()));
							}else if(id == '#updatesListing'){
								if($(this).hasClass('pgUp'))
									$(id).css({'top':tTop+45});
								else
									$(id).css({'top':tTop+37});
								$(id).css('left',tLeft-(Math.abs(modW-($(this).width()+20))));
							}else{
								$(id).css({'top':tTop+35});
							}
							//transition effect
							$(id).slideDown(200); 
						});
						//if close button is clicked
						
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
										$(idS).css({'top':tTop+35});
									}
							
								
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
})
