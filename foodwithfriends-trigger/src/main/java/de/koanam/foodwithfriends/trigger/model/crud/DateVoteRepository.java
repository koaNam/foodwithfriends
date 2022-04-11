package de.koanam.foodwithfriends.trigger.model.crud;

import org.springframework.data.jpa.repository.JpaRepository;

import de.koanam.foodwithfriends.trigger.model.entity.DateVote;

public interface DateVoteRepository extends JpaRepository<DateVote, Long>{

}
