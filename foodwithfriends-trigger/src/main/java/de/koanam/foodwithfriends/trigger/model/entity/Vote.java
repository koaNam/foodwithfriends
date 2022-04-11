package de.koanam.foodwithfriends.trigger.model.entity;

import java.util.List;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;

@Entity
public class Vote {

	@Id
	private Long id;
	private String result;
	private String voteKind;
	
	@OneToMany(mappedBy = "vote")
	private List<Voter> voters;
	
	@ManyToOne
	private Date date;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public String getVoteKind() {
		return voteKind;
	}

	public void setVoteKind(String voteKind) {
		this.voteKind = voteKind;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public List<Voter> getVoters() {
		return voters;
	}

	public void setVoters(List<Voter> voters) {
		this.voters = voters;
	}
	
	
}
