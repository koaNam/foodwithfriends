import 'dart:convert' as convert;

import 'graphql_element.dart';

class Mutation{

  static const String INSERT="objects:";
  static const String UPDATE="_set:";
  static const String DELETE=" ";
  static const String NONE ="";

  String name;
  String kind;
  List<GraphQlElement> returning;
  List<String> queryObjects;

  Mutation(this.name, this.kind);

  Mutation addReturning(GraphQlElement returning){
   if(this.returning == null){
     this.returning=new List();
   }
   this.returning.add(returning);
   return this;
  }


  Mutation addObjects(String queryObjects){
    if(this.queryObjects == null){
      this.queryObjects=new List();
    }
    this.queryObjects.add(queryObjects);
    return this;
  }

  String build(){
    String objects=this.queryObjects[0].replaceAllMapped(RegExp("(\")([a-zA-Z_]+)(\")(:)"), (match) {return '${match[2]}${match[4]}';});

    StringBuffer mutation=StringBuffer("mutation ${this.name} { ");
    mutation.write(this.name);
    mutation.write("(${kind} ");
    mutation.write(objects);
    for(int i=1; i<this.queryObjects.length; i++){
      String object=this.queryObjects[i].replaceAllMapped(RegExp("(\")([a-zA-Z_]+)(\")(:)"), (match) {return '${match[2]}${match[4]}';});
      mutation.write(", "+object);
    }

    mutation.write(") {");
    if(kind != NONE){
      mutation.write(" returning {");
    }

    for(GraphQlElement returning in this.returning){
      mutation.write(returning.toString());
      mutation.write(" ");
    }
    mutation.write("}}");

    if(kind != NONE){
      mutation.write("}");
    }

    Map<String, String> request=new Map();
    request["query"]=mutation.toString();
    request["variables"]=null;
    request["operationName"]=this.name;

    return  convert.json.encode(request);
  }

}
