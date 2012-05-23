$(function() {
    $.validator.addMethod("validTelno", function(value, element) {
       var reg = new RegExp(/^[0-9\d=.+-]+$/);
       return this.optional(element) || reg.test(value);
    }, "Enter only numbers(0-9), dash(-) or dot(.)");  

		$('li.disabled a').click('click',function(ev){ev.preventDefault();});
		$('.oHours').change(function(e){
				if($(this).val() == 'normal'){
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
		$('#tagClick li').live('click',function(){
			var option = $('#tagsVal').val() == "" ? "" : $('#tagsVal').val()+", ";
			var tags = option+$(this).text();
			$('#tagsVal').val(tags).focus();
			$(this).remove();		
		});
		$('.catListStyle a.cat').live('click',function(e) {
			e.preventDefault();
				$('#category_input_label').hide();
				$(this).addClass('selected');
				var ids = $(this).attr('data-id');
				var selected_category_id = $("#selected_category_id").val();
				$('#category_input').val($(this).attr('data-id'));
				$('.catListStyle a.cat').not(this).removeClass('selected').hide();
				$('.catListStyle .selectCategory').show();
				$('.catListStyle .catDetails,#catHelpInfo').hide();
				$('#all_sub').show();
				$("#tags_div").show();
				var params = { id:ids, selected_category_id:selected_category_id };
				$.ajax({
				  type: "GET",
					url: "/welcome/show_sub_category?"+jQuery.param(params),
				  success:function(data){
					 $("#sub_category_div").html('').html(data).slideDown();
				   $('#sub_category_'+selected_category_id).trigger('click');
						
				  }
				});
				$.ajax({
							type: "GET",
							url: "/welcome/show_category_features?id="+ids,
							success:function(data){
								$("#category_features_div").html(data).slideDown();
							}
						});	 
				 
				
    });
		
		$('.xxcatListStyle a.cat').live('click',function(e) {
				$(this).addClass('selected');
				$('#category_input').val($(this).attr('data-id'));
				$('.catListStyle a.cat').not(this).removeClass('selected').slideUp();
				$('.catListStyle .selectCategory').fadeIn();
				$('.catListStyle .catDetails').hide();

				var id = $(this).attr('data-id');
				$('#category_input_label').hide();
				$('#all_sub').show();
				
				$.ajax({
				  type: "GET",
				  url: "/welcome/show_sub_category?id=" + id,
				  success:function(data){
				    $("#sub_category_div").empty();
				    $("#sub_category_div").append(data);
				    $("#category_features_div").empty();
				  }
				});

				$.ajax({
				  type: "GET",
				  url: "/welcome/show_category_features?id=" + id,
				  success:function(data){
				    $("#category_features_div").empty();
				    $("#category_features_div").append(data);
				  }
				});

    });
		$('.catListStyle .selectCategory').live('click',function(){
				$('.catListStyle .catDetails,#catHelpInfo').slideDown();
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
		function loadPage(path) {
			$("div#main")
						.hide().load(path+'').fadeIn();
		}
//		$('#btnFileShow').live('click',function(){
//				$('#btnFileHidden').click();
//		});
		$('#galFileShow').live('click',function(){
				$('#galFileHidden').click();
		});
});

function createUploader(id_val){  
	var uploader = new qq.FileUploader({
        element: document.getElementById(id_val),
	allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'], 
	onSubmit: function(id, fileName){},
		//this is use for additional paramater like the userid
		/*params: {
		id: 'value',
		},*/
		params: {
			authenticity_token: $("meta[name=csrf-token]").attr("content")
      },
	debug: true,
	multiple: false,
	sizeLimit: 4194304,
        messages: {
          sizeError: "{file} is too large, maximum file size is 4MB."
        },
	onSubmit: function(id, fileName){
		$('#imgProfile').text('Uploading...');	
	},
	onComplete: function(id, fileName, responseJSON){
if (responseJSON.error != undefined) {
  $('.qq-upload-list').empty();
}else{
		$('#imgProfile').css("background",'url(' + responseJSON.filename + ')');
		$('#withImage').val(responseJSON.filename);
		$('#imgProfile').text('');	
		$('.qq-upload-list').empty();
}
	},
	  action: '/welcome/upload_profile'
  });           
}


function createUploaderGallery(id_val){  
	var uploader = new qq.FileUploader({
        element: document.getElementById(id_val),
	allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'], 
	onSubmit: function(id, fileName){},
		//this is use for additional paramater like the userid
		/*params: {
		id: 'value',
		},*/
	debug: true,
	multiple: false,
	sizeLimit: 4194304,
        messages: {
          sizeError: "{file} is too large, maximum file size is 4MB."
        },
	onComplete: function(id, fileName, responseJSON){
if (responseJSON.error != undefined) {
		$('.qq-upload-list').empty();

}else{
		$('#'+id_val).css("background",'url(' + responseJSON.filename + ')').css("background-size","100% 100%");
		$('#gallery_id').val(responseJSON.id);
		$('.qq-upload-list').empty();
		$('.qq-upload-list').append('<li>Image uploaded</li>').fadeOut(1000);
		$('.galleryThumb').append('<li><img class="image0" src="' + responseJSON.filename + '"></li>');
}
	},
	  action: '/welcome/upload_gallery'
  });           
}



jQuery(function(){

    function getHandler(){
        if(qq.UploadHandlerXhr.isSupported()){           
            return qq.UploadHandlerXhr;                        
        } else {
            return qq.UploadHandlerForm;
        }
    }    
    asyncTest("upload", function() {                                      
            expect(2);
                            
            var data = {stringOne: 'rtdfghdfhfh',stringTwo: 'dfsgsdfgsdg',stringThree: 'dfsgfhdfhdg'};
            var savedId;
            var uploadHandler = new (getHandler())({
                action: 'upload.php',
                maxConnections: 1,
                onComplete: function(id, fileName, response){
                    if (!response.success){
                        ok(false, 'server did not receive file')
                        return;    
                    }
                    delete response.success;
                    delete response.qqfile;
                    same(response, data, 'server received file and data');
										$('#imgProfile').css("background",'url(uploads/'+fileName+')').css("background-size","100% 100%");  
						    }
            });
            $('#btnFileHidden,#galFileHidden').live('change',function(){upload()});    
            function upload(){
							  var file = this;
                if (uploadHandler instanceof qq.UploadHandlerXhr){
                    file = this.files[0];
                }
                var id = uploadHandler.add(file);        
                uploadHandler.upload(id, data);                
            }
    });
});   

$(document).ready(function(){  
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
								$(id).css('left',tLeft-185+($(this).width()));
							}else if(id == '#updatesListing'){
								$(id).css({'top':tTop+37});
								$(id).css('left',tLeft-(Math.abs(modW-($(this).width()+20))));
							}else{
								$(id).css({'top':tTop+35});
							}
							//transition effect
							$(id).slideDown(200); 
						});
			$('.gallery .rightArrow').live('mouseover',function(){
					var width = $('.galleryThumb').width();
					var left = $('.galleryContainer').scrollLeft()+width;
					$('.galleryThumb').animate({scrollLeft: left +'px'});					
			})
			$('.gallery .leftArrow').live('mouseover',function(){
					var width = $('.galleryThumb').width();
					var left = $('.galleryContainer').scrollLeft()+width;
					$('.galleryThumb').animate({scrollLeft: 0+'px'});							
			}) 
			$('a[name=gal]').live('mouseover',function(e) {
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
	$('a[name=modal]').live('click',function(e) {
							//Cancel the link behavior
							e.preventDefault();
							//Get the A tag
							var id = $(this).attr('href');
							var title = $(this).attr('title');
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
						//if close button is clicked
						$('.window .close').click(function (e) {
							//Cancel the link behavior
							e.preventDefault();
							$('#mask').hide();
							$('.window').hide();
							$('.logged').removeClass('selected');
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
							//Get the screen height and width
							var maskHeight = $(document).height();
							var maskWidth = $(window).width();
							$('#mask').css({'width':maskWidth,'height':maskHeight});
							
							$('#mask').show();	
							
							//Set the popup window to center
								$(id).css({'top':tTop-modH/2});
								$(id).css('left',tLeft+35);
								if(id=='#zigHelpPop'){
									$(id).css('left',tLeft-modW-90);
								}
							//transition effect
							$(id).fadeIn(300); 
							//if mask is clicked
						});		
						//if mask is clicked
						$('#mask').click(function () {
							$(this).hide();
							$('#mask').hide();
							$('.window').hide();
							$('.logged').removeClass('selected');
						});	 
						
});
