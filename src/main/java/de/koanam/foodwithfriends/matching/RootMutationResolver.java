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
	
	public UserMatch addMatch(long userId, long matchId) {
		UserMatch userMatch=this.userMatchService.addMatch(userId, matchId);
		
		return userMatch;
	}
	
	public Date acceptUserDate(long userId, long dateMatchId) {
		Date date=this.userMatchService.acceptDateMatch(userId, dateMatchId);
		return date;
	}
	
}
