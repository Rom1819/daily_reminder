import 'package:daily_reminder/controllers/task_controller.dart';
import 'package:daily_reminder/models/task.dart';
import 'package:daily_reminder/ui/theme.dart';
import 'package:daily_reminder/ui/widgets/add_task_input_field.dart';
import 'package:daily_reminder/ui/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _endTime = '9:30 PM';
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];
  String _selectedRepeat = "None";
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Monthly",
    "Yearly",
  ];

  int _selectedColor = 0;

  final TaskController _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appbar(context),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Add Task",
              style: headingStyle,
            ),
            TaskInputField(
              title: "Title",
              hint: "Enter Your Title",
              controller: _titleController,
              widget: null,
            ),
            TaskInputField(
              title: "Note",
              hint: "Enter Your Note",
              controller: _noteController,
              widget: null,
            ),
            TaskInputField(
              title: "Date",
              hint: DateFormat.yMd().format(_selectedDate),
              controller: null,
              widget: IconButton(
                icon: const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey,
                ),
                onPressed: () {
                  _getDateFromUser();
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: TaskInputField(
                  title: 'Start Time',
                  hint: _startTime,
                  controller: null,
                  widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(isStartTime: true);
                      },
                      icon: const Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      )),
                )),
                const SizedBox(width: 12.0),
                Expanded(
                    child: TaskInputField(
                  title: 'End Time',
                  hint: _endTime,
                  controller: null,
                  widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(isStartTime: false);
                      },
                      icon: const Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      )),
                )),
              ],
            ),
            TaskInputField(
              title: "Remind",
              hint: "$_selectedRemind  minutes early",
              controller: null,
              widget: DropdownButton(
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
                iconSize: 32.0,
                elevation: 4,
                style: subTitleStyle,
                items: remindList.map<DropdownMenuItem<String>>(
                  (int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  },
                ).toList(),
                underline: Container(
                  height: 0.0,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRemind = int.parse(newValue!);
                  });
                },
              ),
            ),
            TaskInputField(
              title: "Repeat",
              hint: _selectedRepeat,
              controller: null,
              widget: DropdownButton(
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
                iconSize: 32.0,
                elevation: 4,
                style: subTitleStyle,
                items: repeatList.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  },
                ).toList(),
                underline: Container(
                  height: 0.0,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRepeat = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 22.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _colorBar(),
                MyButton(label: "Create Task", onTap: () => _validateData()),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  _appbar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        child: Icon(
          Icons.arrow_back_ios,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
        onTap: () {
          Get.back();
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

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1717),
        lastDate: DateTime(2222));

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        print(_selectedDate);
      });
    } else {
      print('Something went wrong!');
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formattedTime = pickedTime.format(context);

    if (pickedTime == null) {
      print('Time Canceled!');
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formattedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formattedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          //  _startTime --> 10:30 AM
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
        ));
  }

  _colorBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        const SizedBox(
          height: 6.0,
        ),
        Wrap(
          children: List<Widget>.generate(4, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                  print('$index');
                });
              },
              child: CircleAvatar(
                radius: 14,
                backgroundColor: index == 0
                    ? primaryClr
                    : index == 1
                        ? pinkClr
                        : index == 2
                            ? yellowClr
                            : tealClr,
                child: _selectedColor == index
                    ? const Icon(
                        Icons.done,
                        color: white,
                        size: 16.0,
                      )
                    : Container(),
              ),
            );
          }),
          spacing: 4.0,
        ),
      ],
    );
  }

  _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Warning!", "All fields are required!",
          backgroundColor: white,
          colorText: pinkClr,
          borderColor: Colors.red,
          borderWidth: 1.5,
          duration: const Duration(seconds: 3),
          padding: const EdgeInsets.all(8.0),
          snackPosition: SnackPosition.BOTTOM,
          icon: const Icon(Icons.warning_amber_rounded));
    }
  }

  _addTaskToDb() async {
    int value = await _taskController.addTask(
        task: Task(
      title: _titleController.text,
      note: _noteController.text,
      isCompleted: 0,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      color: _selectedColor,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
    ));
    print('Data insertion ID : $value');
  }
}
