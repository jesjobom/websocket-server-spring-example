package com.jesjobom.websocket;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessageType;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

/**
 * Main controller to handle data sent by clients. 
 * 
 * Data can be sent back using @SendTo, but it is just an option.
 *
 * @author jesjobom
 */
@Controller
public class WebsocketController {

	@Autowired
	private SimpMessagingTemplate messagingTemplate;

	private final ObjectMapper jsonMapper = new ObjectMapper();

	private final Pattern privateMessagePattern = Pattern.compile("^@([\\S]+)[\\s]+(.*)");

	/**
	 * Simple method to check the websocket connection.
	 *
	 * @param hello
	 * @param headerAccessor
	 * @return
	 * @throws com.fasterxml.jackson.core.JsonProcessingException
	 */
	@MessageMapping("/hello")
	@SendTo("/subscribe/hello")
	public String hello(@Payload String hello, SimpMessageHeaderAccessor headerAccessor) throws JsonProcessingException {
		return jsonMapper.writeValueAsString("Hi, " + headerAccessor.getSessionId() + "!");
	}

	/**
	 * After a request to create a channel, this new channel is broadcasted.
	 *
	 * @return
	 * @throws com.fasterxml.jackson.core.JsonProcessingException
	 */
	@MessageMapping("/channel/create")
	@SendTo("/subscribe/channels")
	public String createChannel() throws JsonProcessingException {
		Long time = System.currentTimeMillis();
		return jsonMapper.writeValueAsString(Long.toHexString(time));
	}

	/**
	 * Receives a message through a channel and broadcasts this given
	 * message to this channel. 
	 * 
	 * A channel can be subscribed by multiple clients.
	 * A message formatted like "@sessionId message" will be sent to the user 
	 * with session id "sessionId".
	 *
	 * @param channel
	 * @param message
	 * @param headerAccessor
	 * @throws com.fasterxml.jackson.core.JsonProcessingException
	 */
	@MessageMapping("/channel/{channel}")
	public void handleChannelMessages(@DestinationVariable String channel, @Payload String message, SimpMessageHeaderAccessor headerAccessor) throws JsonProcessingException, IOException {
		String msg = jsonMapper.readValue(message, String.class);

		Matcher matcher = privateMessagePattern.matcher(msg);
		if (matcher.matches()) {
			sendMessageToUser(matcher.group(1), matcher.group(2));
		} else {
			sendMessageToChannel(channel, headerAccessor.getSessionId(), msg);
		}
	}

	/**
	 * Broadcast to everyone subscribed to the given channel.
	 * 
	 * @param channel
	 * @param sessionId
	 * @param message
	 * @throws JsonProcessingException 
	 */
	private void sendMessageToChannel(String channel, String sessionId, String message) throws JsonProcessingException {
		messagingTemplate.convertAndSend("/subscribe/channel/" + channel, jsonMapper.writeValueAsString(sessionId + ": " + message));
	}

	/**
	 * Send a message to a specific user subscribed to '/user/subscribe/private'.
	 * 
	 * Since there's no authentication and no Principal in the session, I can't
	 * simply use the user's name (or login) to send him a message.
	 * 
	 * Internally <code>org.springframework.web.socket.messaging.DefaultSimpUserRegistry</code>
	 * will try to store a user's session using the user's name as a key.
	 * 
	 * Since it's not the case, I'll force the user's session id in the header 
	 * of the message and as the user's name so I can change the 
	 * <code>org.springframework.messaging.simp.user.DefaultUserDestinationResolver#parseMessage</code>
	 * behaviour.
	 * 
	 * @param destinationSessionId
	 * @param message
	 * @throws JsonProcessingException 
	 */
	private void sendMessageToUser(String destinationSessionId, String message) throws JsonProcessingException {
		SimpMessageHeaderAccessor headerAccessor = SimpMessageHeaderAccessor.create(SimpMessageType.MESSAGE);
		headerAccessor.setSessionId(destinationSessionId);
		headerAccessor.setLeaveMutable(true);
		messagingTemplate.convertAndSendToUser(destinationSessionId, "/subscribe/private", jsonMapper.writeValueAsString(destinationSessionId + ": " + message), headerAccessor.getMessageHeaders());
	}
}
