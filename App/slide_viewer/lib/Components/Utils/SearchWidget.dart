import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../Pages/Patologies/InjuryDetail.dart';
import '../../Services/PatologyDetailService.dart';
import '../../Services/Models/PatologyDetailModel.dart';
import '../../Styles/CustomTextStyle.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 45,
      child: TypeAheadField<PatologyDetailModel>(
        minCharsForSuggestions: 1,
        textFieldConfiguration: TextFieldConfiguration(
          textAlignVertical: TextAlignVertical.bottom,
          style: searchButtonTextStyle(),
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
            hintStyle: searchButtonTextStyle(),
          ),
        ),
        suggestionsCallback: (pattern) async {
          return PatologyDetailService()
              .getList()
              .where((objeto) =>
                  objeto.label.toLowerCase().contains(pattern.toLowerCase()))
              .take(6)
              .toList();
        },
        itemBuilder: (context, PatologyDetailModel suggestion) {
          return ListTile(
            title: Text(
              suggestion.label,
              style: H2TextStyle(14),
            ),
          );
        },
        onSuggestionSelected: (PatologyDetailModel suggestion) {
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
