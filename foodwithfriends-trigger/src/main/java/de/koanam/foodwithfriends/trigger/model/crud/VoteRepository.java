package de.koanam.foodwithfriends.trigger.model.crud;

import org.springframework.data.jpa.repository.JpaRepository;

import de.koanam.foodwithfriends.trigger.model.entity.Vote;

public interface VoteRepository extends JpaRepository<Vote, Long>{

}
