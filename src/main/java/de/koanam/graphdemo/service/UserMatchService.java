package de.koanam.graphdemo.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

import javax.persistence.NoResultException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import de.koanam.graphdemo.crud.DateMatchRepository;
import de.koanam.graphdemo.crud.DateRepository;
import de.koanam.graphdemo.crud.UserDateMatchRepository;
import de.koanam.graphdemo.crud.UserMatchRepository;
import de.koanam.graphdemo.crud.UserRepository;
import de.koanam.graphdemo.model.User;
import de.koanam.graphdemo.model.UserDateMatch;
import de.koanam.graphdemo.model.Date;
import de.koanam.graphdemo.model.DateMatch;
import de.koanam.graphdemo.model.UserMatch;

@Service
public class UserMatchService {

	private static final Logger LOG=LoggerFactory.getLogger(UserMatchService.class);
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private UserMatchRepository userMatchRepository;
	
	@Autowired
	private DateMatchRepository dateMatchRepository;
	
	@Autowired
	private UserDateMatchRepository userDateMatchRepository;
	
	@Autowired
	private DateRepository dateRepository;

	public UserMatch addMatch(Long userId, Long matchId) {
		
		User user=new User();
		user.setId(userId);
		
		User match=new User();
		match.setId(matchId);
		
		UserMatch userMatch=new UserMatch(user, match);
		
		userMatch = this.userMatchRepository.save(userMatch);
		
		return userMatch;
	}
	
	public Collection<DateMatch> getDateMatches(long userId, double innerRadius, int count){
		User me=this.userRepository.findById(userId).get();
		
		List<User> baseMatches = this.userMatchRepository.findByUserId(userId).stream().map(e -> e.getMatch()).collect(Collectors.toList());
		LOG.info("found {} matches for user {}", baseMatches.size(), userId);
		
		List<List<User>> matchIntersections=new ArrayList<>();
		for(User user: baseMatches) {
			List<User> intersection = new ArrayList<>(baseMatches);
			
			List<User> matches= this.userMatchRepository.findByUserId(user.getId()).stream().map(e -> e.getMatch()).collect(Collectors.toList());
			matches.add(user);
			intersection.retainAll(matches);
			matchIntersections.add(intersection);
		}
		
		List<DateMatch> intersections=new ArrayList<>();
		for(int i=0; i<matchIntersections.size(); i++) {
			List<User> firstIntersection=matchIntersections.get(i);
			for(int j=0; j<matchIntersections.size(); j++) {
				if(i==j) {
					continue;
				}
				List<User> secondIntersection=matchIntersections.get(j);
				
				List<User> resultIntersection=new ArrayList<>(firstIntersection);
				resultIntersection.retainAll(secondIntersection);
				
				if(resultIntersection.size() >=3) {
					List<UserDateMatch> udm = resultIntersection.stream().map(e -> new UserDateMatch(e)).collect(Collectors.toList());
					UserDateMatch myMatch=new UserDateMatch(me);
					udm.add(myMatch);
					
					udm.sort((UserDateMatch u1, UserDateMatch u2) -> (int)(u1.getUser().getId() - u2.getUser().getId()));
					
					DateMatch dateMatch=new DateMatch(udm);
					
					for(UserDateMatch m: udm) {
						m.setDateMatch(dateMatch);							
					}
					
					
					if(!intersections.contains(dateMatch)) {
						intersections.add(dateMatch);
					}
				}
			}
		}
		
		LOG.info("build {} dateMatches from {} potential intersections", intersections.size(), matchIntersections.size());
		
		List<DateMatch> result=new ArrayList<>();
		
		result.addAll(this.dateMatchRepository.findByUserId(userId));
		LOG.info("User with id {} has already {} dateMatches", userId, result.size());
		
		for(DateMatch d: intersections) {
			if(!result.contains(d)) {
				result.add(d);
				this.dateMatchRepository.save(d);
			}
		}
		LOG.info("Added new dateMatches, new count is {}", result.size());
				
		return result;
	}
	
	public Date acceptDateMatch(Long userId, Long dateMatchId) throws NoResultException{
		UserDateMatch userDateMatch=this.userDateMatchRepository.findByUserUserIdAndDateMatchId(userId, dateMatchId);
		if(userDateMatch == null) {
			throw new NoResultException("No DateMatch found for id: "+ dateMatchId +" with user: " + userId);
		}
		
		userDateMatch.setAccepted(true);
		userDateMatch = this.userDateMatchRepository.save(userDateMatch);
		
		List<UserDateMatch> matches=this.userDateMatchRepository.findByUserDateMatchId(dateMatchId);
		
		boolean accepted=true;
		for(UserDateMatch match: matches) {
			if(!match.isAccepted()) {
				accepted = false;
				break;
			}
		}
		
		if(accepted) {
			List<User> participants=matches.stream().map(m -> m.getUser()).collect(Collectors.toList());
			Date date=new Date(participants);
			this.dateRepository.save(date);
			
			return date;
		}
		
		return null;
	}
	
}
