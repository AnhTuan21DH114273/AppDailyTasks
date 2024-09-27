import 'package:app_tasks/main.dart';
import 'package:flutter/material.dart';

class AddTasks extends StatefulWidget {
  const AddTasks({super.key});

  @override
  State<AddTasks> createState() => _AddTasksState();
}

class _AddTasksState extends State<AddTasks> {
  final tasksNameController = TextEditingController();
  final tasksDateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final typeController = TextEditingController();
  List<String> _dropdownItems = ['Offline', 'Online'];
  String? selectedValue;
  String? status = "Chưa hoàn thành";
  Future<void> createTasks() async {
    await supabase.from('Tasks').insert({
      'task_name': tasksNameController.text.trim(),
      'task_date': tasksDateController.text.trim(),
      'start_time': startTimeController.text.trim(),
      'end_time': endTimeController.text.trim(),
      'type': typeController.text.trim(),
      'status': status,
      'created_at': DateTime.now().toIso8601String(),
    });
    if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tạo Công Việc Thành Công"),
        backgroundColor: Colors.green,
        )
      );
      Navigator.pop(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm Công Việc"),
        centerTitle: true,
        backgroundColor: Colors.black12,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 390,
              child: TextFormField(
                controller: tasksNameController,
                decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: "Tên Công Việc",
                    icon: Icon(
                      Icons.task_alt_rounded,
                      color: Colors.black,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    )),
              ),
            ),
            SizedBox(
              width: 390,
              child: TextFormField(
                controller: tasksDateController,
                decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: "Ngày vào làm",
                    icon: Icon(
                      Icons.calendar_today,
                      color: Colors.black,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    )),
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2003),
                      lastDate: DateTime(2100));
                  if (pickedDate != null) {
                    setState(() {
                      tasksDateController.text =
                          pickedDate.toIso8601String().split("T")[0];
                    });
                  }
                },
              ),
            ),
            SizedBox(
              width: 390,
              child: TextFormField(
                controller: startTimeController,
                decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: "Thời gian bắt đầu",
                    icon: Icon(
                      Icons.calendar_today,
                      color: Colors.black,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    )),
                  onTap: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    initialTime: TimeOfDay.now(),
                    initialEntryMode: TimePickerEntryMode.dial,
                    context: context,
                  );
                  if (pickedTime != null) {
                    setState(() {
                      startTimeController.text = pickedTime.format(context);
                    });
                  }
                },
              ),
            ),
            SizedBox(
              width: 390,
              child: TextFormField(
                controller: endTimeController,
                decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: "Thời gian kết thúc",
                    icon: Icon(
                      Icons.calendar_today,
                      color: Colors.black,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    )),
                onTap: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    initialTime: TimeOfDay.now(),
                    initialEntryMode: TimePickerEntryMode.dial,
                    context: context,
                  );
                  if (pickedTime != null) {
                    setState(() {
                      endTimeController.text = pickedTime.format(context);
                    });
                  }
                },
              ),
            ),
            SizedBox(
              width: 390,
              child: TextFormField(
                controller: typeController,
                decoration: InputDecoration(
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: "Chọn kiểu",
                  labelStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  icon: const Icon(
                      Icons.online_prediction,
                      color: Colors.black,
                  ),
                  suffixIcon: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedValue,
                      items: _dropdownItems.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          typeController.text = newValue ?? '';
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () {
                createTasks();
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white24),
                minimumSize: WidgetStatePropertyAll(Size(400, 40))
              ), 
              child: const Text(
                "Thêm Công Việc",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
