package de.koanam.foodwithfriends.trigger.model.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class EventWrapper {

	private String id;
	@JsonProperty("created_at")
	private String created;
	private Trigger trigger;
	private Table table;
	private Event event;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getCreated() {
		return created;
	}

	public void setCreated(String created) {
		this.created = created;
	}

	public Trigger getTrigger() {
		return trigger;
	}

	public void setTrigger(Trigger trigger) {
		this.trigger = trigger;
	}

	public Table getTable() {
		return table;
	}

	public void setTable(Table table) {
		this.table = table;
	}

	public Event getEvent() {
		return event;
	}

	public void setEvent(Event event) {
		this.event = event;
	}

}
