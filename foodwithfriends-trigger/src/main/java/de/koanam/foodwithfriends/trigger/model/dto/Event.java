package de.koanam.foodwithfriends.trigger.model.dto;

import java.util.Map;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Event {

	@JsonProperty("session_variables")
	private Map<String, String> sessionVariables;

	@JsonProperty("op")
	private String operation;

	private Data data;

	public Map<String, String> getSessionVariables() {
		return sessionVariables;
	}

	public void setSessionVariables(Map<String, String> sessionVariables) {
		this.sessionVariables = sessionVariables;
	}

	public String getOperation() {
		return operation;
	}

	public void setOperation(String operation) {
		this.operation = operation;
	}

	public Data getData() {
		return data;
	}

	public void setData(Data data) {
		this.data = data;
	}

}
