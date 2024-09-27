import 'package:app_tasks/main.dart';
import 'package:app_tasks/tasks/add_tasks.dart';
import 'package:app_tasks/tasks/edit_tasks.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  late Stream<List<Map<String, dynamic>>> tasksStream;
  int successCount = 0;
  int almostSuccessCount = 0;
  int unsuccessCount = 0;
  @override
  void initState() {
    super.initState();
    _initializeStream();
    countSuccess();
    countAlmostSuccess();
    countUnsuccess();
  }

  void _initializeStream() {
    final userId = supabase.auth.currentUser!.id;
    tasksStream = supabase.from('Tasks').stream(primaryKey: ['id']).eq("user_id", userId);
  }

  Future<void> _refreshStream() async {
    _initializeStream();
  }
  Future<void> countSuccess() async {
    final response = await supabase
        .from('Tasks') 
        .select()
        .eq('status', 'Đã hoàn thành');

    setState(() {
      successCount = response.length;
    });
  }
  Future<void> countAlmostSuccess() async {
    final response = await supabase
        .from('Tasks') 
        .select()
        .eq('status', 'Sắp hoàn thành');

    setState(() {
      almostSuccessCount = response.length;
    });
  }
  Future<void> countUnsuccess() async {
    final response = await supabase
        .from('Tasks') 
        .select()
        .eq('status', 'Chưa hoàn thành');

    setState(() {
      unsuccessCount = response.length;
    });
  }
  Future<void> deleteProduct(int taskId) async {
    try {
      await supabase.from('Tasks').delete().eq('id', taskId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Công việc đã được xoá thành công')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xoá công việc thất bại: $e')),
      );
    }
  }
  void _showDeleteConfirmationDialog(int productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xoá'),
          content: const Text('Bạn có chắc chắn muốn xoá công việc này?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Huỷ'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
                deleteProduct(productId); 
              },
              child: const Text('Xoá'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Công Việc",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshStream,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddTasks()));
            }, 
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Biểu đồ thống kê các công việc chưa hoàn thành, sắp hoàn thành và đã hoàn thành",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(
              height: 230,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Text(
                    "Tổng số công việc",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  PieChart(
                    swapAnimationDuration: const Duration(seconds: 2),
                    swapAnimationCurve: Curves.easeInOutQuint,
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: double.parse(unsuccessCount.toDouble().toString()),
                          color: Colors.red,
                        ),
                        PieChartSectionData(
                          value: double.parse(almostSuccessCount.toDouble().toString()),
                          color: Colors.yellow.shade900,
                        ),
                        PieChartSectionData(
                          value: double.parse(successCount.toDouble().toString()),
                          color: Colors.green,
                        )
                      ]
                    )
                  ),
                ],
              )
            ),
            SizedBox(height: 30,),
            const Text(
              "Danh sách công việc",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold
              ),
            ),
            StreamBuilder(
              stream: tasksStream, 
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(),);
                }
                final tasks = snapshot.data!;
                return Expanded(child: RefreshIndicator(
                  onRefresh: () async {
                    Future.delayed(const Duration(seconds: 1));
                    setState(() {
                      _refreshStream;
                    });
                  },
                  child: ReorderableListView.builder(
                    onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final item = tasks.removeAt(oldIndex);
                      tasks.insert(newIndex, item);
                    });
                  },
                  itemCount: tasks.length,
                  itemBuilder: (context, index){
                    final task = tasks[index];
                    task['id'].toString();
                    return Padding(
                      key: ValueKey(task),
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        key: ValueKey(task),
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          GestureDetector(
                            key: ValueKey(task),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditTasks(editTask: task["id"])));
                            },
                            child: Container(
                            key: ValueKey(task),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.black87
                            ),
                            child: ListTile(
                              key: ValueKey(task),
                              title: RichText(
                                key: ValueKey(task),
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
                                    key: ValueKey(task),
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
                                          color: Colors.white,
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
                                      text: 'Địa điểm: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white70)),
                                  TextSpan(
                                      text: task['type'],
                                      style: const TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      )),
                                  
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
                              trailing: IconButton(onPressed: (){
                                    _showDeleteConfirmationDialog(task['id']);
                                  }, 
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                              )),
                            ),
                          ),
                        ),
                        ],
                      ),
                    );
                  }
                )
                ));
              }),
          ],
        ),
      ),
    );
  }
}