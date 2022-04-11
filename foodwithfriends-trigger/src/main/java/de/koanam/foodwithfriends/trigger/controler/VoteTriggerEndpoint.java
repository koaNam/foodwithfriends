package de.koanam.foodwithfriends.trigger.controler;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import de.koanam.foodwithfriends.trigger.model.dto.EventWrapper;
import de.koanam.foodwithfriends.trigger.service.VoteService;

@RestController
public class VoteTriggerEndpoint {

	private static final Logger LOG = LoggerFactory.getLogger(VoteTriggerEndpoint.class);

	
	@Autowired
	private VoteService voteService;
	
	@PostMapping("/voter")
	public void onInsertVoter(@RequestBody EventWrapper eventWrapper) {
		LOG.info("new event");
		
		Map<String, String> newVoter = eventWrapper.getEvent().getData().getNewElement();
		if(newVoter != null && eventWrapper.getTable().getName().equals("voter") && newVoter.containsKey("vote_id")) {
			Long voteId = Long.valueOf(newVoter.get("vote_id"));
			this.voteService.adjustVoteResult(voteId);
		}
	}
	
}
