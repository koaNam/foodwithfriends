package de.koanam.foodwithfriends.matching.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

import javax.persistence.NoResultException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import de.koanam.foodwithfriends.matching.crud.DateMatchRepository;
import de.koanam.foodwithfriends.matching.crud.DateRepository;
import de.koanam.foodwithfriends.matching.crud.UserDateMatchRepository;
import de.koanam.foodwithfriends.matching.crud.UserMatchRepository;
import de.koanam.foodwithfriends.matching.crud.UserRepository;
import de.koanam.foodwithfriends.matching.model.Date;
import de.koanam.foodwithfriends.matching.model.DateMatch;
import de.koanam.foodwithfriends.matching.model.User;
import de.koanam.foodwithfriends.matching.model.UserDateMatch;
import de.koanam.foodwithfriends.matching.model.UserMatch;

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

	public UserMatch setMatchStatus(long matchId, boolean status) {
		UserMatch userMatch=this.userMatchRepository.findById(matchId).orElseThrow();
		
		userMatch.setAccepted(status);
		userMatch = this.userMatchRepository.save(userMatch);
		
		return userMatch;
	}
	
	public Collection<DateMatch> getDateMatches(long userId, double innerRadius, int count){
		User me=this.userRepository.findById(userId).get();
		
		List<User> baseMatches = this.userMatchRepository.findByUserIdAndAccepted(userId, true).stream().map(e -> e.getMatch()).collect(Collectors.toList());
		LOG.info("found {} matches for user {}", baseMatches.size(), userId);

		List<List<User>> matchIntersections = this.getMatchIntersections(baseMatches);

		List<DateMatch> dateMatches=new ArrayList<>();
		for(int i=0; i<matchIntersections.size(); i++) {
			List<User> primaryIntersection=matchIntersections.get(i);
			for(int j=0; j<matchIntersections.size(); j++) {
				if(i==j) {
					continue;
				}
				List<User> secondaryIntersection=matchIntersections.get(j);
				
				primaryIntersection.retainAll(secondaryIntersection);
				if(primaryIntersection.size() >= 3) {
					List<UserDateMatch> userDateMatches = primaryIntersection.stream().map(e -> new UserDateMatch(e)).collect(Collectors.toList());
					UserDateMatch myMatch=new UserDateMatch(me);
					userDateMatches.add(myMatch);

					userDateMatches.sort((UserDateMatch u1, UserDateMatch u2) -> (int)(u1.getUser().getId() - u2.getUser().getId()));

					DateMatch dateMatch=new DateMatch(userDateMatches);

					if(!dateMatches.contains(dateMatch)) {
						dateMatches.add(dateMatch);
					}
				}
			}
		}
		
		LOG.info("build {} dateMatches from {} potential intersections", dateMatches.size(), matchIntersections.size());
		
		List<DateMatch> foundDateMatches=this.dateMatchRepository.findByUserIdAndAcceptedIsNull(userId);

		LOG.info("User with id {} has already {} dateMatches", userId, foundDateMatches.size());

		List<DateMatch> savedDateMatches = this.saveDateMatches(dateMatches.stream().filter(dm -> !foundDateMatches.contains(dm)).collect(Collectors.toList()));
		foundDateMatches.addAll(savedDateMatches);
		LOG.info("Added new dateMatches, new count is {}", foundDateMatches.size());
				
		return foundDateMatches;
	}

	private List<DateMatch> saveDateMatches(List<DateMatch> dateMatches) {
		List<DateMatch> savedDateMatches = new ArrayList<>(dateMatches.size());
		for(DateMatch d: dateMatches) {
			savedDateMatches.add(d);
			this.dateMatchRepository.save(d);
		}
		return savedDateMatches;
	}

	private List<List<User>> getMatchIntersections(List<User> baseMatches) {
		List<List<User>> matchIntersections=new ArrayList<>();
		for(User user: baseMatches) {
			List<User> intersection = new ArrayList<>(baseMatches);

			List<User> matches= this.userMatchRepository.findByUserIdAndAccepted(user.getId(), true).stream().map(e -> e.getMatch()).collect(Collectors.toList());
			matches.add(user);
			intersection.retainAll(matches);
			matchIntersections.add(intersection);
		}
		return matchIntersections;
	}

	public Date setDateMatchStatus(Long userId, Long dateMatchId, boolean status) throws NoResultException{
		UserDateMatch userDateMatch=this.userDateMatchRepository.findByUserUserIdAndDateMatchId(userId, dateMatchId);
		if(userDateMatch == null) {
			throw new NoResultException("No DateMatch found for id: "+ dateMatchId +" with user: " + userId);
		}
		
		userDateMatch.setAccepted(status);
		userDateMatch = this.userDateMatchRepository.save(userDateMatch);
		
		List<UserDateMatch> matches=this.userDateMatchRepository.findByUserDateMatchId(dateMatchId);
		
		if(status) {	// if DateMatch was accepted by User, check if all participants have accepted
			boolean accepted=true;
			for(UserDateMatch match: matches) {
				if(match.isAccepted() != null && !match.isAccepted()) {
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
		}
		return null;
	}
	
	
}
