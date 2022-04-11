package de.koanam.foodwithfriends.awsgw;

import java.util.Base64;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.coxautodev.graphql.tools.GraphQLMutationResolver;

import de.koanam.foodwithfriends.awsgw.service.AWSS3Service;

@Component
public class RootMutationResolver implements GraphQLMutationResolver{
	
	@Autowired
	private AWSS3Service s3Service;
	
	public boolean uploadData(String name, String base64String) {
		byte[] data = Base64.getDecoder().decode(base64String);
		this.s3Service.writeToS3(name, data);
		
		return true;
	}
}
