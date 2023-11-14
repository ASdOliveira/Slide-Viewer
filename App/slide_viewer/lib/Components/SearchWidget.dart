import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:slide_viewer/InjuryDetail.dart';
import 'package:slide_viewer/Services/InjuryDetailService.dart';
import 'package:slide_viewer/Services/Models/InjuryDetailModel.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 45,
      child: TypeAheadField<InjuryDetailModel>(
        minCharsForSuggestions: 1,
        textFieldConfiguration: TextFieldConfiguration(
          textAlignVertical: TextAlignVertical.bottom,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: Color(0xFFFFFFFF),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF9C3C81),
            focusColor: const Color(0xFFFFFFFF),
            prefixIcon: const Icon(Icons.search),
            prefixIconColor: Colors.white,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            hintText: 'Pesquisar',
            hintMaxLines: 1,
            hoverColor: const Color(0xFF9C3C81),
            hintStyle: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Color(0xFFFFFFFF)),
          ),
        ),
        suggestionsCallback: (pattern) async {
          return InjuryDetailService()
              .getList()
              .where((objeto) =>
                  objeto.label.toLowerCase().contains(pattern.toLowerCase()))
              .take(6)
              .toList();
        },
        itemBuilder: (context, InjuryDetailModel suggestion) {
          return ListTile(
            title: Text(
              suggestion.label,
              style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9C3C81)),
            ),
          );
        },
        onSuggestionSelected: (InjuryDetailModel suggestion) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InjuryDetail(Id: suggestion.id),
            ),
          );
        },
        noItemsFoundBuilder: (context) {
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
      // child: TextField(
      //   maxLines: 1,
      //   textAlignVertical: TextAlignVertical.bottom,
      //   cursorColor: Colors.white,
      //   style: const TextStyle(
      //       fontSize: 16,
      //       fontFamily: 'Poppins',
      //       fontWeight: FontWeight.w500,
      //       color: Color(0xFFFFFFFF)),
      //   decoration: InputDecoration(
      //       filled: true,
      //       fillColor: const Color(0xFF9C3C81),
      //       prefixIcon: const Icon(Icons.search),
      //       border:
      //           OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      //       hintText: 'Pesquisar',
      //       hintStyle: const TextStyle(
      //           fontSize: 16,
      //           fontFamily: 'Poppins',
      //           fontWeight: FontWeight.w500,
      //           color: Color(0xFFFFFFFF)),
      //       focusColor: const Color(0xFFFFFFFF),
      //       prefixIconColor: Colors.white,
      //       hoverColor: const Color(0xFF9C3C81)),
      // ),
    //);
  //}
//}
