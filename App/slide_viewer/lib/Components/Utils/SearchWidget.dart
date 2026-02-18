import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../Pages/Patologies/PatologyDetail.dart';
import '../../Services/PatologyDetailService.dart';
import '../../Services/Models/PatologyDetailModel.dart';
import '../../Styles/CustomTextStyle.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _controller = TextEditingController();

  void _clearField() {
    _controller.clear();
    FocusScope.of(context).unfocus(); // fecha teclado
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 45,
      child: TypeAheadField<PatologyDetailModel>(
        minCharsForSuggestions: 1,
        textFieldConfiguration: TextFieldConfiguration(
          controller: _controller, 
          textAlignVertical: TextAlignVertical.bottom,
          style: searchButtonTextStyle(),
          onSubmitted: (value) {
            _clearField(); 
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF9C3C81),
            prefixIcon: const Icon(Icons.search),
            prefixIconColor: Colors.white,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            hintText: 'Pesquisar',
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
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(
              suggestion.label,
              style: H2TextStyle(14),
            ),
          );
        },
        onSuggestionSelected: (suggestion) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PatologyDetail(Id: suggestion.id),
            ),
          ).then((_) {
            _clearField(); 
          });

          _clearField();
        },
        noItemsFoundBuilder: (context) {
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
