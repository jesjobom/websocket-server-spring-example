# Example of a Websocket Server using Spring's Websocket API + SocksJS + Stomp
This is a websocket server using Spring's API with a JSP for testing.
The main idea here is to explore some of the Stomp's capabilities by defining "channels" for different users or uses over the same connection.
So, I ended up with a chat like application where multiple browser instances can act like different users.
Later, I'll publish a websocket client also using Spring's API.

## Testable Features
- Connect via websocket (SockJS fallback available)
    * end point at http://localhost:8080/websocket-server-spring-example/chat
    
- Broadcast message to a common channel
   * subscribe to `/subscribe/channel/general`
   * send messages to `/client/channel/general`
    
- Create a new channel broadcasting it's creation
   * ask for a new channel at `/client/channel/create`
   * receive a new channel through `/subscribe/channels`
    
- Subscribe or unsubscribe a channel
   * subscribe or unsubscribe to `/subscribe/channel/<channel>`
   * send messages to `/client/channel/<channel>`
    
- Send private messages direct to a user using a session ID
   * subscribe to `/user/subscribe/private`
   * send private message by adding `@<session_id>` at the beginnig of the message *

\* for now the `session id` of each "user" is shown as a user name near messages received

TODO: config a custom handshake handler to change the acquisition of the Principal from session.
Doing that, we can drop the use of users' session id as their identification.
Maybe add a field to informa a unique login before connecting?
See that I don't want to add Spring Security to this example.

TODO: config a custom channel interceptor to block multiple subscriptions to the same private channel.
Otherwise it is possible to force a subscription and receive private messages to a user.
When a user subscribes to "/user/subscribe/private", internally it is translated to "/subscribe/private-user<session-id>".

TODO: Using the above custom channel interceptor, detect new connected user and show to everyone "new user connected (<user_name>)".