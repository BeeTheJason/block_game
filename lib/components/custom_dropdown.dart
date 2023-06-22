import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DropDown extends StatelessWidget {
  final List<String>? items;
  final String? value;
  final String? hintText;
  // ValueChanged with the passed type
  final ValueChanged<String?>? onChanged;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final Color color;
  final Color borderColor;
  final double height;
  final double? cornerRadius;
  final double? dropdownRadius;
  final bool isShowBorder;
  final bool isEnable;

  const DropDown(
      {Key? key,
      required this.items,
      this.value,
      this.hintText,
      this.color = Colors.white,
      this.borderColor = Colors.black45,
      this.style,
      this.hintStyle,
      this.height = 24,
      this.cornerRadius,
      this.dropdownRadius,
      this.onChanged,
      this.isShowBorder = true,
      this.isEnable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      decoration: InputDecoration(
          //Add isDense true and zero Padding.
          //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
          isDense: true,
          filled: true,
          fillColor: color,
          // fillColor:
          //     isEnable == true ? Colors.transparent : Colors.grey.shade300,
          contentPadding: EdgeInsets.zero,
          border: !isShowBorder
              ? InputBorder.none
              : OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(cornerRadius ?? height / 2),
                  borderSide: BorderSide(color: borderColor, width: 0.0)),
          enabledBorder: !isShowBorder
              ? InputBorder.none
              : OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(cornerRadius ?? height / 2),
                  borderSide: BorderSide(color: borderColor, width: 2.0),
                )
          //Add more decoration as you want here
          //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
          ),
      value: value,
      isExpanded: true,
      hint: Text(
        hintText ?? "",
        style: hintStyle,
      ),
      iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
          iconSize: 20),
      buttonStyleData: const ButtonStyleData(
        height: 40,
        padding: EdgeInsets.only(left: 1, right: 4),
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(dropdownRadius ?? 15),
        ),
      ),
      items: items
          ?.map((item) => DropdownMenuItem<String>(
                value: item,
                // child: SizedBox(width: 60, child: Text(item, style: style)),
                child: Align(alignment: Alignment.center, child: Text(item, style: style)),
              ))
          .toList(),
      onChanged: isEnable == true ? onChanged : null,
    );
  }
}
