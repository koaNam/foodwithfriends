package de.koanam.foodwithfriends.chat.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.stereotype.Controller;

import de.koanam.foodwithfriends.chat.model.ChatMessage;

@Controller
public class ChatController {

	@Autowired
	private SimpMessageSendingOperations messagingTemplate;

	@MessageMapping("/room/{roomId}/message.send")
    public void sendMessage(@DestinationVariable String roomId, @Payload String chatMessage) {
		System.out.println(roomId);
		System.out.println(chatMessage);
		
        this.messagingTemplate.convertAndSend("/room/"+roomId, chatMessage);
    }
}
