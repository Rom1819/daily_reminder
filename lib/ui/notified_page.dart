import 'package:daily_reminder/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotifiedPage extends StatelessWidget {
  final String? label;
  const NotifiedPage({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? Colors.grey[600] : white,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Get.isDarkMode ? white : Colors.grey,
            )),
        title: Text(label.toString().split("|")[0],
            style: const TextStyle(color: black)),
      ),
      body: Center(
        child: Container(
          width: 300.0,
          height: 400.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Get.isDarkMode ? white : Colors.grey[400],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(label.toString().split("|")[1],
                  style: TextStyle(
                    color: Get.isDarkMode ? black : white,
                    fontSize: 30.0,
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
