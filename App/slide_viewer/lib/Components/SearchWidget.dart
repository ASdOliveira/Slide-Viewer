import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 45,
      child: TextField(
        maxLines: 1,
        textAlignVertical: TextAlignVertical.bottom,
        cursorColor: Colors.white,
        style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: Color(0xFFFFFFFF)),
        decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF9C3C81),
            prefixIcon: const Icon(Icons.search),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            hintText: 'Pesquisar',
            hintStyle: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Color(0xFFFFFFFF)),
            focusColor: const Color(0xFFFFFFFF),
            prefixIconColor: Colors.white,
            hoverColor: const Color(0xFF9C3C81)),
      ),
    );
  }
}
