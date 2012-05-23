var geocoder; 
var map;
var markers = [];
var iterator = 0;
var listings = [];
var arreys = [];
var infowindowsArray = [];
var infoBigWindowsArray = [];
    geocoder = new google.maps.Geocoder();

myOptions2 = "";
boxText2 = "";

function showZoomControl(controlDiv, map) {

  // Set CSS styles for the DIV containing the control
  // Setting padding to 5 px will offset the control
  // from the edge of the map
  controlDiv.style.padding = '5px';

  // Set CSS for the control border
  var controlUI = document.createElement('DIV');
  controlUI.style.backgroundColor = '#000000';
  controlUI.style.borderStyle = 'solid';
  controlUI.style.borderWidth = '10px';
  controlUI.style.cursor = 'pointer';
  controlUI.style.textAlign = 'center';
  controlUI.title = 'Zoom map';
  controlDiv.appendChild(controlUI);

  // Set CSS for the control interior
  var controlText = document.createElement('DIV');
  controlText.style.fontFamily = 'Arial,sans-serif';
  controlText.style.fontSize = '12px';
  controlText.style.paddingLeft = '4px';
  controlText.style.paddingRight = '4px';
  controlText.innerHTML = '<b>Zoom</b>';
  controlUI.appendChild(controlText);

  // Setup the click event listeners: simply set the map to
  // Chicago
  google.maps.event.addDomListener(controlUI, 'click', function() {
    map.setCenter(chicago)
  });

}
    
function clearInfoWindows() {
  if (infowindowsArray) {
    for (i in infowindowsArray) {
      infowindowsArray[i].close();
    }
  }
}

function clearBigInfoWindows() {
  if (infoBigWindowsArray) {
    for (i in infoBigWindowsArray) {
      infoBigWindowsArray[i].close();
    }
  }
}
function clearOverlays() {
  if (markers) {
    for (i in markers) {
      markers[i].setMap(null);
    }
  }
}


function drop_markers() {
  for (var i = 0; i < listings.length; i++) {
    setTimeout(function() {
      addMarker();
    }, i * 200);
  }
}

function addMarker() {
  var image = '/images/places_32.png';

  m = new google.maps.Marker({
    position: listings[iterator].latlng,
    map: map,
    draggable: false,
    icon: image,
    title: listings[iterator].name,
    animation: google.maps.Animation.DROP
  });
	markers.push(m);
	
	var contentDiv = document.createElement("div");
	contentDiv.innerHTML =  listings[iterator].name; 
  var infowindow = new google.maps.InfoWindow({
      content: contentDiv,
      zIndex: 150,
	});
  infowindowsArray.push(infowindow);
  
  
  var bigString = '<div style="background-color: green; height:200px;">' + 
  '<h2>' + listings[iterator].name + '</h2>' +
  '<p>' + listings[iterator].description + '</p>' +
  '<p><a href="' + listings[iterator].link + '">View Page</a>' +
  '</div>';
	
  infoBigWindow = new google.maps.InfoWindow({
    content: bigString,
    zIndex: 100,
		
  });
  infoBigWindowsArray.push(infoBigWindow);
	 			
  google.maps.event.addListener(m, 'click', function(ev) {
    m.position = ev.latLng;
    clearBigInfoWindows();
    infoBigWindow.open(map,m);
  });

  google.maps.event.addListener(m, 'mouseover', function(ev) {
    clearInfoWindows();
    m.position = ev.latLng;
    infowindow.open(map,m);
  });

  google.maps.event.addListener(m, 'mouseout', function(ev) {
    clearInfoWindows();
  });

  markers.push(m);
  iterator++;
}

var newMarkers = [],marker;
var mapsArray = []
function initMarkers(theMap, markerData) {
	clearBoxes();
	deleteOverlays();
	for(var i=0; i < markerData.length; i++) {
          var image = new google.maps.MarkerImage(markerData[i].markImg, new google.maps.Size(32, 39),
	  new google.maps.Point(0,0),new google.maps.Point(0, 32));
          marker = new google.maps.Marker({
            map: theMap,
            draggable: true,
            icon: image,
            position: markerData[i].latLng,
            draggable: false
          })
          newMarkers.push({ marker: marker, id: markerData[i].id });
			
          var boxText =  '<div class="hMapO radius10">&nbsp;</div><div class="hMapC bigInfo"><div class="imgArrow">&nbsp;</div>'+
 												'<div class="full container_12">'+
												'<div class="grid_3 imgC radius5"><img src="'+markerData[i].imgSrc+'"></div>'+
												'<div class="grid_9">'+
                    		'<div class="grid_12 ttl">' + markerData[i].name + '</div>'+
                        '</div></div> <div>';
         var myOptions = {
      		content: boxText,
          disableAutoPan: false,
          maxWidth: 0,
					boxStyle: {width: "300px"},
					boxClass:'hoverMap radius10',
          pixelOffset: new google.maps.Size(50, -50),
          zIndex: null,
          closeBoxMargin: "5px 7px 0px 0px",
          closeBoxURL: "/images/map/no.png",
          infoBoxClearance: new google.maps.Size(1, 1),
          isHidden: false,
          pane: "floatPane",
          enableEventPropagation: false};
					
          newMarkers[i].marker.infobox = new InfoBox(myOptions);
		 
 	boxText2 =  '<div class="hMapO radius10">&nbsp;</div><div class="hMapC bigInfo"><div class="imgArrow">&nbsp;</div>'+
	'<div class="full container_12 infoContents" id="test">'+
												'<div class="grid_3 imgC radius5"><img src="'+markerData[i].imgSrc+'"></div>'+
												'<div class="grid_7">'+
                    		'<div class="grid_12 ttl">' + markerData[i].name + '</div></div></div>';
        var myLatLng = new google.maps.LatLng(3.13,101.62);
 		
        myOptions2 = {
          content: boxText2,
          disableAutoPan: false,
	  maxWidth: 0,
	  boxClass:'hoverMap autoHt mapCenter',
          pixelOffset: new google.maps.Size(48,-50),
	  position:myLatLng,
          zIndex: null,
	  boxStyle: {width: "480px"},
          closeBoxMargin: "5px 7px 0px 0px",
          closeBoxURL: "/images/map/cl.png",
          infoBoxClearance: new google.maps.Size(400, 200),
          isHidden: false,
          pane: "floatPane",
          enableEventPropagation: false};
		 newMarkers[i].marker.infoBigBox = new InfoBox(myOptions2);
		 google.maps.event.addListener(marker, 'click', (function(marker, i) {
		return function() {
		clearBoxes();
		newMarkers[i].marker.setZIndex(999);
		newMarkers[i].marker.infoBigBox.open(theMap, this);
		
							theMap.panTo(markerData[i].latLng);
							theMap.panBy(0,156);
							$.ajax({
								type: "GET",
								url: "/maps/get_information",
								data: "type="+ markerData[i].type+"&id=" +  markerData[i].id,
								complete: function(data){
									fromAjax =  '<div class="hMapO radius10">&nbsp;</div><div class="hMapC bigInfo"><div class="imgArrow">&nbsp;</div>'+
	'<div class="full container_12 infoContents" id="test">'+data.responseText+ '</div></div></div>';
										$('.bigInfo .infoContents').html(data.responseText);
										newMarkers[i].marker.infoBigBox.setContent(fromAjax);
								}
							});
					}
		 })(marker, i)		 
		 );
		 google.maps.event.addListener(marker, 'mouseout',  (function(marker, i) {
					return function() {
						clearMiniBoxes();
					}
			 })(marker, i));
		 google.maps.event.addListener(marker, 'mouseover', (function(marker, i) {
					return function() {
							if($('.infoContents').length == 0){
								newMarkers[i].marker.setZIndex(999);
								newMarkers[i].marker.infobox.open(theMap, this);
							}
					}
			 })(marker, i)); 
			 
			mapsArray.push({id: markerData[i].id, marker: marker});
			 
     }/* end for loop */
	return newMarkers
}
function clearBoxes(){
  if (newMarkers) {
    for (i in newMarkers) {
      newMarkers[i].marker.infobox.close();
      newMarkers[i].marker.infoBigBox.close();
    }
  }
}
function clearMiniBoxes(){
	if (newMarkers) {
    for (i in newMarkers) {
      newMarkers[i].marker.infobox.close();
    }
  }
}
// Deletes all markers in the array by removing references to them
function deleteOverlays() {
  if (newMarkers) {
    for (i in newMarkers) {
      newMarkers[i].marker.setMap(null);
    }
    newMarkers.length = 0;
  }
}

function update_counter_status(partial_total, listing_type){

  if (partial_total < 1){ return; }

  if (listing_type == "all")
    total_listings = $("#counter_all").text();
  else
    total_listings = $("#counter_" + listing_type + "s").text();
  sub_total = ((page-1) * more_load_number) +  partial_total;

  if (initial_load_number < parseInt(total_listings)){
    text = "1-" + sub_total  + " of " + total_listings;
    $("#counter_status").text(text);
  }else{
    $("#counter_status").text('');
  }
}

function load_listing(type, perpage, search){
  page = 1;
  listing_type = type;
	if(type=='all')
		$('#typeList').text('');
  else if(type=='place')
		$('#typeList').text('in Places');
  else if(type=='deal')
		$('#typeList').text('in Offers');
  else if(type=='event')
		$('#typeList').text('in Events');
  else
		$('#typeList').text('');
		
	$("#counter_status").text('');
  
	$(".place_row, .deal_row, .event_row").each(function(){
    $(this).remove();
  });
<<<<<<< HEAD
=======

            params = page_params;
>>>>>>> 552fb8504cfe6060065c49840d42a8cdf2182145
            $.ajax({
                        type: "GET",
                        url: "/maps/load_more",
                        async: false,
                        data: "type="+ type + "&per_page=" + perpage + "&search=" + search + params,
                        success: function(data){
													
                          json = JSON.parse(data)
                                var pane = $(".resultList");
                                var api = pane.data('jsp')
                                api.getContentPane().append(json.htmlstring);
markersArray = [];
        for( var i in json.listings){
          listing = json.listings[i]

          markersArray.push(
            {
              latLng: new google.maps.LatLng(listing.lat, listing.lng),
                                                  id: listing.listing.id,
                                                  name: listing.listing.name,
                                                  type: listing.listing.listing_type,
                                                  markImg:'/images/' +  listing.listing.listing_type + 's_32.png',
                                                  linkA: listing.endpage_url,
                                                  imgSrc: listing.image_icon
                                          });
        }
        markers = initMarkers(map, markersArray);
if (search == "") {
  switch(type){
  case "place":
    $("#counter_all_search").text(json.listings.length);
		break;
  case "deal":
    $("#counter_all_search").text(json.listings.length);
		break;
  case "event":
    $("#counter_all_search").text(json.listings.length);
		break;
  default:
    $("#counter_all_search").text(json.listings.length);
	}
}else{
  switch(type){
  case "place":
    $("#counter_all_search").text($("#counter_places").text());
		break;
  case "deal":
    $("#counter_all_search").text($("#counter_deals").text());
		break;
  case "event":
    $("#counter_all_search").text($("#counter_events").text());
		break;
  default:
    $("#counter_all_search").text($("#counter_all").text());
  }

}
                                if (json.listings.length < initial_load_number)
                                  $("#load_more").hide();
                                else
                                  $("#load_more").show();
                        }
    });

  };



$(function(){
  $("#load_more").click(function(){
		$.ajax({
			type: "GET",
			url: "/maps/load_more",
			async: false,
			data: "type="+ listing_type + "&page=" + page + "&search=" + search_str,
			success: function(data){
			  json = JSON.parse(data)
page = page + 1;
				
				var pane = $(".resultList");
				var api = pane.data('jsp')
				api.getContentPane().append(json.htmlstring);
				
        for( var i in json.listings){
          listing = json.listings[i]

          markersArray.push(
            { 
              latLng: new google.maps.LatLng(listing.lat, listing.lng), 
						  id: listing.listing.id, 
						  name: listing.listing.name,
						  type: listing.listing.listing_type,
						  markImg:'/images/' +  listing.listing.listing_type + 's_32.png', 
						  linkA: listing.endpage_url,
						  imgSrc: listing.image_icon
					  });
        }
        markers = initMarkers(map, markersArray);
        update_counter_status(json.counter_all, listing_type);
if (search_str == ""){
        $("#counter_all_search").text(json.counter_all + parseInt($("#counter_all_search").text()));
}
/*
 * $("#counter_all").text(json.counter_all + parseInt($("#counter_all").text()));
				$("#counter_places").text(json.counter_places + parseInt($("#counter_places").text()));
				$("#counter_events").text(json.counter_events + parseInt($("#counter_events").text()));
				$("#counter_deals").text(json.counter_deals + parseInt($("#counter_deals").text()));
*/
				if (json.listings.length < more_load_number)
				  $("#load_more").hide();
				else
				  $("#load_more").show();
			}
    });
    
  });
  

  $("#search").autocomplete("/search_autocomplete", {
    width: '100%',
    selectFirst: false,
    resultsClass:'s_result map grid_12'
  });


})
