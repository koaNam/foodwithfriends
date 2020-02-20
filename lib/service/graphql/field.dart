

import 'graphql_element.dart';

class Field extends GraphQlElement{

  Field(String name) : super(name);

  @override
  String toString() {
    return this.name+" ";
  }

}