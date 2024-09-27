import 'package:app_tasks/main.dart';
import 'package:flutter/material.dart';

class EditTasks extends StatefulWidget {
  final int editTask;
  const EditTasks({super.key, required this.editTask});

  @override
  State<EditTasks> createState() => _EditTasksState();
}

class _EditTasksState extends State<EditTasks> {
  final tasksNameController = TextEditingController();
  final tasksDateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final typeController = TextEditingController();
  final statusController = TextEditingController();
  List<String> _dropdownType = ['Offline', 'Online'];
  List<String> _dropdownStatus = ['Sắp hoàn thành', 'Đã hoàn thành'];
  String? selectedValue;

  Future<void> _getProfile(int id) async {
    final data =
        await supabase.from('Tasks').select().eq('id', id).single();
    setState(() {
      tasksNameController.text = data['task_name'];
      tasksDateController.text = data['task_date'];
      startTimeController.text = data['start_time'];
      endTimeController.text = data['end_time'];
      typeController.text = data['type'];
      statusController.text = data['status'];
    });
  }
  Future<void> _updateProfile() async {
    await supabase.from('Tasks').update({
      'task_name': tasksNameController.text.trim(),
      'task_date': tasksDateController.text.trim(),
      'start_time': startTimeController.text.trim(),
      'end_time': endTimeController.text.trim(),
      'type': typeController.text.trim(),
      'status': statusController.text.trim(),
    }).eq('id', widget.editTask);
    if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cập Nhật Công Việc Thành Công"),
        backgroundColor: Colors.green,
        )
      );
    }
  }
  @override
  void dispose() {
    super.dispose();
    tasksNameController.dispose();
    tasksDateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    typeController.dispose();
    statusController.dispose();
  }
  @override
  void initState() {

    super.initState();
    _getProfile(widget.editTask);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cập nhật Công Việc"),
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
                    ),
                    labelStyle: TextStyle(
                      fontSize: 18,
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
                      
                    ),
                    labelStyle: TextStyle(
                      fontSize: 18,
                      
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
                      Icons.access_time_rounded,
                      
                    ),
                    labelStyle: TextStyle(
                      fontSize: 18,
                      
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
                      Icons.access_time_rounded,
                      
                    ),
                    labelStyle: TextStyle(
                      fontSize: 18,
                      
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
                      
                    ),
                  icon: const Icon(
                      Icons.online_prediction,
                      
                  ),
                  suffixIcon: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedValue,
                      items: _dropdownType.map((String value) {
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
            SizedBox(
              width: 390,
              child: TextFormField(
                controller: statusController,
                decoration: InputDecoration(
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: "Trạng thái",
                  labelStyle: const TextStyle(
                      fontSize: 18,
                      
                    ),
                  icon: const Icon(
                      Icons.online_prediction,
                      
                  ),
                  suffixIcon: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedValue,
                      items: _dropdownStatus.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          statusController.text = newValue ?? '';
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
                _updateProfile();
                Navigator.pop(context);
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white24),
                minimumSize: WidgetStatePropertyAll(Size(400, 40))
              ), 
              child: const Text(
                "Cập nhật",
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