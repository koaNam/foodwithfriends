import 'package:foodwithfriends/bloc/vote/AbstractVoteBloc.dart';
import 'package:foodwithfriends/model/DateVote.dart';
import 'package:foodwithfriends/model/User.dart';
import 'package:foodwithfriends/service/PlanningService.dart';

class DateVoteBloc extends AbstractVoteBloc{

  DateTime date = DateTime.now(); // Initial auf heute setzen
  DateTime time = DateTime.now();

  PlanningService _planningService;

  DateVoteBloc(){
    this._planningService = new PlanningService();
  }

  @override
  void addVote(int dateId, int userId) {
    DateTime dateTime = DateTime.utc(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute
    );
    
    DateVote vote = new DateVote.dateVote(dateTime, null, User(userId, null, null, null, null, null), dateId);
    this._planningService.addDateVote(vote);
  }

}