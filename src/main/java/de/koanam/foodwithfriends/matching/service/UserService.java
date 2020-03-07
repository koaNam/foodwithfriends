package de.koanam.foodwithfriends.matching.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;

import de.koanam.foodwithfriends.matching.crud.UserRepository;
import de.koanam.foodwithfriends.matching.model.Property;
import de.koanam.foodwithfriends.matching.model.User;

@Service
public class UserService {

	@Autowired
	private UserRepository userRepository;
	
	public List<User> findTopUsers(long userId, double innerRadius, int count){
		User user=this.userRepository.findById(userId).orElseThrow();
		
		List<User> nearestUsers=this.userRepository.findNearest(user.getLongitude(), user.getLatitude(), PageRequest.of(0, count));
		//Slice<User> nearestUsers=this.userRepository.findAll(PageRequest.of(0, count));
		
		List<User> matches=new ArrayList<>();
		
		for(User nearUser: nearestUsers) {
			if(nearUser.equals(user)) {
				continue;
			}
			int propertyCount=0;
			for(Property property: user.getProperties()) {
				if(nearUser.getProperties().contains(property)) {
					propertyCount++;
				}
				if(propertyCount >= nearUser.getProperties().size() * 0.30) {
					matches.add(nearUser);
					break;
				}
			}
		}

		return matches;
	}
	

	
}
