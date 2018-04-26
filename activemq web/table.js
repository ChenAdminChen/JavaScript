//topic名字
var topicName = "dev/data/#";

	//连接
	function connect() {
		
		var now=new Date(); 
		var numbers = now.getMilliseconds();
		console.log("alarm numbers:"+numbers);
		// Create a client instance  连接对象
		clients = new Paho.MQTT.Client("www.yifenganxin.com", 61613, "paho-js-"+numbers);
		//var rand = Math.Random();
		// set callback handlers
		clients.startTrace();
		clients.onConnectionLost = onConnectionLosts;
		clients.onMessageArrived = onMessageArriveds;
		
		
		client.connect({ userName: 'hnyfadmin', password: 'hnyfadmin', onSuccess: onConnect, onFailure: onFail });
		
//		$(".connect-state > .connecting").toggle(true);
//		$(".connect-state > .connected").toggle(false);
//		$(".connect-state > .disconnected").toggle(false);
//		$(".connect-state > .connect-lost").toggle(false);

		$(".connect").not(".connect:visible").toggle();
		$(".connect").not(".connect:contains(正在连接)").toggle();
	}
	
	function reconnect() {
		//定时器
		window.setTimeout(function() {
			console.log("3s后重连.");
//			$(".connect-state").remove(".fail");
			connect();
		}, 10000);
	}
	
	// called when the client connects
	function onConnect() {
		// Once a connection has been made, make a subscription and send a message.
		console.log("onConnect");
		client.subscribe(topicName);  //订阅topicName
		
//		$(".connect-state > .connecting").toggle(false);
//		$(".connect-state > .connected").toggle(true);
//		$(".connect-state > .disconnected").toggle(false);
//		$(".connect-state > .connect-lost").toggle(false);
		
		$(".connect").not(".connect:visible").toggle();
		$(".connect").not(".connect:contains(已连接)").toggle();
	}

	// called when the client connects
	function onFail(errorCode) {
		// Once a connection has been made, make a subscription and send a message.
		console.log("onFail: " + errorCode);
		log = client.getTraceLog();
		console.log(log);

//		$(".connect-state > .connecting").toggle(false);
//		$(".connect-state > .connected").toggle(false);
//		$(".connect-state > .disconnected").toggle(false);
//		$(".connect-state > .connect-lost").toggle(true);
		
		$(".connect").not(".connect:visible").toggle();
		$(".connect").not(".connect:contains(连接失败)").toggle();

		reconnect();
	}

	// called when the client loses its connection
	function onConnectionLost(responseObject) {
//		$(".connect-state > .connecting").toggle(false);
//		$(".connect-state > .connected").toggle(false);
//		$(".connect-state > .disconnected").toggle(false);
//		$(".connect-state > .connect-lost").toggle(false);

		$(".connect").not(".connect:visible").toggle();
			
		if(responseObject.errorCode == 0) {
			$(".connect").not(".connect:contains(未连接)").toggle();
		} else {
			console.log("onConnectionLost:" + responseObject.errorMessage);
			
			$(".connect").not(".connect:contains(连接失败)").toggle();
			reconnect();
		}
	}

	// called when a message arrives  接数据 json
	function onMessageArrived(message) {
		var obj = JSON.parse(message.payloadString);
		var groupId = obj.advantechDevice.groupId;
		var did = obj.advantechDevice.did;
		for(var name in obj.indexData) {
			$("#" + groupId + "_" + did + "_" + name).html(obj.indexData[name]);
			console.log(groupId + ";" + did + ";" + name);
		}

	}
	
	function hideDiv() {
		$("#newIndex_form").css("display", "none");
		$("#back").css("display", "none");
	}

$(function() {
	var now = new Date();
	var number = now.getMilliseconds();
	// Create a client instance
	client = new Paho.MQTT.Client("www.yifenganxin.com", 61613, "paho-js-" + number);
	//var rand = Math.Random();
	// set callback handlers
	client.startTrace();
	client.onConnectionLost = onConnectionLost;
	client.onMessageArrived = onMessageArrived;

	// connect the client
	connect();
	
	
	
	// ui events
	//
/*	$("#pause-toggle").click(function() {
		var innerText = $("#pause").html();
		if(innerText == "pause") {
			$("#pause").html("play_arrow");
			client.disconnect();
			console.log("colse connection");
			$(".connect").not(".connect:visible").toggle();
			$(".connect").not(".connect:contains(未连接)").toggle();			
		} else {
			$("#pause").html("pause");
			connect();
			console.log("connection success");
		}
	});

	$(".hideIndexName").click(function() {
		$(".title").toggle();
	});
	
	$(".hideUnit").click(function() {
		$(".unit").toggle();
	});


	// ===============================================
	var key = "";
	function checkChange() {
		var newkey = $("#fixed-header-drawer-exp").val();
		
		if (newkey == key)
			return;
		
		key = newkey;
		$("#fixed-header-drawer-exp").change();
	}
	
	$("#fixed-header-drawer-exp").keypress(checkChange);
	$("#fixed-header-drawer-exp").keyup(checkChange);
		
	$("#fixed-header-drawer-exp").change(function() {
		var exp = $("#fixed-header-drawer-exp").val();
		
		if(exp == ""){
			$(".data-point").show();
			$(".single-device").show();
		} else {
			$(".data-point").hide();
			$(".single-device").hide();

//			$(".indexName:contains(" + key + ")").parent(".data-point").toggle();
		    $(".indexName:contains(" + key + ")").parents(".data-point, .single-device").toggle();
		}
	});*/
});
