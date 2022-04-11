import 'dart:math';

import 'package:rxdart/rxdart.dart';
import 'package:foodwithfriends/model/Property.dart';
import 'package:foodwithfriends/service/PropertyService.dart';

import 'dart:developer' as developer;

class PropertyBloc{

  static const String LOG="bloc.PropertyBloc";

  BehaviorSubject<List<Property>> _propertyController = BehaviorSubject<List<Property>>();
  Observable<List<Property>> get propertyStream =>_propertyController.stream;

  PropertyService _propertyService;

  PropertyBloc(){
    _propertyService=new PropertyService();
  }

  Future<void> findRandomProperties() async{
    developer.log("finding random properties", name: LOG);

    int maxId =await this._propertyService.findMaxId();

    List<int> ids = new List();
    Random random = new Random();
    for(int i=0; i < 6; i++){
      ids.add(random.nextInt(maxId));
    }
    List<Property> properties = await this._propertyService.findByIdInList(ids);

    this._propertyController.add(properties);
  }

  Future<void> findProperty(String likeName) async{
    developer.log("finding property with like", name: LOG);
    List<Property> result= await this._propertyService.findLikeName(likeName);

    this._propertyController.add(result);
  }

}