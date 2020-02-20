
import 'dart:convert' as convert;

import 'condition.dart';
import 'graphql_element.dart';

class Graph extends GraphQlElement{

  List<GraphQlElement> children;
  Condition queryCondition;
  int queryLimit;
  int queryOffset;

  Graph(String name) : super(name);

  Graph add(GraphQlElement child){
    if(children == null){
      this.children=List();
    }
    this.children.add(child);
    return this;
  }

  Graph condition(Condition condition){
    this.queryCondition=condition;
    return this;
  }

  Graph limit(int limit){
    this.queryLimit=limit;
    return this;
  }

  Graph offset(int offset){
    this.queryOffset=offset;
    return this;
  }

  String toString(){
    StringBuffer query=StringBuffer(this.name);
    if(this.queryLimit != null || this.queryOffset != null || this.queryCondition != null) {
      query.write("(");
      if(this.queryLimit != null){
        query.write("limit: ");
        query.write(this.queryLimit);
        query.write(",");
      }
      if(this.queryOffset != null){
        query.write("offset: ");
        query.write(this.queryOffset);
        query.write(",");
      }
      if(this.queryCondition != null){
        query.write(this.queryCondition);
      }
      query.write(")");
    }
    query.write("{ ");
    for(GraphQlElement element in children){
      query.write(element);
    }
    query.write(" } ");
    return query.toString();
  }

  String build(){
    String query="{ " +this.toString()+" }";
    Map<String, String> request=new Map();
    request["query"]=query;
    request["variables"]=null;
    return convert.json.encode(request);
  }

}