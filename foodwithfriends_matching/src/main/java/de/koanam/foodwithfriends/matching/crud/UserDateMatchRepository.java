package de.koanam.foodwithfriends.matching.crud;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import de.koanam.foodwithfriends.matching.model.UserDateMatch;

public interface UserDateMatchRepository extends CrudRepository<UserDateMatch, Long>{

	@Query("select udm from UserDateMatch udm inner join DateMatch dm on udm.dateMatch = dm.id inner join User u on udm.user = u.id where u.id = :userId and dm.id = :id")
	public UserDateMatch findByUserUserIdAndDateMatchId(@Param("userId")Long userId, @Param("id")Long dateMatchId);
	
	@Query("select udm from UserDateMatch udm inner join DateMatch dm on udm.dateMatch = dm.id where dm.id = :id")
	public List<UserDateMatch> findByUserDateMatchId(@Param("id")Long dateMatchId);
	
}
