package de.koanam.foodwithfriends.matching.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;

@Entity
public class InheritedProperty {

    @Id
    private Long id;    //TODO Feld in DB

    @ManyToOne
    private Property parent;

    @OneToOne
    private Property child;

    private double inheritanceFactor;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Property getParent() {
        return parent;
    }

    public void setParent(Property parent) {
        this.parent = parent;
    }

    public Property getChild() {
        return child;
    }

    public void setChild(Property child) {
        this.child = child;
    }

    public double getInheritanceFactor() {
        return inheritanceFactor;
    }

    public void setInheritanceFactor(double inheritanceFactor) {
        this.inheritanceFactor = inheritanceFactor;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        InheritedProperty that = (InheritedProperty) o;

        return id != null ? id.equals(that.id) : that.id == null;
    }

    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 0;
    }
}
