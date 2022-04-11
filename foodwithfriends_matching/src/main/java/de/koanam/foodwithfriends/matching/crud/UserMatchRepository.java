package de.koanam.foodwithfriends.matching.crud;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import de.koanam.foodwithfriends.matching.model.UserMatch;

public interface UserMatchRepository extends JpaRepository<UserMatch, Long>{

	public List<UserMatch> findByUserIdAndAccepted(Long userId, Boolean accepted);
	public List<UserMatch> findByUserIdAndAcceptedIsNull(Long userId);
	public List<UserMatch> findByUserId(Long userId);
	
}
