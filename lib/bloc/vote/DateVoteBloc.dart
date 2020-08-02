import 'package:foodwithfriends/bloc/vote/AbstractVoteBloc.dart';
import 'package:foodwithfriends/model/DateVote.dart';
import 'package:foodwithfriends/model/User.dart';
import 'package:foodwithfriends/service/PlanningService.dart';
import 'package:rxdart/rxdart.dart';

class DateVoteBloc extends AbstractVoteBloc{

  BehaviorSubject<DateTime> _dateController = BehaviorSubject<DateTime>();
  Observable<DateTime> get dateStream =>_dateController.stream;

  PlanningService _planningService;

  set date(DateTime date){
    DateTime lastValue = _dateController.value;
    DateTime dateTime = DateTime.utc(
        date.year,
        date.month,
        date.day,
        lastValue.hour,
        lastValue.minute
    );
    this._dateController.add(dateTime);
  }

  set time(DateTime time){
    DateTime lastValue = _dateController.value;
    DateTime dateTime = DateTime.utc(
        lastValue.year,
        lastValue.month,
        lastValue.day,
        time.hour,
        time.minute
    );
    this._dateController.add(dateTime);
  }

  DateVoteBloc(){
    this._planningService = new PlanningService();
    this._dateController.add(DateTime.now());
  }

  @override
  void addVote(int dateId, int userId) {
    DateTime dateTime = this._dateController.value;
    
    DateVote vote = new DateVote.dateVote(dateTime, null, User(userId, null, null, null, null, null), dateId);
    this._planningService.addDateVote(vote);
  }

}