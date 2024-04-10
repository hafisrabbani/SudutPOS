import 'package:flutter/material.dart';

class BaseTemplate extends StatefulWidget {
  const BaseTemplate({super.key});

  @override
  State<BaseTemplate> createState() => _BaseTemplateState();
}

class _BaseTemplateState extends State<BaseTemplate> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Base Template'),
      ),
      body: const Center(
        child: Text('Base Template'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _getPage(int index){
    switch(index){
      case 0:
        return const Center(
          child: Text('Home'),
        );
      case 1:
        return const Center(
          child: Text('Business'),
        );
      case 2:
        return const Center(
          child: Text('School'),
        );
      default:
        return const Center(
          child: Text('Home'),
        );
    }
  }
}
