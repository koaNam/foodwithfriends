package de.koanam.foodwithfriends.matching.crud;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import de.koanam.foodwithfriends.matching.model.DateMatch;

public interface DateMatchRepository extends CrudRepository<DateMatch, Long>{
	
	@Query("select dm from DateMatch dm inner join UserDateMatch udm on dm.id = udm.dateMatch inner join User u on u.id = udm.user where u.id = :userId")
	public List<DateMatch> findByUserId(@Param("userId")Long userId);
	
//	@Query("select dm from DateMatch dm inner join UserDateMatch udm on dm.id = udm.dateMatch inner join User u on u.id = udm.user where u.id = :userId and dm.id = :id")
//	public DateMatch findByUserUserIdAndId(@Param("userId")Long userId, @Param("id")Long dateMatchId);
	
}
