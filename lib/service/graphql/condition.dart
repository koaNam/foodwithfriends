import 'package:foodwithfriends/service/graphql/ConditionElement.dart';

import 'graphql_element.dart';

class Condition<T>{

  static const String EQUALS="_eq";
  static const String LIKE="_like";
  static const String ILIKE="_ilike";
  static const String GREATER = "_gt";
  static const String LOWER = "_lt";

  GraphQlElement field;
  String operator;
  T value;

  List<ConditionElement> conditions = [];

  Condition(GraphQlElement field, String operator, T value){
    conditions.add(ConditionElement<T>(field, operator, value));
  }

  Condition.element(ConditionElement element){
    conditions.add(element);
  }

  Condition addCondition(ConditionElement element){
    conditions.add(element);
    return this;
  }

  @override
  String toString(){
    StringBuffer condition=new StringBuffer("where: {");
    for(ConditionElement element in this.conditions){
      condition.write(element.toString());
      condition.write(",");
    }

    condition.write("}, ");
    return condition.toString();
  }

}
