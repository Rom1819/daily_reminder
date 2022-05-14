import 'package:daily_reminder/controllers/task_controller.dart';
import 'package:daily_reminder/models/task.dart';
import 'package:daily_reminder/services/notification_services.dart';
import 'package:daily_reminder/services/theme_services.dart';
import 'package:daily_reminder/ui/add_task_page.dart';
import 'package:daily_reminder/ui/theme.dart';
import 'package:daily_reminder/ui/widgets/button.dart';
import 'package:daily_reminder/ui/widgets/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  var notifyHelper;

  @override
  void initState() {
    super.initState();
    _taskController.getTask();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          children: [
            _addTaskBar(),
            _addDateBar(),
            const SizedBox(
              height: 12.0,
            ),
            _showTasks(),
          ],
        ),
      ),
    );
  }

  _appbar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        child: Icon(
          Get.isDarkMode
              ? Icons.wb_sunny_outlined
              : Icons.nightlight_round_outlined,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
        onTap: () {
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
            title: "Theme Changed!",
            body: Get.isDarkMode
                ? "Activated Light Theme"
                : "Activated Dark Theme",
          );
        //  notifyHelper.scheduledNotification();
        },
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage("assets/images/profile.jpg"),
        ),
        SizedBox(width: 20.0)
      ],
    );
  }

  _addTaskBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: subHeadingStyle,
            ),
            Text(
              "Today",
              style: headingStyle,
            ),
          ],
        ),
        MyButton(
            label: "+ Add Task",
            onTap: () async {
              await Get.to(() => const AddTaskPage());
              _taskController.getTask();
            })
      ],
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20.0,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14.0,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
            Task task = _taskController.taskList[index];
            if(task.repeat == 'Daily') {
              DateTime date = DateFormat.jm().parse(task.startTime.toString());
              var myTime = DateFormat("HH:mm").format(date);
              notifyHelper.scheduledNotification(
                int.parse(myTime.toString().split(":")[0]),
                int.parse(myTime.toString().split(":")[1]),
                task
              );
              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showBottomSheet(
                                    context, task);
                              },
                              child: TaskTile(task),
                            ),
                          ],
                        ),
                      )));
            }
            if(task.date == DateFormat.yMd().format(_selectedDate)) {
              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showBottomSheet(
                                    context, task);
                              },
                              child: TaskTile(task),
                            ),
                          ],
                        ),
                      )));
            } else {
              return Container();
            }
            });
      }),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 6.0),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * 0.25
          : MediaQuery.of(context).size.height * 0.36,
      decoration: BoxDecoration(
        color: Get.isDarkMode ? darkGreyClr : white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        children: [
          Container(
            width: 120.0,
            height: 6.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0),
              color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[600],
            ),
          ),
          const Spacer(),
          task.isCompleted == 1
              ? Container()
              : _bottomSheetButton(
                  label: "Task Completed",
                  onTap: () {
                    _taskController.markTaskCompleted(task.id!);
                    Get.back();
                  },
                  color: primaryClr,
                  context: context),
          const SizedBox(
            height: 6.0,
          ),
          _bottomSheetButton(
              label: "Delete Task",
              onTap: () {
                _taskController.deleteTask(task);
                Get.back();
              },
              color: Colors.red[300]!,
              context: context),
          const SizedBox(
            height: 16.0,
          ),
          _bottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              color: Colors.red,
              isClose: true,
              context: context),
          const SizedBox(
            height: 8.0,
          )
        ],
      ),
    ));
  }

  _bottomSheetButton(
      {required String label,
      required Function() onTap,
      required Color color,
      bool isClose = false,
      required BuildContext context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 50.0,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2.0,
            color: isClose == true
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : color,
          ),
          borderRadius: BorderRadius.circular(16.0),
          color: isClose == true ? Colors.transparent : color,
        ),
        child: Center(
            child: Text(
          label,
          style: isClose ? titleStyle : titleStyle.copyWith(color: white),
        )),
      ),
    );
  }
}
