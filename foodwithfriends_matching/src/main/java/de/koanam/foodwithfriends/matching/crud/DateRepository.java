package de.koanam.foodwithfriends.matching.crud;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import de.koanam.foodwithfriends.matching.model.Date;

@Repository
public interface DateRepository extends CrudRepository<Date, Long>{

}
