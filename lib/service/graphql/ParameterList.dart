import 'package:foodwithfriends/service/graphql/condition.dart';

class ParameterList<T> extends Condition<T>{

  List<Pair> parameters=List();

  ParameterList() : super(null, ':', null);

  ParameterList addParameter(String key, String value){
    this.parameters.add(Pair(key, value));
    return this;
  }

  @override
  String toString(){
    StringBuffer result=new StringBuffer();

    for(int i=0; i<this.parameters.length; i++){
      Pair parameter=this.parameters[i];

      result.write(parameter.key);
      result.write(":");
      result.write(parameter.value);

      if(i != this.parameters.length -1){
        result.write(",");
      }

    }

    return result.toString();
  }

}

class Pair {
  String key;
  String value;

  Pair(this.key, this.value);

}