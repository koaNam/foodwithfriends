package de.koanam.foodwithfriends.trigger.model.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

@Entity
public class Voter {

	@Id
	private Long id;
	
	@ManyToOne
	private Vote vote;
	
	@Column(name="vote")
	private String voteResult;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Vote getVote() {
		return vote;
	}

	public void setVote(Vote vote) {
		this.vote = vote;
	}

	public String getVoteResult() {
		return voteResult;
	}

	public void setVoteResult(String voteResult) {
		this.voteResult = voteResult;
	}

	
	
}
