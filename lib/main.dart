import 'package:app_tasks/pages/welcome.dart';
import 'package:app_tasks/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://smtxqxtvvylyqobegzoi.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNtdHhxeHR2dnlseXFvYmVnem9pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjcyNDc0NjIsImV4cCI6MjA0MjgyMzQ2Mn0.Lan9iscO6MSbbRYC2V05We_YZB4s-0O8DCSswC7JqoE',
    );
  runApp(const MainApp());
}
final supabase = Supabase.instance.client;
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context)=>UiProvider()..init(),
      child: Consumer<UiProvider>(
        builder: (context, UiProvider notifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Daily Tasks',
            themeMode: notifier.isDark? ThemeMode.dark : ThemeMode.light,
            darkTheme: notifier.isDark? notifier.darkTheme : notifier.lightTheme,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: const Welcome(),
          );
        }
      ),
    );
  }
}
