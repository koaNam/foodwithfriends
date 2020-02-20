

import 'graph.dart';
import 'graphql_element.dart';

class Condition<T>{
  static const String EQUALS="_eq";
  static const String LIKE="_like";

  GraphQlElement field;
  String operator;
  T value;

  Condition(this.field, this.operator, this.value);

  @override
  String toString(){
    GraphQlElement temp=this.field;
    String fieldName=temp.name;
    int levels=0;
    while(temp.runtimeType == Graph){
      temp = (temp as Graph).children[0];
      fieldName += ":{" + temp.name;
      levels++;
    }

    StringBuffer condition=new StringBuffer("where: {");
    condition.write(fieldName);
    condition.write(":{");
    condition.write(this.operator);
    condition.write(":");
    condition.write('"${this.value}"');
    condition.write("}");
    for(int i=0; i<levels; i++){
      condition.write("}");
    }
    condition.write("}, ");
    return condition.toString();
  }

}
