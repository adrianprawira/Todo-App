import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:muslimpedia_todo_flutter/constants/const.dart';
import 'package:muslimpedia_todo_flutter/model/authentication/authentication_detail.dart';
import 'package:muslimpedia_todo_flutter/widgets/task_tile.dart';

class HomePageBody extends StatelessWidget {
  final taskList, authDetail;

  HomePageBody({@required this.taskList, @required this.authDetail});

  getCompletedTaskCount(List tasks) {
    return tasks.where((task) => task.status == 1).toList().length;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Text("${authDetail.name}'s Tasks List",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: aPrimaryColorLightest),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            '${getCompletedTaskCount(taskList)} of ${taskList.length}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: taskList.length,
            itemBuilder: (context, index) {
              return TaskTile(
                task: taskList[index],
              );
            },
          ),
        )
      ],
    );
  }
}
