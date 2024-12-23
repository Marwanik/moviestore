import 'package:flutter/material.dart';
import 'package:moviestore/presentation/constans/colors.dart';
import 'package:moviestore/presentation/constans/icons.dart';
import 'package:moviestore/presentation/constans/string.dart';
import 'package:moviestore/presentation/constans/textStyle.dart';

class SearchField extends StatelessWidget {
  final Function(String)? onChanged;

  const SearchField({Key? key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: secondColor,
          ),
          borderRadius: BorderRadius.circular(28),
        ),
        child: TextField(
          style: search,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20.0),
            suffixIcon: SEARCHICON,
            hintText: SEARCH,
            hintStyle: search,
            border: InputBorder.none,
          ),
        ),
      );
  }
}
