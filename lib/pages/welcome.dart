import 'package:app_tasks/pages/signin.dart';
import 'package:app_tasks/pages/signup.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 100,),
          Image.asset("assets/images/Logo.png",),
          const Text("Xin chào đến ứng dụng nhiệm vụ của chúng tôi",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 30,),
          TextButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Signin()));
            },
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.black26),
              minimumSize: WidgetStatePropertyAll(Size(400, 40))
            ), 
            child: const Text(
              "Đăng nhập",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),
              )
          ),
          const SizedBox(height: 30,),
          TextButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Signup()));
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
    );
  }
}