package de.koanam.foodwithfriends.trigger.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import de.koanam.foodwithfriends.trigger.model.crud.DateRepository;
import de.koanam.foodwithfriends.trigger.model.crud.DateVoteRepository;
import de.koanam.foodwithfriends.trigger.model.crud.VoteRepository;
import de.koanam.foodwithfriends.trigger.model.entity.Date;
import de.koanam.foodwithfriends.trigger.model.entity.DateVote;
import de.koanam.foodwithfriends.trigger.model.entity.Vote;
import de.koanam.foodwithfriends.trigger.model.entity.Voter;

@Service
public class VoteService {

	private static final Logger LOG = LoggerFactory.getLogger(VoteService.class);

	@Autowired
	private DateRepository dateRepository;
	
	@Autowired
	private VoteRepository voteRepository;
	
	@Autowired
	private DateVoteRepository dateVoteRepository;
	
	public void adjustVoteResult(Long voteId) {
		LOG.info("starting to adjust result of vote");
		
		Vote vote=voteRepository.findById(voteId).get();
		Date date= vote.getDate();
		int userCount = date.getUsers().size();

		List<Voter> voters=vote.getVoters();
		int voterCount=voters.size();
		if(userCount == voterCount) {
			LOG.info("evaluating vote");
			int agreeCount=0;
			for(Voter voter: voters) {
				if(voter.getVoteResult().equals("yes")) {
					agreeCount++;
				}
			}
			String result=null;
			if(agreeCount == voterCount) {	//alle angenommen
				result="accepted";
				if(vote.getVoteKind().equals("DATE")) {
					LOG.info("accepted vote is a DateVote, so we update the datetime of the date");
					DateVote dateVote = this.dateVoteRepository.findById(vote.getId()).get();
					date.setDatetime(dateVote.getDatetime());
					this.dateRepository.save(date);
				}
			}else if(agreeCount <= 1) { // alle, bis auf einen(evtl. der Ersteller) abgelehnt
				result="declined";
			}else {
				result="pending";
			}
			
			LOG.info("setting result to {}", result);
			vote.setResult(result);
			this.voteRepository.save(vote);
		}
	}
	
}
