import 'package:rxdart/rxdart.dart';
import 'package:tinder_cards/model/Property.dart';
import 'package:tinder_cards/service/PropertyService.dart';

import 'dart:developer' as developer;

class PropertyBloc{

  static const String LOG="bloc.PropertyBloc";

  BehaviorSubject<List<Property>> _propertyController = BehaviorSubject<List<Property>>();
  Observable<List<Property>> get propertyStream =>_propertyController.stream;

  PropertyService _propertyService;

  PropertyBloc(){
    _propertyService=new PropertyService();
  }

  Future<void> findProperty(String likeName) async{
    developer.log("finding property with like", name: LOG);
    List<Property> result= await this._propertyService.findLikeName(likeName);

    this._propertyController.add(result);
  }

}