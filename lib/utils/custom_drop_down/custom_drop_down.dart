import 'package:flutter/material.dart';

import '../../main.dart';
import 'model/custom_drop_down_model.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.items,
    this.hintText,
    this.selectedItem,
    this.selectedTrailingIcon,
    required this.onItemTap,
    this.width,
    this.inputDecorationTheme,
  });

  final List<CustomDropDownModel> items;
  final CustomDropDownModel? selectedItem;
  final String? hintText;
  final Widget? selectedTrailingIcon;
  final double? width;
  final InputDecorationTheme? inputDecorationTheme;
  final Function(CustomDropDownModel? selectedItem) onItemTap;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      width: width ?? (screenUtil.screenWidth / 1.5) - appSize.size32,
      inputDecorationTheme:
          inputDecorationTheme ??
          InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(appSize.radius8),
            ),
            fillColor: appColors.whiteColor,
            filled: true,
          ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(appColors.whiteColor),
      ),
      onSelected: onItemTap,
      controller: TextEditingController(text: selectedItem?.label),
      trailingIcon: selectedItem != null ? selectedTrailingIcon : null,
      hintText: hintText,
      textStyle: fontStyles.font16MediumGrey400,
      dropdownMenuEntries: items
          .map(
            (e) => DropdownMenuEntry(
              value: e,
              label: e.label,
              style: ButtonStyle(
                textStyle: WidgetStatePropertyAll(
                  fontStyles.font16MediumGrey400,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
