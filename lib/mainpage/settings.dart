// ignore_for_file: use_build_context_synchronously

import 'package:app_tasks/main.dart';
import 'package:app_tasks/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  Future<void> _getProfile() async {
    final userId = supabase.auth.currentUser!.id;
    final data =
        await supabase.from('profiles').select().eq('id', userId).single();
    setState(() {
      usernameController.text = data['username'];
      firstNameController.text = data['first_name'];
      lastNameController.text = data['last_name'];
    });
  }

  Future<void> _updateProfile() async {
    final userName = usernameController.text.trim();
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final user = supabase.auth.currentUser;
    await supabase.from('profiles').update({
      'username': userName,
      'first_name': firstName,
      'last_name': lastName,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', user!.id);
    if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cập Nhật Tài Khoản Thành Công"))
      );
    }
  }

  @override
  void dispose() {

    super.dispose();
    usernameController.dispose();
    lastNameController.dispose();
    firstNameController.dispose();
  }

  @override
  void initState() {

    super.initState();
    _getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Cài Đặt",
        style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if(mounted){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đăng Xuất Thành Công"),
                  backgroundColor: Colors.green)
                );
                Navigator.pop(context);
              }
            }, 
            icon: const Icon(Icons.logout)
          ),
        ],
      ),
      body:
          Consumer<UiProvider>(builder: (context, UiProvider notifier, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text(
                "Chế độ sáng/tối",
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              trailing: Switch(
                  value: notifier.isDark,
                  onChanged: (value) => notifier.changeTheme()),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 280),
              child: Text(
                "Tài Khoản",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 400,
              child: TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'UserName',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: 400,
              child: TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Họ',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: 400,
              child: TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Tên',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  )),
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _updateProfile,
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
        );
      }),
    );
  }
}
