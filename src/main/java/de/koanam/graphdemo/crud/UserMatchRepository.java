package de.koanam.graphdemo.crud;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import de.koanam.graphdemo.model.UserMatch;

public interface UserMatchRepository extends JpaRepository<UserMatch, Long>{

	public List<UserMatch> findByUserId(Long userId);
	
}
