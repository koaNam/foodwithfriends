package de.koanam.graphdemo.model;

import java.util.Set;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OrderBy;

import org.hibernate.annotations.LazyCollection;
import org.hibernate.annotations.LazyCollectionOption;


@Entity
public class User {

	@Id
	private Long id;
	private String name;
	
	private String profilePicture;
	private Double latitude;
	private Double longitude;
	
	@ManyToMany
	@LazyCollection(LazyCollectionOption.FALSE)
	@JoinTable(name="user_property", joinColumns=@JoinColumn(name="user_id"), inverseJoinColumns=@JoinColumn(name="property_id"))
	@OrderBy("id")
	private Set<Property> properties; 

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getProfilePicture() {
		return profilePicture;
	}
	
	public String getProfile_picture() {
		return profilePicture;
	}

	public void setProfilePicture(String profilePicture) {
		this.profilePicture = profilePicture;
	}

	public Double getLatitude() {
		return latitude;
	}

	public void setLatitude(Double latitude) {
		this.latitude = latitude;
	}

	public Double getLongitude() {
		return longitude;
	}

	public void setLongitude(Double longitude) {
		this.longitude = longitude;
	}
	
	
	public Set<Property> getProperties() {
		return properties;
	}

	public void setProperties(Set<Property> properties) {
		this.properties = properties;
	}

	public User(Long id, String name, String profilePicture, Double latitude, Double longitude) {
		this.id = id;
		this.name = name;
		this.profilePicture = profilePicture;
		this.latitude = latitude;
		this.longitude = longitude;
	}

	public User(Long id) {
		this.id=id;
	}
	
	public User() {
	}

	@Override
	public String toString() {
		return "User [id=" + id + ", name=" + name + ", profilePicture=" + profilePicture + ", latitude=" + latitude
				+ ", longitude=" + longitude + ", properties=]";
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		User other = (User) obj;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		return true;
	}
	
	

}
