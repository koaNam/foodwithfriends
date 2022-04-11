package de.koanam.foodwithfriends.trigger.model.crud;

import org.springframework.data.jpa.repository.JpaRepository;

import de.koanam.foodwithfriends.trigger.model.entity.Date;

public interface DateRepository extends JpaRepository<Date, Long>{

}
