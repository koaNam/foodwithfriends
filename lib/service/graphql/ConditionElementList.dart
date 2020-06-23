import 'ConditionElement.dart';

class ConditionElementList<T> extends ConditionElement{

  static const String OR="_or";
  static const String AND="_and";

  List<ConditionElement> conditionElements = new List();
  String operator;

  ConditionElementList(this.operator) : super.empty();

  addConditionElement(ConditionElement conditionElement){
    this.conditionElements.add(conditionElement);
  }

  @override
  String toString(){
    StringBuffer condition = StringBuffer("${this.operator}: [");
    
    for(ConditionElement conditionElement in conditionElements){
      condition.write("{");
      condition.write(conditionElement.toString());
      condition.write("}");
    }
    
    condition.write("]");
    return condition.toString();
  }

}