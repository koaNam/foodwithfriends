package de.koanam.foodwithfriends.matching.model;

import javax.persistence.*;
import java.util.List;

@Entity
public class Property {

	@Id
	private Long id;
	private String name;
	private String colour;

	@OneToMany(mappedBy = "parent", fetch = FetchType.EAGER)
	private List<InheritedProperty> inheritedProperties;

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

	public String getColour() {
		return colour;
	}

	public void setColour(String colour) {
		this.colour = colour;
	}

	public List<InheritedProperty> getInheritedProperties() {
		return inheritedProperties;
	}

	public void setInheritedProperties(List<InheritedProperty> inheritedProperties) {
		this.inheritedProperties = inheritedProperties;
	}

	public Property() {
	}

	@Override
	public String toString() {
		return "Property [id=" + id + ", name=" + name + ", colour=" + colour + "]";
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
		Property other = (Property) obj;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		return true;
	}
	
	

}
