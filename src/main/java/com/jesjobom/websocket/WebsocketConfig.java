package com.jesjobom.websocket;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.AbstractWebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;

/**
 * Spring Servlet and Websocket components Configuration.
 * 
 * @author jesjobom
 * @see https://docs.spring.io/spring/docs/current/spring-framework-reference/html/websocket.html#websocket-stomp-enable
 */
@Configuration
@EnableWebSocketMessageBroker
@ComponentScan("com.jesjobom")
public class WebsocketConfig extends AbstractWebSocketMessageBrokerConfigurer {

	@Override
	public void registerStompEndpoints(StompEndpointRegistry ser) {
		ser.addEndpoint("/chat").withSockJS();
	}

	@Override
	public void configureMessageBroker(MessageBrokerRegistry config) {
		config.setApplicationDestinationPrefixes("/client");
		config.enableSimpleBroker("/subscribe");
	}
}
