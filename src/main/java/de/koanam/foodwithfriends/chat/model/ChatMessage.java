package de.koanam.foodwithfriends.chat.model;

public class ChatMessage {

	private Integer user;
	private String message;

	public ChatMessage() {
	}

	public ChatMessage(Integer user, String message) {
		this.user = user;
		this.message = message;
	}

	public Integer getUser() {
		return user;
	}

	public void setUser(Integer user) {
		this.user = user;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

}
