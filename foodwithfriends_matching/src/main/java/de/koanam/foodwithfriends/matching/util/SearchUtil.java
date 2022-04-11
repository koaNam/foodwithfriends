package de.koanam.foodwithfriends.matching.util;

import de.koanam.foodwithfriends.matching.model.InheritedProperty;
import de.koanam.foodwithfriends.matching.model.Property;
import org.springframework.data.util.Pair;

import java.util.LinkedList;
import java.util.List;
import java.util.Optional;


public class SearchUtil {

    public double dijkstraPropertySearch(Property start, Property goal){
        System.out.println(start.getName() + ", " + goal.getName());

        List<Pair<Property, Double>> unsettled = new LinkedList<>();
        List<Pair<Property, Double>> settled = new LinkedList<>();

        unsettled.add(Pair.of(start, 1.0));

        while(unsettled.size() > 0){
            Pair<Property, Double> p = unsettled.get(0);
            unsettled.remove(p);
            Property prop = p.getFirst();
            List<InheritedProperty> successors = prop.getInheritedProperties();
            for(InheritedProperty ip: successors){
                Optional<Pair<Property, Double>> unsettledNode = unsettled.stream().findAny().filter(n -> n.getFirst().equals(ip.getChild()));
                if(unsettledNode.isPresent()){
                    Pair<Property, Double> node = unsettledNode.get();
                    if(node.getSecond() < ip.getInheritanceFactor() * p.getSecond()){
                        unsettled.add(Pair.of(ip.getChild(), ip.getInheritanceFactor() * p.getSecond()));
                    }
                }else{
                    unsettled.add(Pair.of(ip.getChild(), ip.getInheritanceFactor() * p.getSecond()));
                }
            }
            settled.add(p);
        }

        for(Pair<Property, Double> element: settled){
            if(element.getFirst().equals(goal)){
                return element.getSecond();
            }
        }

        return 0;
    }

}
