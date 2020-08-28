import 'package:daily_mcq/src/data/models/question.dart';
import 'package:daily_mcq/src/presentation/widgets/my_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/bloc/question/question_bloc.dart';
import '../../../utils/global_themes.dart';
import '../../widgets/dsc_title.dart';

class NewWeeklyChallengeScreen extends StatelessWidget {
  static const routename = "/new-weekly-challenge";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuestionBloc(),
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: primaryColor,
          ),
          elevation: 0,
          title: DscTitleWidget(),
          actions: [
            IconButton(
              icon: Icon(Icons.history),
              onPressed: () {},
            ),
          ],
        ),
        body: NewWeeklyChallengeBuilder(),
      ),
    );
  }
}

class NewWeeklyChallengeBuilder extends StatefulWidget {
  @override
  _NewWeeklyChallengeBuilderState createState() =>
      _NewWeeklyChallengeBuilderState();
}

class _NewWeeklyChallengeBuilderState extends State<NewWeeklyChallengeBuilder> {
  QuestionBloc _questionBloc;

  @override
  void initState() {
    super.initState();
    _questionBloc = BlocProvider.of<QuestionBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuestionBloc, QuestionState>(
      cubit: _questionBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is QuestionInitial) {
          _questionBloc.add(GetWeeklyQuestion());
          return buildLoading(context);
        } else if (state is QuestionLoading) {
          return buildLoading(context);
        } else if (state is GetWeeklyQuestionSucess) {
          return buildUI(context, state.question);
        } else if (state is GetWeeklyQuestionError) {
          Future.delayed(Duration(seconds: 2), () {
            Scaffold.of(context).showSnackBar(getMySnackBar(
              state.message,
              color: Colors.red,
            ));
          });
          return buildLoading(context);
        }
        return Container();
      },
    );
  }

  Widget buildUI(BuildContext context, Question question) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        padding: EdgeInsets.all(16),
        child: Hero(
          tag: 'weekly_challenge_new',
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius8.add(BorderRadius.circular(3)),
            ),
            elevation: 2.3,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: CupertinoScrollbar(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Text(
                        'Weekly Challenge',
                        style: boldHeading,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Question',
                          style: boldHeading.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        "${question.question.questionBody}",
                        style: greyText.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Your Answer*',
                          style: boldHeading.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        minLines: 1,
                        maxLines: 2,
                        toolbarOptions: ToolbarOptions(
                          copy: true,
                          cut: true,
                          paste: true,
                          selectAll: true,
                        ),
                        decoration: InputDecoration(
                          hintText: "Give a short answer",
                          border: OutlineInputBorder(
                            borderRadius: borderRadius8,
                            borderSide: BorderSide(
                              color: Colors.grey[100].withOpacity(0.1),
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Extra Description',
                          style: boldHeading.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        minLines: 1,
                        maxLines: 2,
                        toolbarOptions: ToolbarOptions(
                          copy: true,
                          cut: true,
                          paste: true,
                          selectAll: true,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: borderRadius8,
                            borderSide: BorderSide(
                              color: Colors.grey[100].withOpacity(0.1),
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: RaisedButton(
                          elevation: 0,
                          child: Text(
                            'SUBMIT',
                            style: boldHeading.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoading(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        padding: EdgeInsets.all(16),
        child: Hero(
          tag: 'weekly_challenge_new',
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius8.add(BorderRadius.circular(3)),
            ),
            elevation: 2.3,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: CupertinoScrollbar(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Text(
                        'Weekly Challenge',
                        style: boldHeading,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Question',
                          style: boldHeading.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      LinearProgressIndicator(),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Your Answer*',
                          style: boldHeading.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        enabled: false,
                        minLines: 1,
                        maxLines: 2,
                        toolbarOptions: ToolbarOptions(
                          copy: true,
                          cut: true,
                          paste: true,
                          selectAll: true,
                        ),
                        decoration: InputDecoration(
                          hintText: "Give a short answer",
                          border: OutlineInputBorder(
                            borderRadius: borderRadius8,
                            borderSide: BorderSide(
                              color: Colors.grey[100].withOpacity(0.1),
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Extra Description',
                          style: boldHeading.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        minLines: 1,
                        maxLines: 2,
                        enabled: false,
                        toolbarOptions: ToolbarOptions(
                          copy: true,
                          cut: true,
                          paste: true,
                          selectAll: true,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: borderRadius8,
                            borderSide: BorderSide(
                              color: Colors.grey[100].withOpacity(0.1),
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: RaisedButton(
                          elevation: 0,
                          child: Text(
                            'SUBMIT',
                            style: boldHeading.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: null,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}