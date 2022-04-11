package de.koanam.foodwithfriends.awsgw;

import org.springframework.stereotype.Component;

import com.coxautodev.graphql.tools.GraphQLQueryResolver;

@Component
public class RootQueryResolver implements GraphQLQueryResolver {

	public String dummyQuery() {
		return "dummy";
	}
	
}
