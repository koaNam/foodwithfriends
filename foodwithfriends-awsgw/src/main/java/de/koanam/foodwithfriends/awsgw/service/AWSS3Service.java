package de.koanam.foodwithfriends.awsgw.service;

import java.io.ByteArrayInputStream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.s3.model.PutObjectResult;

import de.koanam.foodwithfriends.awsgw.config.S3Config;

@Service
public class AWSS3Service {

	private static final Logger LOG = LoggerFactory.getLogger(AWSS3Service.class);
	
	@Autowired
	private S3Config config;
	
	@Autowired
	private AmazonS3 amazonS3;

	public void writeToS3(String name, byte[] data) {
		LOG.info("trying to write picture to S3 with name {}", name);
		ObjectMetadata metadata = new ObjectMetadata();
		metadata.setContentType("image/png");
		
		PutObjectRequest request = new PutObjectRequest(config.getBucketName(), name, new ByteArrayInputStream(data), metadata)
				.withCannedAcl(CannedAccessControlList.PublicRead);
		PutObjectResult result = amazonS3.putObject(request);
		LOG.info("finished to write picture to S3 with name {}, result is", name, result);
	}

}
