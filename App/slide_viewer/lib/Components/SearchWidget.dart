import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField(
      cursorColor: Colors.white,
      style: TextStyle(
          fontSize: 16,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          color: Color(0xFFFFFFFF)),
      decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFF9C3C81),
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
          hintText: 'Pesquisar',
          hintStyle: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Color(0xFFFFFFFF)),
          focusColor: Color(0xFFFFFFFF),
          prefixIconColor: Colors.white,
          hoverColor: Color(0xFF9C3C81)),
    );
  }
}
