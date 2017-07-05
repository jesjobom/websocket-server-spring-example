# Example of a Websocket Server using Spring's Websocket API + SocksJS + Stomp
This is a websocket server using Spring's API with a JSP for testing.
The main idea here is to explore some of the Stomp's capabilities by defining "channels" for different users or uses over the same connection.
So, I ended up with a chat like application where multiple browser instances can act like different users.
Later, I'll publish a websocket client also using Spring's API.

## Testable Features
- Connect via websocket (SockJS fallback available)
- Broadcast message to a common channel
- Create a new channel broadcasting it's creation
- Subscribe or unsubscribe a channel
- Send private messages direct to a user using a session ID
