package de.koanam.foodwithfriends.awsgw;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;

import de.koanam.foodwithfriends.awsgw.config.S3Config;

@SpringBootApplication
public class AwsGW {

	public static void main(String[] args) {
		SpringApplication.run(AwsGW.class, args);
	}

	@Bean
    public BasicAWSCredentials basicAWSCredentials(S3Config config) {
        return new BasicAWSCredentials(config.getAccessKey(), config.getSecretKey());
    }
	
	@Bean
	public AmazonS3 amazonS3Client(AWSCredentials awsCredentials) {
		AmazonS3ClientBuilder builder = AmazonS3ClientBuilder.standard();
		builder.withCredentials(new AWSStaticCredentialsProvider(awsCredentials));
		builder.setRegion(Regions.EU_CENTRAL_1.getName());
		AmazonS3 amazonS3 = builder.build();
		return amazonS3;
	}

}
