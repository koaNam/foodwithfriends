package de.koanam.graphdemo;

import java.util.Collection;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.coxautodev.graphql.tools.GraphQLQueryResolver;

import de.koanam.graphdemo.model.User;
import de.koanam.graphdemo.model.DateMatch;
import de.koanam.graphdemo.service.UserMatchService;
import de.koanam.graphdemo.service.UserService;

@Component
public class RootQueryResolver implements GraphQLQueryResolver {

	@Autowired
	private UserService userService;
	
	@Autowired
	private UserMatchService userMatchService;
	
	public List<User> getMatches(long userId, double innerRadius, int count) {
		List<User> users=this.userService.findTopUsers(userId, innerRadius, count);

		return users;
	}
	
	public Collection<DateMatch> getDateMatches(long userId, double innerRadius, int count) {
		Collection<DateMatch> dateMatchs = this.userMatchService.getDateMatches(userId, innerRadius, count);
		
		return dateMatchs;
	}

}
