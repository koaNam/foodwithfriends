package de.koanam.foodwithfriends.trigger.model.entity;

import java.time.LocalDateTime;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;

@Entity
public class Date {

	@Id
	private Long id;
	
	private LocalDateTime datetime;
	
	@ManyToMany
	@JoinTable(name ="user_date", inverseJoinColumns = @JoinColumn(name = "user_id", table="user"))
	private List<User> users;
	
	@OneToMany
	private List<Vote> votes;

	public Date() {
	}

	public Date(List<User> users) {
		this.users = users;
	}

	public List<User> getUsers() {
		return users;
	}

	public void setUsers(List<User> users) {
		this.users = users;
	}

	public LocalDateTime getDatetime() {
		return datetime;
	}

	public void setDatetime(LocalDateTime datetime) {
		this.datetime = datetime;
	}
	
		
}
