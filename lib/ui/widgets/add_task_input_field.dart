import 'package:daily_reminder/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskInputField extends StatelessWidget {
  final String? title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  const TaskInputField(
      {Key? key,
      required this.title,
      required this.hint,
      required this.controller,
      required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title!,
            style: titleStyle,
          ),
          Container(
            margin: const EdgeInsets.only(top: 6.0),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            width: MediaQuery.of(context).size.width,
            height: 52.0,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(12.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: TextFormField(
                  readOnly: widget == null ? false : true,
                  autofocus: false,
                  cursorColor:
                      Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                  controller: controller,
                  style: subTitleStyle,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: subTitleStyle,
                    border: InputBorder. none,
                    focusedBorder: InputBorder. none,
                    enabledBorder: InputBorder. none,
                  ),
                )),
                widget == null ? Container() : Container(child: widget,)
              ],
            ),
          )
        ],
      ),
    );
  }
}
