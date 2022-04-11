package de.koanam.foodwithfriends.matching;

import java.util.Collection;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.coxautodev.graphql.tools.GraphQLQueryResolver;

import de.koanam.foodwithfriends.matching.model.DateMatch;
import de.koanam.foodwithfriends.matching.model.UserMatch;
import de.koanam.foodwithfriends.matching.service.UserMatchService;
import de.koanam.foodwithfriends.matching.service.UserService;

@Component
public class RootQueryResolver implements GraphQLQueryResolver {

	@Autowired
	private UserService userService;
	
	@Autowired
	private UserMatchService userMatchService;
	
	public Collection<UserMatch> getMatches(long userId, double innerRadius, int count) {
		Collection<UserMatch> matches=this.userService.getMatches(userId, innerRadius, count);

		return matches;
	}
	
	public Collection<DateMatch> getDateMatches(long userId, double innerRadius, int count) {
		Collection<DateMatch> dateMatches = this.userMatchService.getDateMatches(userId, innerRadius, count);
		
		return dateMatches;
	}

}
