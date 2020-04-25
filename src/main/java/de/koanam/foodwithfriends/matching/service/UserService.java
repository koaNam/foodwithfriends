package de.koanam.foodwithfriends.matching.service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import de.koanam.foodwithfriends.matching.crud.UserMatchRepository;
import de.koanam.foodwithfriends.matching.crud.UserRepository;
import de.koanam.foodwithfriends.matching.model.Property;
import de.koanam.foodwithfriends.matching.model.User;
import de.koanam.foodwithfriends.matching.model.UserMatch;

@Service
public class UserService {

	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private UserMatchRepository userMatchRepository;
	
	public List<UserMatch> getMatches(long userId, double innerRadius, int count){
		User user=this.userRepository.findById(userId).orElseThrow();
		List<User> userMatches = this.userMatchRepository.findByUserId(userId).stream().map(um -> um.getMatch()).collect(Collectors.toList());
		
		List<User> nearestUsers=this.userRepository.findNearest(user.getLongitude(), user.getLatitude(), PageRequest.of(0, count));
		
		List<UserMatch> matches=new ArrayList<>();
		
		List<UserMatch> oldMatches = this.userMatchRepository.findByUserIdAndAcceptedIsNull(userId);
		for(User nearUser: nearestUsers) {
			if(nearUser.equals(user) || userMatches.contains(nearUser)) {
				continue;
			}
			
			int propertyCount=0;
			for(Property property: user.getProperties()) {
				if(nearUser.getProperties().contains(property)) {
					propertyCount++;
				}
				if(propertyCount >= Math.min(nearUser.getProperties().size(), user.getProperties().size()) / 3) {
					UserMatch userMatch=new UserMatch(user, nearUser);					
					userMatch = this.userMatchRepository.save(userMatch);
					
					matches.add(userMatch);
					break;
				}
			}
		}
		matches.addAll(oldMatches);
		return matches;
	}
	

	
}
