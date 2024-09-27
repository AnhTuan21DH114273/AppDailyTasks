import 'package:app_tasks/main.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime selectedDay;
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
    fetchData(selectedDay);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selectedDay = day;
    });
  }

  Future<void> fetchData(DateTime date) async {
    final userId = supabase.auth.currentUser!.id;
    final response =
        await supabase.from('Tasks').select().eq('task_date', date.toString()).eq("user_id", userId);
    if (mounted) {
      setState(() {
        data = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lịch công việc",
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TableCalendar(
              focusedDay: selectedDay,
              headerStyle:
                  const HeaderStyle(
                    formatButtonVisible: false, 
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                )),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.green.shade900),
                weekendStyle: TextStyle(color: Colors.red.shade800)
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.green.shade300,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.green.shade900,
                ),
                selectedTextStyle: const TextStyle(
                  color: Colors.white
                )
              ),
              rowHeight: 45,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  this.selectedDay = selectedDay;
                  fetchData(selectedDay);
                });
              },
              selectedDayPredicate: (day) => isSameDay(day, selectedDay),
              firstDay: DateTime.utc(2000, 01, 01),
              lastDay: DateTime.utc(2030, 01, 01),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Ngày chọn: ${selectedDay.toString().split(" ")[0]}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
              ),
            Expanded(
              child: ReorderableListView.builder(
                onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final item = data.removeAt(oldIndex);
                      data.insert(newIndex, item);
                    });
                },
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final task = data[index];
                  task['id'].toString();
                  return Padding(
                    key: ValueKey(task),
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            key: ValueKey(task),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.black87
                            ),
                            child: ListTile(
                              key: ValueKey(task),
                              title: RichText(
                                text: TextSpan(children: <TextSpan>[
                                  const TextSpan(
                                    text: "Tên công việc: ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70
                                      )
                                  ),
                                  TextSpan(
                                    text: task['task_name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue)
                                  ),
                                ])
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(children: <TextSpan>[
                                    const TextSpan(
                                        text: 'Thời gian: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white70
                                            )),
                                    TextSpan(
                                        text: task['start_time'],
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        )),
                                    const TextSpan(
                                        text: " - ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        )),
                                    TextSpan(
                                        text: task['end_time'],
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ))
                                  ])),
                                RichText(
                                    text: TextSpan(children: <TextSpan>[
                                  const TextSpan(
                                      text: 'Trạng thái: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white70)),
                                  TextSpan(
                                      text: task['status'],
                                      style: const TextStyle(
                                        color: Colors.yellow,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      )),
                                  
                                ])),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
