import 'package:daily_mcq/src/data/models/history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../data/repos/question.dart';
import '../../services/bloc/history/history_cubit.dart';
import '../../utils/global_themes.dart';
import '../widgets/my_snackbar.dart';

class HistoryScreen extends StatelessWidget {
  final QuestionType questionType;

  const HistoryScreen(this.questionType);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: primaryColor,
        ),
        title: Text('Response History'),
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => HistoryCubit(),
        child: HistoryBuilder(questionType),
      ),
    );
  }
}

class HistoryBuilder extends StatefulWidget {
  final QuestionType questionType;

  const HistoryBuilder(this.questionType);
  @override
  _HistoryBuilderState createState() => _HistoryBuilderState();
}

class _HistoryBuilderState extends State<HistoryBuilder> {
  HistoryCubit _historyCubit;

  @override
  void initState() {
    super.initState();
    _historyCubit = BlocProvider.of<HistoryCubit>(context);
    _historyCubit.getHistory(widget.questionType);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _historyCubit,
      builder: (context, state) {
        if (state is HistoryInitial) {
          return buildLoading();
        } else if (state is HistoryLoading) {
          return buildLoading();
        } else if (state is HistoryError) {
          Future.delayed(Duration(seconds: 2), () {
            Scaffold.of(context).showSnackBar(getMySnackBar(
              state.message,
              color: Colors.redAccent,
            ));
          });
          return buildLoading();
        } else if (state is HistoryLoaded) {
          List<History> history = state.history.history;
          history = List.from(history.reversed);

          return (history.length > 0)
              ? ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    height: 0,
                  ),
                  itemCount: history.length,
                  itemBuilder: (context, index) => ExpansionTile(
                    backgroundColor: Colors.white,
                    trailing: history[index].isEvaluated
                        ? CircleAvatar(
                            radius: 12,
                            foregroundColor: Colors.white,
                            backgroundColor:
                                (history[index].correctAnswer == history[index].yourAnswer)
                                    ? primaryColor
                                    : Color(0xFFFDDF7C),
                            child: Icon(
                              (history[index].correctAnswer == history[index].yourAnswer)
                                  ? Icons.done
                                  : Icons.close,
                              size: 16,
                              color: history[index].correctAnswer == history[index].yourAnswer
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          )
                        : Icon(Icons.access_time),
                    title: Text(
                      history[index].yourAnswer,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: Text(history[index].marks.toString() ?? ""),
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.all(8),
                        child: MarkdownBody(
                          data: history[index].question,
                        ),
                      ),
                      ListTile(
                        title: Text('Your answer'),
                        subtitle: Text(history[index].yourAnswer ?? ""),
                      ),
                      if (history[index].questionType == 0)
                        ListTile(
                          title: Text('Correct Answer'),
                          subtitle: Text(history[index].correctAnswer ?? ""),
                        ),
                      history[index].isEvaluated
                          ? ListTile(
                              title: Text('Marks awarded'),
                              subtitle: Text(history[index].marks.toString() ?? ""),
                            )
                          : ListTile(
                              title: Text('Under Evaluation'),
                              subtitle: Text('Marks will be awarded shortly'),
                            ),
                    ],
                  ),
                )
              : Center(
                  child: Text('Not Found'),
                );
        }
        return Container();
      },
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
