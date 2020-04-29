import 'package:tinder_cards/bloc/vote/AbstractVoteBloc.dart';

class DateVoteBloc extends AbstractVoteBloc{

  DateTime date = DateTime.now(); // Initial auf heute setzen
  DateTime time = DateTime.now();

  @override
  void addVote(int dateId, int userId) {
    DateTime dateTime = date.add(Duration(hours: time.hour, minutes: time.minute));
    print(dateTime);
  }

}