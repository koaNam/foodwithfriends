package de.koanam.graphdemo.crud;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import de.koanam.graphdemo.model.Date;

@Repository
public interface DateRepository extends CrudRepository<Date, Long>{

}
