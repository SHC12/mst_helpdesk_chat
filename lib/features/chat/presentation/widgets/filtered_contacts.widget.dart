import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mst_chat/core/theme/colors.dart';
import 'package:mst_chat/features/chat/presentation/cubit/chat_cubit.dart';

class FilteredContactsWidget extends StatelessWidget {
  const FilteredContactsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) => context.read<ChatCubit>().updateSearchQuery(value),
      decoration: InputDecoration(
        hintText: 'Search',

        fillColor: backgroundTextfieldColor,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        isDense: true,
      ),
    );
  }
}
