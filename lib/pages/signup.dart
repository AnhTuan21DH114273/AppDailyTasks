import 'package:app_tasks/main.dart';
import 'package:app_tasks/pages/signin.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(
          color: Colors.white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 190,
            ),
            const Text(
              "ĐĂNG KÝ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
            SizedBox(
              width: 390,
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: "Email",
                    icon: Icon(
                      Icons.person,
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
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: "Mật khẩu",
                    icon: Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                  )),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: ()async {
                  try{
                    await supabase.auth.signUp(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                    if(mounted){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Đăng Ký Thành Công"),
                        backgroundColor: Colors.green)
                      );
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Signin()));
                    }
                  } on AuthException catch (e){
                    print(e);
                  }
                },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.black26),
                minimumSize: WidgetStatePropertyAll(Size(400, 40))
              ), 
              child: const Text(
                "Đăng ký",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
                )
            )
          ],
        ),
      ),
    );
  }
}