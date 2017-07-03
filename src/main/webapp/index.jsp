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
		<div id="output">
			<p>Output:</p>
			<textarea id="mainOutput" readonly="readonly" rows="8" cols="30"></textarea>
		</div>
	</body>

	<script type="text/javascript">
		var stompClient = null;
		var host = "<%= pageContext.getServletContext().getContextPath()%>";

		function connectWebsocket() {
			var socket = new SockJS(host + '/chat');
			stompClient = Stomp.over(socket);

			stompClient.connect({}, function (frame) {
				console.log('Connected: ' + frame);

				stompClient.subscribe('/subscribe/hello', function (data) {
					showLog(data.body);
				});

				$("#btnConnect").attr("disabled", "disabled");
				$("#btnDisconnect").removeAttr("disabled");
				$("#btnSendHello").removeAttr("disabled");
			});
		}

		function disconnectWebsocket() {
			if (stompClient !== null) {
				stompClient.disconnect();
			}
			$("#btnConnect").removeAttr("disabled");
			$("#btnDisconnect").attr("disabled", "disabled");
			$("#btnSendHello").attr("disabled", "disabled");
			console.log("Disconnected");
		}

		function sendHello() {
			showLog("Hello!", true);
			stompClient.send("/client/hello", {}, JSON.stringify("Hello!"));
		}
		
		function showLog(msg, isInput) {
			var log = isInput ? "<< " : ">> ";
			log += msg;
			log += "\n";
			$("#mainOutput").append(log);
		}
	</script>
</html>
