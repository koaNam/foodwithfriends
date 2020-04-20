import 'graphql_element.dart';

class ConditionElement<T>{

  ConditionElement(this.field, this.operator, this.value);

  GraphQlElement field;
  String operator;
  T value;

  @override
  String toString(){
    StringBuffer condition=StringBuffer();
    condition.write(field.name);
    condition.write(":{");
    condition.write(this.operator);
    condition.write(":");
    if(T == String){
      condition.write('"');
    }
    condition.write('${this.value}');
    if(T == String){
      condition.write('"');
    }
    condition.write("}");
    return condition.toString();
  }

}