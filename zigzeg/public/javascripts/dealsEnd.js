function setTimer(dateVal){
	var nowTime = new Date();
	var targetTime = new Date("January 13, 2012 11:13:00")// date change 11/22/2011
	var timeDiff = targetTime.valueOf()-nowTime.valueOf();
		diffSecs = Math.floor(timeDiff/1000);
		secs = diffSecs % 60;
		mins = Math.floor(diffSecs/60)%60;
		hours = Math.floor(diffSecs/60/60)%24;
		days = Math.floor(diffSecs/60/60/24);
		timeCount = zeroPad(days)+":"+zeroPad(hours)+":"+zeroPad(mins)+":"+zeroPad(secs);
		$(function(){
			$('#counter').countdown({
				image: '/images/digits.png',
				startTime:timeCount,
			});
		});
}
	function zeroPad(num){
		var numZeropad = num + '';
		while(numZeropad.length < 2) {
		numZeropad = "0" + numZeropad;
		}
		return numZeropad;
	}
		
