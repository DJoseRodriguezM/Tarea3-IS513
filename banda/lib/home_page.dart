import 'package:flutter/material.dart';
import 'package:banda/componentes/votar_page.dart';
import 'package:banda/componentes/registrar_page.dart';



class HomePage extends StatefulWidget {
  HomePage({Key? key, this.currentIndex = 0}) : super(key: key);

  int currentIndex;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          controller: pageController,
          onPageChanged: (value) {
            widget.currentIndex = value;
            setState(() {});
          },
          children: const [
            VotarPage(),
            RegistrarPage(),
          ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: (index) {
          widget.currentIndex = index;

          pageController.animateToPage(
            index,
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 300),
          );
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/votar.png', width: 35, height: 35),
            label: 'Votar',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/registrar.png', width: 35, height: 35),
            label: 'Registrar',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      ),
    );
  }
}
