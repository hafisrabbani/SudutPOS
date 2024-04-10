import 'package:flutter/material.dart';
import 'package:sudut_pos/view/themes/colors.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final void Function(String) onChanged;
  final void Function() onClear;
  final void Function() onSearch;

  const CustomSearchBar({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.onClear,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color.fromARGB(219, 240, 240, 240),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    color: mutedColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          IconButton(
            onPressed: onClear,
            icon: const Icon(Icons.clear),
          ),
          IconButton(
            onPressed: onSearch,
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}