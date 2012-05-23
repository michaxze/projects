$(function() {

	$('.galDesc').live('click',function(e){
			var id = $(this).attr('data-id');
			//alert('retrieve particular data on this id:'+id+'\nto be populated on this modal form');
	});
  
  
	$("#newMessageForm").validate({
			submitHandler: function(form) {
		    $('.grayLoader.profile').show();
			  form.submit();
			}
	}); 
  
  $("#suspendBtn").click(function(ev) {
		ev.preventDefault();
		stype = $("#suspend_type").val();
		user_id = $("#user_id").val();

    $.ajax({
      type: "POST",
      url: "/admin/users/suspend",
      data: "id=" + user_id + "&stype=" + stype,
      success: function(data) {
        $('#suspendWrapper').fadeToggle();
      }
    })

  });
  
  $('viewOlderMessage').live('click', function(ev) {
    var message_id = $("#message_id").val();
    ev.preventDefault();
    $('.msgLoader').removeClass('dispNone');
    $.ajax({
      type: "GET",
      url: "/admin/messages/ajax_get_message_threads",
      data: "id=" + message_id,
      success: function(data) {
        $('.olderMessages').prepend(data);
        $(".msgLoader").addClass('dispNone');
        $('.viewOlderMessage').empty();
      }
    })
  });
  
	$("#profileFrm").validate({
			submitHandler: function(form) {
		    $('.grayLoader.profile').show();
			  form.submit();
			}
	}); 
	
	$('#suspendAccount').click(function(ev){
			ev.preventDefault();
			$('#suspendWrapper').fadeToggle();
	});
	$('#suspendWrapper .suspendContain span.close').click(function(ev){
			ev.preventDefault();
			$('#suspendWrapper').fadeOut();
	})
	$('.backLink').live("click",function(ev){
				ev.preventDefault();
				loadPage(this.href);			
	});
	$('#adminType').live("change",function(){
				if($(this).val()=='master'){
						$('ul.access li input[type="checkbox"]').each(function(){
								this.checked = true;
						});
				}
	});

	$('#filterZig').change(function(){
			var listing_type = $(this).val();
			$('#ziglistWrap div.row').show();

			if(listing_type){
				$('#ziglistWrap div.row').each(function(index, element) {
					var data = $(this).attr('listing-type');
					if(data != listing_type)
							$(this).hide();
				});
			}
	});
	$('.filterSort').live("click",function(ev){
				ev.preventDefault();
				loadPage(this.href);
				var id = $(this).attr('data-id');
				$.ajax({
				url: "appends/alertType"+id+".html",
				dataType:'html',
				success: function(data){
					$("div.alert div.body").empty()
					.append(data);
					$("#filterAlert").val(id);
					$('.menu a.selected').removeClass('selected'); 
					$(".menu .menuAlert").addClass('selected');
					}
				});
	});
	$('ul.access li a.checkAll').live('click',function(){
			if($(this).hasClass('checked')){
					$('ul.access li input[type="checkbox"]').each(function(){
							this.checked = false;
					});
					$(this).removeClass('checked').text('Select all options');
			}else{
					$('ul.access li input[type="checkbox"]').each(function(){
							this.checked = true;
					});
					$(this).addClass('checked').text('Unselect all options');
			}
	});
	$('li input.systemCheck').live('click',function(ev){
			var checked_status = this.checked;
			$('li input.sub').each(function(){
					this.checked = checked_status;
			});
	});
	$('li input[type="checkbox"].sub').click(function(ev){
			var cbCount = $('li input[type="checkbox"].sub').length;
			var checkCount = $('li input[type="checkbox"].sub:checked').length;
			if(checkCount != cbCount){
				$('li input[type="checkbox"]').removeAttr('checked');
			}else{
				$('li input[type="checkbox"].systemCheck').attr("checked", "checked");
			}
	});
	$('.gotomsg').live("click",function(ev){
				ev.preventDefault();
				loadPage(this.href);
				$('.menu a.selected').removeClass('selected'); 
				$(".menu .menuMsg").addClass('selected');
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
	$('.createData').live('click',function(ev){
			ev.preventDefault();
			$("div.mainContainer")
				.append('<div class="loader"></div>')
				.load(this.href);
	})
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
	$('#filterAlert').live('change',function(){
			//THIS IS WHERE THE AJAX OF FILTERING OF THE ALERT HAPPENS
			//$(this).val() is the type of alert to be rendered
			var filter = $(this).val();
			window.location.href="/admin/alerts?type=" + filter;

	});
	
	$('.category_add').live('click',function(ev){
		ev.preventDefault();
		var id = $(this).attr('data-id');
		var value = $('#sub_cat0').val();
		if(value != ''){
				$('#category_error').addClass('dispNone');
				$('#sub_cat0').removeClass('error');
				$('.category_list').append('<li class="liCat'+id+'"><input type="text" value="'+value+'" name="category[]" id="subCat'+id+'" class="required text-input fancyinput" />'+
				'<a class="category_remove" data-id="'+id+'"></a></li>');
				$('#sub_cat0').val('');
				$(this).attr('data-id',++id);
		}else{
				$('#category_error').removeClass('dispNone');
				$('#sub_cat0').addClass('error');
		}
	});
	
	$('.category_remove').live('click',function(ev){
		ev.preventDefault();
		var id = $(this).attr('data-id');
		 $('.liCat'+id).remove();
	});
	// removing the selected checkbox all on the ziglist and messages
	$('.removeSelected').live('click',function(ev){
			//this is where the path for ajax update. href of the button
			ev.preventDefault();
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
				  data: "ids=" + idList
				});

			}

	});
	//SETTING THE ALERTS INTO DONE
	$('.setDone').live('click',function(ev){
		ev.preventDefault();
		var id = $(this).attr('data-id');
		$.ajax({
		  url: "/admin/alert_done",
		  type: "GET",
		  async: true,
		  data: "id=" + id,
		  success: function(data){
		    $("#appendArea" + id).slideUp().empty();
		    $("div.body div.list" + id).removeClass("pending");
		    $("div.body div.list" + id + "div.status").text("done");
		    $("div.body div.list" + id + "div a").removeClass("alertDetails");
		    $(".alert .list" + id).removeClass("show");
		  }
		});
	});
	$('.alertDetails').live("click",function(ev){
		ev.preventDefault();
		
		var id = $(this).attr('data-id');
		if($('.alert .list'+id).hasClass('show')){
				$('#appendArea'+id)
					.slideUp().empty();
				$('.alert .list'+id).removeClass('show');
		}else{
			//THIS IS WHERE THE AJAX OF RETRIEVING THE DETAILS OF THE ALERT HAPPENS
			$.ajax({
			  url: "/admin/alert_details",
			  type: "GET",
			  async: true,
			  data: "id=" + id,
			  success: function(data) {
			    $("#appendArea" + id).hide().append(data).slideDown();
			    $(".alert .list" + id).addClass("show");
			  }
			});
		}
	})
	
	//this area is for submitting a reply in the message box
	$('#submitMsg').live('click',function(ev){
			var msg = $('#replyMsg').val();
			var message_thread_id = $("#message_thread_id").val();
			var receiver_id = $("#receiver_id").val();
			var subject = $("#subject").val();
			
			if( msg != '' && subject != ''){
					$('#replyMsg').removeClass('error');
					$('#replyMsgError').hide();

					$('#subject').removeClass('error');
					$('#subjectError').hide();

          $.ajax({
            type: "POST",
            url: "/admin/messages",
            data: $("#newMessageForm").serializeArray(),
            success: function(data) {
              if (data == "success") {
                window.location.href='/admin/messages';
              }else{
                $("#replyMsg").val('');
                $("#appendMsg").prepend(data);
              }
            }
          });

			}else{
        if (subject == '') {
  			  $("#subjectError").addClass('error');
  			  $("#subjectError").show();
			  }else{
  			  $("#subjectError").removeClass('error');
  			  $("#subjectError").hide();			    
			  }
			  
			  if (msg == '') {
				  $('#replyMsg').addClass('error');
				  $('#replyMsgError').show();
			  }else{
				  $('#replyMsg').removeClass('error');
				  $('#replyMsgError').hide();
			  }
			}
	})
	
});
$(document).ready(function(){  
	$('.scrollPosition').click(function(e){
		e.preventDefault();
		ids = $(this).attr('href');
		var pos =  $(ids).offset().top; 
		$('html, body').animate({scrollTop: pos}, 500);
	})
	$('#companyFrm #comp_logo').focus(function(){
			$('#companyFrm #comp_logo_file').click();
	});
	$('#companyFrm #comp_logo_file').change(function(){
			$('#companyFrm #comp_logo').val($(this).val());
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
	$('.stat').live('click',function(e){
			var id = $(this).attr('data-id');
			alert('populate the form by retrieving the data on this id:'+id);
	});			
	$('.expand').live('click',function(e){
		e.preventDefault();
		dataId = $(this).attr('data-id');
		
		$('.'+dataId).load($(this).attr('href'));
	});
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
								else
									$(id).css('left',tLeft-220+(35+$(this).width()));
								
							}else if(id == '#updatesListing'){
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
