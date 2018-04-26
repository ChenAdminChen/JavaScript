var topicName = "topicMessage";

//连接服务器并注册连接成功处理事件 
function connect() {

	client = new Paho.MQTT.Client("127.0.0.1", 61614, "client_11111");

	client.startTrace();

	client.onConnectionLost = onConnectionLost;
	
	client.onMessageArrived = onMessageArrived;

	client.connect({
		userName: 'admin',
		password: 'admin',
		onSuccess: onConnect,
		onFailure: onFail
	});

	function reconnect() {
		//定时器
		window.setTimeout(function() {
			console.log("3s后重连.");
			connect();
		}, 10000);
	}
	
	function onConnect() {
		// Once a connection has been made, make a subscription and send a message.
		console.log("onConnect");
		client.subscribe(topicName);  //订阅topicName
		
	}
	
	function onFail(errorCode) {
		// Once a connection has been made, make a subscription and send a message.
		console.log("onFail: " + errorCode);
		log = client.getTraceLog();
		console.log(log);


		reconnect();
	}

	// called when the client loses its connection
	//注册连接断开处理事件  
	function onConnectionLost(responseObject) {
			
		if(responseObject.errorCode == 0) {
			$(".connect").not(".connect:contains(未连接)").toggle();
		} else {
			console.log("onConnectionLost:" + responseObject.errorMessage);
			
			$(".connect").not(".connect:contains(连接失败)").toggle();
			reconnect();
		}
	}

	// called when a message arrives  message.payloadString 接收数据 字符串
	//注册消息接收处理事件
	function onMessageArrived(message) {
		var obj = JSON.parse(message.payloadString);
		
		/*console.log("message:" + message.payloadString );*/
		console.log(obj);
		$("#p_text").html(obj.deviceId);
	}
}


window.connect();
