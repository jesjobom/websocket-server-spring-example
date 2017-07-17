<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
	"http://www.w3.org/TR/html4/loose.dtd">

<html>
	<head>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.1.4/sockjs.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Example of a websocket server using Spring + SockJS + Stomp</title>
	</head>
	<body>
		<h1>Example of a websocket server using Spring + SockJS + Stomp</h1>
		<div id="controls">
			<input type="button" id="btnConnect" value="Connect" onclick="javascript: connectWebsocket();"/>
			<input type="button" id="btnDisconnect" value="Disconnect" disabled="disabled" onclick="javascript: disconnectWebsocket();"/>
			<input type="button" id="btnSendHello" value="Send Hello" disabled="disabled" onclick="javascript: sendHello();"/>
		</div>
		<div id="channel-controls" style="display: none;">
			<hr/>
			<div>
				<select id="channels" onchange="javascript: changeChannel();">
					<option value="">Select a channel or create a new one</option>
				</select>
			</div>
			<div>
				<input type="button" id="btnChCreate" value="Create" onclick="javascript: createChannel();"/>
				<input type="button" id="btnChSubscribe" value="Subscribe" disabled="disabled" onclick="javascript: subscribe();" disabled="disabled"/>
				<input type="button" id="btnChUnsubscribe" value="Unsubscribe" disabled="disabled" onclick="javascript: unsubscribe();" disabled="disabled"/>
			</div>
		</div>
		<div id="input" style="display: none;">
			<hr/>
			<label for="mainInput">Input:</label>
			<input type="text" id="textInput" />
			<input type="button" id="btnInputSend" value="Send" onclick="javascript: sendText(); " />
		</div>
		<div id="output">
			<p>Output:</p>
			<textarea id="mainOutput" readonly="readonly" rows="8" cols="60"></textarea>
		</div>
	</body>

	<script type="text/javascript">
		var stompClient = null;
		var host = "<%= pageContext.getServletContext().getContextPath()%>";
		var subscribes = [];

		function connectWebsocket() {
			var socket = new SockJS(host + '/chat');
			stompClient = Stomp.over(socket);

			stompClient.connect({}, function (frame) {
				console.log('Connected: ' + frame);

				stompClient.subscribe('/subscribe/hello', function (data) {
					showLog(JSON.parse(data.body));
				});
				
				stompClient.subscribe('/subscribe/channel/general', function (data) {
					showLog(JSON.parse(data.body));
				});
				
				stompClient.subscribe('/subscribe/channels', function (data) {
					receiveChannel(JSON.parse(data.body));
				});
				
				stompClient.subscribe('/user/subscribe/private', function (data) {
					showLog(JSON.parse(data.body), false, "PRIVATE");
				});

				$("#btnConnect").attr("disabled", "disabled");
				$("#btnDisconnect").removeAttr("disabled");
				$("#btnSendHello").removeAttr("disabled");
				$("#channel-controls").show();
				$("#input").show();
			});
		}

		function disconnectWebsocket() {
			if (stompClient !== null) {
				stompClient.disconnect();
			}
			$("#btnConnect").removeAttr("disabled");
			$("#btnDisconnect").attr("disabled", "disabled");
			$("#btnSendHello").attr("disabled", "disabled");
			$("#channel-controls").hide();
			$("#input").hide();
			console.log("Disconnected");
		}

		function sendHello() {
			showLog("Hello!", true);
			stompClient.send("/client/hello", {}, JSON.stringify("Hello!"));
		}
		
		function showLog(msg, isInput, channel) {
			var log = isInput ? "SEND " : "RECV ";
			log += "[";
			log += channel ? channel : "GENERAL";
			log += "] ";
			log += msg;
			log += "\n";
			$("#mainOutput").append(log);
			$("#mainOutput").scrollTop( $("#mainOutput")[0].scrollHeight );
		}
		
		function showError(msg) {
			var err = "ERROR ";
			err += msg;
			err += "\n";
			$("#mainOutput").append(err);
			$("#mainOutput").scrollTop( $("#mainOutput")[0].scrollHeight );
		}
		
		function cleanChannels() {
			$("#channels option").filter(function(){ return this.value ? true : false; }).remove();
		}
		
		function createChannel() {
			stompClient.send("/client/channel/create");
		}
		
		function receiveChannel(channel) {
			showLog("Channel " + channel + " created");
			$("#channels").append($("<option>").attr("value", channel).text("Channel " + channel));
		}
		
		function changeChannel() {
			var channel = $("#channels").val();
			
			if(channel && subscribes[channel]) {
				$("#btnChUnsubscribe").removeAttr("disabled");
				$("#btnChSubscribe").attr("disabled", "disabled");
				
			} else if(channel && !subscribes[channel]) {
				$("#btnChSubscribe").removeAttr("disabled");
				$("#btnChUnsubscribe").attr("disabled", "disabled");
				
			} else {
				$("#btnChSubscribe").removeAttr("disabled");
				$("#btnChUnsubscribe").removeAttr("disabled");
			}
		}
		
		function subscribe() {
			var channel = $("#channels").val();
			
			var subscribe = stompClient.subscribe('/subscribe/channel/' + channel, function (data) {
				showLog(JSON.parse(data.body), false, channel);
			});
			
			subscribes[channel] = subscribe;
			changeChannel();
		}
		
		function unsubscribe() {
			var channel = $("#channels").val();
			
			subscribes[channel].unsubscribe();
			subscribes = subscribes.splice(subscribes.indexOf(channel), 1);
			changeChannel();
		}
		
		function sendText() {
			var text = $("#textInput").val();
			var channel = $("#channels").val();
			
			if(text.length) {
				showLog(text, true, channel);
				stompClient.send("/client/channel/" + (channel.length ? channel : "general"), {}, JSON.stringify(text));
				
			} else {
				showError("Empty input!")
			}
		}
	</script>
</html>
