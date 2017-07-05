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
