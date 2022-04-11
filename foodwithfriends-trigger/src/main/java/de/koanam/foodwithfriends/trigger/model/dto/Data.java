package de.koanam.foodwithfriends.trigger.model.dto;

import java.util.Map;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Data {

	@JsonProperty("old")
	private Map<String, String> oldElement;
	
	@JsonProperty("new")
	private Map<String, String> newElement;

	public Map<String, String> getOldElement() {
		return oldElement;
	}

	public void setOldElement(Map<String, String> oldElement) {
		this.oldElement = oldElement;
	}

	public Map<String, String> getNewElement() {
		return newElement;
	}

	public void setNewElement(Map<String, String> newElement) {
		this.newElement = newElement;
	}
	
	
	
}
