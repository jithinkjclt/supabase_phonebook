import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? boxname;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final double? trailingIconSize;
  final Color? trailingIconColor;
  final double? height;
  final double? width;
  final bool readOnly;
  final double? textFieldHeight;
  final VoidCallback? onTrailingIconTap;
  final bool isEditable;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Color? hintTextColor;
  final Color? fillColor;
  final Color? borderColor;
  final bool noBorder;
  final double? boxNameSize;
  final Color? boxNameColor;
  final FontWeight? boxNameWeight;
  final double? hintTextSize;
  final FontWeight? hintTextWeight;

  // <-- Add obscureText here
  final bool obscureText;

  const CustomTextField({
    super.key,
    this.boxname,
    this.hintText = '',
    this.controller,
    this.keyboardType = TextInputType.text,
    this.leadingIcon,
    this.trailingIcon,
    this.trailingIconSize = 24.0,
    this.trailingIconColor = Colors.black,
    this.height,
    this.width,
    this.onChanged,
    this.textFieldHeight = 50.0,
    this.onTrailingIconTap,
    this.isEditable = true,
    this.validator,
    this.readOnly = false,
    this.hintTextColor,
    this.fillColor,
    this.borderColor,
    this.noBorder = false,
    this.boxNameSize,
    this.boxNameColor,
    this.boxNameWeight,
    this.hintTextSize,
    this.hintTextWeight,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeBorderColor = noBorder
        ? Colors.transparent
        : (borderColor ?? Colors.grey.shade300);

    final OutlineInputBorder baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: activeBorderColor, width: 1),
    );

    final InputBorder noBorderInput = InputBorder.none;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (boxname != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              boxname!,
              style: TextStyle(
                fontSize: boxNameSize ?? 16,
                color: boxNameColor ?? Colors.grey.shade600,
                fontWeight: boxNameWeight ?? FontWeight.w400,
              ),
            ),
          ),
        SizedBox(
          width: width,
          height: textFieldHeight,
          child: TextFormField(
            validator: validator,
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            enabled: isEditable,
            onChanged: onChanged,
            obscureText: obscureText,
            style: TextStyle(height: height, fontSize: 14, color: Colors.black),
            decoration: InputDecoration(
              isDense: true,
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: hintTextSize ?? 14,
                fontWeight: hintTextWeight ?? FontWeight.w300,
                color: hintTextColor ?? Colors.grey,
                overflow: TextOverflow.ellipsis,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 12,
              ),
              fillColor: fillColor ?? Colors.white,
              filled: true,
              border: noBorder ? noBorderInput : baseBorder,
              focusedBorder: noBorder ? noBorderInput : baseBorder,
              enabledBorder: noBorder ? noBorderInput : baseBorder,
              disabledBorder: noBorder ? noBorderInput : baseBorder,
              errorBorder: noBorder
                  ? noBorderInput
                  : baseBorder.copyWith(
                      borderSide: const BorderSide(color: Colors.red),
                    ),
              focusedErrorBorder: noBorder
                  ? noBorderInput
                  : baseBorder.copyWith(
                      borderSide: const BorderSide(color: Colors.red),
                    ),
              errorStyle: const TextStyle(height: 0.01),
              prefixIcon: leadingIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8, right: 4),
                      child: Icon(
                        leadingIcon,
                        size: 20,
                        color: Colors.grey.shade400,
                      ),
                    )
                  : null,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              suffixIcon: trailingIcon != null
                  ? GestureDetector(
                      onTap: onTrailingIconTap,
                      child: Icon(
                        trailingIcon,
                        size: trailingIconSize,
                        color: trailingIconColor,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
