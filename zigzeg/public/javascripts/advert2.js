$(function() {
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
      var fromAm = $('.monSelect[name=monFrom]').val();
			var toAm = $('.monSelect[name=monTo]').val();
			var fromPm = $('.monSelect[name=monFromPm]').val();
			var toPm = $('.monSelect[name=monToPm]').val();
			$('.time[name=tueFrom],.time[name=wedFrom],.time[name=thuFrom],.time[name=friFrom],.time[name=satFrom],.time[name=sunFrom]').val(fromAm);
			$('.time[name=tueTo],.time[name=wedTo],.time[name=thuTo],.time[name=friTo],.time[name=satTo],.time[name=sunTo]').val(toAm);
			$('.time[name=tueFromPm],.time[name=wedFromPm],.time[name=thuFromPm],.time[name=friFromPm],.time[name=satFromPm],.time[name=sunFromPm]').val(fromPm);
			$('.time[name=tueToPm],.time[name=wedToPm],.time[name=thuToPm],.time[name=friToPm],.time[name=satToPm],.time[name=sunToPm]').val(toPm);
    });
		$('.catListStyle a.cat').live('click',function(e) {
				$(this).addClass('selected');
				$('#category_input').val($(this).attr('data-id'));
				$('.catListStyle a.cat').not(this).removeClass('selected').slideUp();
				$('.catListStyle .selectCategory').fadeIn();
				$('.catListStyle .catDetails').hide();
				//alert('on category select, Repopulate the sub category on this class(subcatContainer)')
    });
		$('.catListStyle .selectCategory').live('click',function(){
				$('.catListStyle .catDetails').slideDown();
				$('.catListStyle a.cat').css('display', 'block');
				$('.catListStyle .selectCategory').fadeOut();
				
		});
		$('.catListStyle a.subCat').live('click',function(e) {
				$(this).addClass('selected');
				$('#subcategory_input').val($(this).attr('data-id'));
				$('.catListStyle a.subCat').not(this).removeClass('selected').slideUp();
				$('.catListStyle .selectSubCategory').fadeIn();
				$('.catListStyle .subCatDetails').hide();
    });
		$('.catListStyle .selectSubCategory').live('click',function(){
				$('.catListStyle .subCatDetails').slideDown();
				$('.catListStyle a.subCat').css('display', 'block');
				$('.catListStyle .selectSubCategory').fadeOut();
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
		$('.upgradePack').click(function(){
					$('.upgradeP').slideToggle();
			});
			$('#checkAll').change(function(){
					if($(this).is(':checked'))
							alert('check all')
					else
							alert('uncheck all')
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
			alert('retrieve particular data on this id:'+id+'\nto be populated on this modal form');
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
	$('.menuBar').live("click",function(ev){
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
			var option = $('#tagsVal').val() == "" ? "" : $('#tagsVal').val()+", ";
			var tags = option+$(this).text();
			$('#tagsVal').val(tags).focus();
			$(this).remove();
	});
	$('#aboutCompany').live('keydown',function(){
			textCounter($(this),$('#countChar'),600);
	});
	$('#aboutCompany').live('keyup',function(){
			textCounter($(this),$('#countChar'),600);
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
				alert("for ajax sending of the list = "+idList);
			}
			ev.preventDefault();
	});
	
	$('#submitMsg').live('click',function(ev){
			var msg = $('#replyMsg').val();
			if( msg != ''){
					$('#replyMsg').removeClass('error');
					$('#replyMsgError').hide();
					
					//for ajax submission of the message
					alert('submit msg');
					
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

});
$(document).ready(function(){  
	$('a[name=modal]').live('mouseover',function(e) {
							$('.window').hide();
							//Cancel the link behavior
							e.preventDefault();
							//Get the A tag
							var id = $(this).attr('href');
							var desc = $(this).attr('title');
							$('#galDialog div.contents').html(desc);
							var modW = ($(id).width()*.3);
							var modH = ($(id).height()+50);
							var offset = $(this).offset();
							var tLeft = offset.left;
							var tTop = offset.top;
							//Set the popup window to center
								$(id).css({'top':tTop-modH});
								$(id).css('left',tLeft-modW);

							//transition effect
							$(id).fadeIn(300); 
						});
						//if close button is clicked
						$('.window .close').click(function (e) {
							//Cancel the link behavior
							e.preventDefault();
							$('.window').hide();
						});		
						//if mask is clicked
						$(this).mouseout(function () {
							$('.window').hide();
						});	 
						
						
});


