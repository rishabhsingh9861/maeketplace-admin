import 'package:adminmarket/authenticate/login.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              'Images/Background.jpg',
            ),
            fit: BoxFit.fill),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  "Food for \nEveryone  ",
                  style: TextStyle(
                      fontSize: 49,
                      fontFamily: 'Carter One',
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              SizedBox(
                height: 80,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                  print('Get Started');
                },
                child: Container(
                  height: 50,
                  width: 130,
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(blurRadius: 30)],
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF6D773E),
                  ),
                  child: const Center(
                      child: Text(
                    'Get started',
                    style: TextStyle(
                      fontFamily: 'Mukta',
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
