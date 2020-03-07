package de.koanam.foodwithfriends.matching.model;

import java.util.List;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;

@Entity
public class Date {

	@Id
	@GeneratedValue
	private Long id;
	
	@ManyToMany
	@JoinTable(name ="user_date", inverseJoinColumns = @JoinColumn(name = "user_id", table="user"))
	private List<User> users;

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
	
	
	
}
