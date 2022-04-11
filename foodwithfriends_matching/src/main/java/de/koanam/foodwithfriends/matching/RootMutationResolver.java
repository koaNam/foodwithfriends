package de.koanam.foodwithfriends.matching;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.coxautodev.graphql.tools.GraphQLMutationResolver;

import de.koanam.foodwithfriends.matching.model.Date;
import de.koanam.foodwithfriends.matching.model.UserMatch;
import de.koanam.foodwithfriends.matching.service.UserMatchService;

@Component
public class RootMutationResolver implements GraphQLMutationResolver{

	@Autowired
	private UserMatchService userMatchService;
	
	public UserMatch setMatchStatus(long matchId, boolean status) {
		UserMatch userMatch=this.userMatchService.setMatchStatus(matchId, status);
		
		return userMatch;
	}
	
	public Date setUserDateStatus(long userId, long dateMatchId, boolean status) {
		Date date=this.userMatchService.setDateMatchStatus(userId, dateMatchId, status);
		return date;
	}
	
}
