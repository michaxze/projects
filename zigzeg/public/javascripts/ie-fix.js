 function activatePlaceholders() {
					var detect = navigator.userAgent.toLowerCase(); 
					if (detect.indexOf("safari") > 0) return false;
					var inputs = document.getElementsByTagName("input");
					for (var i=0;i<inputs.length;i++) {
						if(inputs[i].value == ''){
						 if (inputs[i].getAttribute("type") == "text" || inputs[i].getAttribute("type") == "text") {
						 if (inputs[i].getAttribute("placeholder") && inputs[i].getAttribute("placeholder").length > 0) {
							inputs[i].value = inputs[i].getAttribute("placeholder");
							inputs[i].select();
							inputs[i].onclick = function() {
							 if (this.value == this.getAttribute("placeholder")) {
								this.value = "";
							 }
							 return false;
							}
							inputs[i].onblur = function() {
							 if (this.value.length < 1) {
								this.value = this.getAttribute("placeholder");
							 }
							}
						 }
						}
					 }
					}
				}
		window.onload=function() {
			activatePlaceholders();
		}
