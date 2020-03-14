package de.koanam.foodwithfriends.chat.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.stereotype.Controller;
import de.koanam.foodwithfriends.chat.service.ChatService;

@Controller
public class ChatController{

	@Autowired
	private SimpMessageSendingOperations messagingTemplate;
	
	@Autowired
	private ChatService chatService;

	@MessageMapping("/room/{roomId}/message.send")
    public void sendMessage(@DestinationVariable String roomId, @Payload String chatMessage) {
		String message=this.chatService.addMessage(roomId, chatMessage);
		
        this.messagingTemplate.convertAndSend("/room/"+roomId, message);
    }
	
	@MessageMapping("/user/{userId}/{roomId}/getAll")
    public void getAllMessages(@DestinationVariable String userId, @DestinationVariable String roomId,  @Payload String chatMessage) {
		List<String> messages = this.chatService.getOldMessages(roomId);
		
		this.messagingTemplate.convertAndSend("/user/"+userId+"/**", messages.toString());
    }

}
