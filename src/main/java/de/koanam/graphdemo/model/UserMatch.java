package de.koanam.graphdemo.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToOne;

@Entity
public class UserMatch {

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE)
	private Long id;
	
	@OneToOne
	private User user;
	
	@OneToOne
	private User match;

	public UserMatch() {
		super();
	}

	public UserMatch(User user, User match) {
		super();
		this.user = user;
		this.match = match;
	}
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public User getMatch() {
		return this.match;
	}

	public void setMatch(User match) {
		this.match = match;
	}
	

	
	

		
}
