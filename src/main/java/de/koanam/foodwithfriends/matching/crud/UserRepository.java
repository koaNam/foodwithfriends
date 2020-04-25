package de.koanam.foodwithfriends.matching.crud;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import de.koanam.foodwithfriends.matching.model.User;

public interface UserRepository extends JpaRepository<User, Long>{

	@Query(value = "select * from public.user order by point(longitude, latitude) <@> point(:longitude, :latitude) asc", nativeQuery = true)
	//@Query(value = "select * from user order by point(longitude, latitude) <@> point(:longitude, :latitude) asc", nativeQuery = true)
	public List<User> findNearest(Double longitude, Double latitude, Pageable pageable);
	
}
