package de.koanam.foodwithfriends.matching.model;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;

@Entity
public class DateMatch {

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE)
	private Long id;
	
	@OneToMany(mappedBy ="dateMatch", fetch=FetchType.EAGER, cascade= CascadeType.ALL)
	List<UserDateMatch> userDateMatches;
	
	public DateMatch(List<UserDateMatch> userDateMatches) {
		this.userDateMatches = userDateMatches;
	}
	
	public DateMatch() {
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public List<UserDateMatch> getUserDateMatches() {
		return userDateMatches;
	}

	public void setUserDateMatches(List<UserDateMatch> userDateMatches) {
		this.userDateMatches = userDateMatches;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((userDateMatches == null) ? 0 : userDateMatches.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		DateMatch other = (DateMatch) obj;
		if (userDateMatches == null) {
			if (other.userDateMatches != null)
				return false;
		} else if (!userDateMatches.equals(other.userDateMatches))
			return false;
		return true;
	}


	


	
	
}
