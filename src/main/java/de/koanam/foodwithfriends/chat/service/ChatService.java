package de.koanam.foodwithfriends.chat.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class ChatService {

	private static final Logger LOG = LoggerFactory.getLogger(ChatService.class);
	
	private Map<String, List<String>> messageRooms;
	
	public ChatService() {
		this.messageRooms = new TreeMap<>();
	}
	
	public String addMessage(String roomId, String message) {
		if(!this.messageRooms.containsKey(roomId)) {
			LOG.info("creating new chatroom, previous there were {} rooms ");
			List<String> messages=new ArrayList<>();
			messages.add(message);
			this.messageRooms.put(roomId, messages);
		}else {
			this.messageRooms.get(roomId).add(message);
		}
		
		return message;
	}
	
	public List<String> getOldMessages(String roomId){
		LOG.info("getting all old messages");
		List<String> messages=this.messageRooms.getOrDefault(roomId, new ArrayList<>());
		LOG.info("found {} old messages", messages.size());
		return messages;
	}
	
	
}
