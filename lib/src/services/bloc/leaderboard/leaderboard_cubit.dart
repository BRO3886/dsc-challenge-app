import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/helpers/api_response.dart';
import '../../../data/models/leaderboard.dart';
import '../../../data/repos/leaderboard.dart';

part 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  LeaderboardCubit() : super(LeaderboardLoading());

  List<Result> results = [];

  getLeaderboard() async {
    emit(LeaderboardLoading());
    final response = await LeaderboardRepository.getLeaderBoard();
    switch (response.status) {
      case Status.LOADING:
        break;
      case Status.COMPLETED:
        results.clear();
        results.addAll(response.data.result);
        emit(LeaderboardSuccess(leaderboard: response.data));
        break;
      case Status.ERROR:
        emit(LeaderboardError(message: response.message));
        break;
    }
  }
}
