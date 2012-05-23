(function(){
    // remove layerX and layerY
    var all = $.event.props,
        len = all.length,
        res = [];
    while (len--) {
      var el = all[len];
      if (el != 'layerX' && el != 'layerY') res.push(el);
    }
    $.event.props = res;
}());
function url( name )
	{
		name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
		var regexS = "[\\?&]"+name+"=([^&#]*)";
		var regex = new RegExp( regexS );
		var results = regex.exec( window.location.href );
		if( results == null )
			return false;
		else
			return results[1];
	}
	 Cufon.replace('.script', { fontFamily: 'Script MT Bold' });  
	$(document).ready(function() {
	$('a[name=tTip]').live('click',function(e) {
							//Cancel the link behavior
							e.preventDefault();
							$('.window').hide();
							//Get the A tag
							var id = $(this).attr('href');
							var title = $(this).attr('rel');
							var content = $(this).attr('title');
							$(id+' h6.title').html(title);
							$(id+' p.content').html(content);
							
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
							//Get the window height and width
							var winH = $(window).height();
							var winW = $(window).width();
							//Set the popup window to center
								$(id).css({'top':tTop-modH/2});
								$(id).css('left',tLeft+35);
							//transition effect
							$(id).fadeIn(); 
						});
		$('.packClick').click(function(){
				var package = $(this).attr('name');
          if (package == "basic" || package == "premium") {
              window.location.href="/registration/business_reg?signup=advert&package=" + package
          }
				$('#packageType').val(package);
				$('#packageSelect').hide();
				$('.packageDetails').hide()
				$('#stepAReg').fadeIn();
				$('.packageChosen').addClass(package+'P');
				$('.packageChosen').text(package);
		});
		$('.backPackage').click(function(){
				$('#packageType').val('');
				$('#stepAReg').hide();
				$('#packageSelect,.packageSelectArea').show();
		});
		$('.fullList').click(function(){$('.packageSelectArea').slideUp();$('.packageDetails').fadeIn();});
		if(url('signup') && url('signup')=='advert'){
				$('#tabAdvert').addClass("current"); 
				$("#headerSignup").slideDown().removeClass('userheader').addClass('advertheader');
				$("#tabUser").removeClass('current');
				$("#advertFrmContent").removeClass('dispNone');
				$("#advertFrmContent").fadeIn();
				$("#userFrmContent").hide();
		}
			$("#tabUser").click(function(){
				$(this).addClass("current"); 
				$("#headerSignup").removeClass('advertheader').slideDown().addClass('userheader');;
				$("#tabAdvert").removeClass('current');
				$("#userFrmContent").fadeIn();
				$("#advertFrmContent").hide();
				$(".formError").hide();
			});
			$("#tabAdvert").click(function(){
				$(this).addClass("current"); 
				$("#headerSignup").slideDown().removeClass('userheader').addClass('advertheader');
				$("#tabUser").removeClass('current');
				$("#advertFrmContent").removeClass('dispNone');
				$("#advertFrmContent").fadeIn();
				$("#userFrmContent").hide();
				$(".formError").hide();
			});
		
	
	});
	 