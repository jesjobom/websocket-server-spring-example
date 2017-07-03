package com.jesjobom.websocket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

/**
 * Main controller to handle data sent by clients.
 * Data can be sent back using @SendTo, but it is just an option.
 *
 * @author jesjobom
 */
@Controller
public class WebsocketController {
	
	@Autowired
	private SimpMessagingTemplate messagingTemplate;
	
	/**
	 * Simple method to check the websocket connection.
	 * 
	 * @param hello
	 * @return 
	 */
	@MessageMapping("/hello")
	@SendTo("/subscribe/hello")
	public String hello(@Payload String hello) {
		return "Hi!";
	}
	
	@MessageMapping("/channel/create")
	@SendTo("/subscribe/channels")
	public String createChannel() {
		Long time = System.currentTimeMillis();
		return time.toString();
	}
	
	@MessageMapping("/channel/{channel}")
	public void handleChannelMessages(@DestinationVariable String channel, @Payload String message) {
		messagingTemplate.convertAndSend("/subscribe/channel/" + channel, message);
	}
}
