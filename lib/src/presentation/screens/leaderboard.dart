import 'package:daily_mcq/src/services/bloc/leaderboard/leaderboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/leaderboard.dart';
import '../../utils/global_themes.dart';
import '../widgets/dsc_title.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({
    Key key,
  }) : super(key: key);

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<Result> result;
  LeaderboardCubit _cubit;
  @override
  void initState() {
    _cubit = BlocProvider.of<LeaderboardCubit>(context);
    // _cubit.getLeaderboard();
    result = _cubit.results;
    // result = ModalRoute.of(context).settings.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: primaryColor,
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            color: Theme.of(context).canvasColor,
            disabledColor: Theme.of(context).canvasColor,
            onPressed: null,
          )
        ],
        title: DscTitleWidget(),
      ),
      body: BlocBuilder<LeaderboardCubit, LeaderboardState>(
        cubit: _cubit,
        builder: (context, state) {
          if (state is LeaderboardLoading) {
            return buildLoading();
          }
          if (state is LeaderboardSuccess) {
            return buildLoaded();
          }
          return buildLoaded();
        },
      ),
    );
  }

  Center buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Future<Null> _refreshFunc() async {
    print('refreshing');
  }

  Widget buildLoaded() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Hero(
        tag: 'leaderboard',
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius8,
          ),
          elevation: 2.3,
          child: RefreshIndicator(
            onRefresh: () {
              _cubit.getLeaderboard();
              return Future.delayed(Duration(seconds: 2), () {
                return _refreshFunc();
              });
            },
            child: Container(
              // padding: EdgeInsets.all(16),
              child: Scrollbar(
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                      sliver: SliverToBoxAdapter(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Leaderboard',
                            style: boldHeading,
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      sliver: result.length == 0
                          ? SliverToBoxAdapter(
                              child: buildLoading(),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return ListTile(
                                    leading: Text("${result[index].position}"),
                                    title: Text(result[index].username),
                                    trailing: Text("${result[index].marks.floor()}"),
                                  );
                                },
                                childCount: result.length,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
