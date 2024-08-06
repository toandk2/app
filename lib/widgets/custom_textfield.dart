import 'package:flutter/material.dart';
import 'package:hkd/anmition/fadeanimation.dart';
import 'package:hkd/ultils/styles.dart';

final borderTextField = OutlineInputBorder(
  borderSide: const BorderSide(width: 1, color: Color(0xFFE5E5E5)),
  borderRadius: BorderRadius.circular(6),
);

final focusBorderTextField = OutlineInputBorder(
  borderSide: const BorderSide(color: Colors.orange, width: 2.0),
  borderRadius: BorderRadius.circular(6),
);

class CustomTextfield extends StatelessWidget {
  const CustomTextfield(
      {Key? key,
      this.onTap,
      this.onSubmitted,
      this.onSaved,
      this.validator,
      this.suffixIcon,
      this.prefixIcon,
      this.hintText,
      this.obscureText = false,
      this.textInputAction = TextInputAction.next,
      this.lines = 1,
      this.keyboardType,
      this.maxLength,
      this.textCtrl,
      this.readOnly = false,
      this.onChanged,
      this.showBorder = false,
      this.initialValue,
      this.onTapOutside, this.focusNode})
      : super(key: key);
  final void Function()? onTap;
  final void Function()? onTapOutside;
  final void Function()? onSubmitted;

  final Function(String? value)? onSaved;
  final Function(String? value)? onChanged;
  final bool readOnly;
  final bool showBorder;
  final FocusNode? focusNode;
  final String? Function(String? value)? validator;

  final Widget? suffixIcon;

  final Widget? prefixIcon;
  final TextEditingController? textCtrl;
  final String? hintText;
  final int lines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextInputAction textInputAction;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      delay: 1,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 12,
              offset: Offset(0, 8),
              spreadRadius: -4,
            )
          ],
        ),
        child: TextFormField(
            onTap: onTap,
            
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
              onTapOutside?.call();
            },
            onSaved: onSaved,
            onChanged: onChanged,
            
            focusNode: focusNode,
            validator: validator,
            initialValue: initialValue,
            controller: textCtrl,
            maxLength: maxLength,
            minLines: 1,
            maxLines: lines,
            keyboardType: keyboardType,
            readOnly: readOnly,
            decoration: InputDecoration(
                enabledBorder: showBorder ? borderTextField : InputBorder.none,
                contentPadding: const EdgeInsets.all(15),
                filled: true,
                fillColor: Colors.white,
                focusedBorder:
                    showBorder ? focusBorderTextField : InputBorder.none,
                border: showBorder ? borderTextField : InputBorder.none,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                hintText: hintText,
                hintStyle: Styles.hintStyle),
            obscureText: obscureText,
            style: Styles.inputStyle,
            textInputAction: textInputAction,
            onEditingComplete: onSubmitted),
      ),
    );
  }
}
