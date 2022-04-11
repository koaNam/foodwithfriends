package de.koanam.foodwithfriends.matching.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

import de.koanam.foodwithfriends.matching.util.SearchUtil;
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
	
	public Collection<UserMatch> getMatches(long userId, double innerRadius, int count){
		User user=this.userRepository.findById(userId).orElseThrow();
		List<User> userMatches = this.userMatchRepository.findByUserId(userId).stream().map(um -> um.getMatch()).collect(Collectors.toList());
		
		List<User> nearestUsers=this.userRepository.findNearest(user.getLongitude(), user.getLatitude(), PageRequest.of(0, count));
		
		List<UserMatch> matches=new ArrayList<>();
		
		List<UserMatch> oldMatches = this.userMatchRepository.findByUserIdAndAcceptedIsNull(userId);
		for(User nearUser: nearestUsers) {
			if(nearUser.equals(user) || userMatches.contains(nearUser)) {
				continue;
			}
			
			if(this.checkProperties(nearUser, user) || this.checkAge(nearUser, user) || this.checkSkill(nearUser, user)){
				UserMatch userMatch=new UserMatch(user, nearUser);
				userMatch = this.userMatchRepository.save(userMatch);

				matches.add(userMatch);
			}
		}
		matches.addAll(oldMatches);
		return matches;
	}

	private boolean checkProperties(User nearUser, User user){
		int propertyCount=0;
		for(Property property: user.getProperties()) {
			for(Property nearUserProp: nearUser.getProperties()){
				propertyCount += new SearchUtil().dijkstraPropertySearch(property, nearUserProp);
			}
			/*if(nearUser.getProperties().contains(property)) {
				propertyCount++;
			}*/
			if(propertyCount >= Math.min(nearUser.getProperties().size(), user.getProperties().size()) / 5) {
				return true;
			}
		}
		return false;
	}
	
	private boolean checkAge(User nearUser, User user){
		if(nearUser.getBirthdate() == null){
			return true;
		}
		if(user.getBirthdate() == null){
			return false;
		}

		if(nearUser.getBirthdate().plusYears(nearUser.getAgeMaxOffset()).isAfter(user.getBirthdate()) &&
				nearUser.getBirthdate().minusYears(nearUser.getAgeMinOffset()).isBefore(user.getBirthdate()) &&
				user.getBirthdate().plusYears(user.getAgeMaxOffset()).isAfter(nearUser.getBirthdate()) &&
				user.getBirthdate().minusYears(user.getAgeMinOffset()).isBefore(nearUser.getBirthdate())){
			return true;
		}
		return false;
	}

	private boolean checkSkill(User nearUser, User user){
		if(nearUser.getCookingSkill() + nearUser.getSkillMaxOffset() >= user.getCookingSkill() &&
				nearUser.getCookingSkill() - nearUser.getSkillMinOffset() <= user.getCookingSkill() &&
				user.getCookingSkill() + user.getSkillMaxOffset() >= nearUser.getCookingSkill() &&
				user.getCookingSkill() - user.getSkillMinOffset() <= nearUser.getCookingSkill()){
			return true;
		}
		return false;
	}
	
}
