package com.jesjobom.websocket;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

/**
 *
 * @author jairton
 */
@Controller
public class WebsocketController {
	
	@MessageMapping("/hello")
	@SendTo("/subscribe/hello")
	public String hello(@Payload String hello) {
		System.out.println(hello);
		return "Hi!";
	}
}
