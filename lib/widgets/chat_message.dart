import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/styles.dart';

class MessageWidgget extends StatefulWidget {
  const MessageWidgget(
      {Key? key, required this.type, required this.message, this.name})
      : super(key: key);
  final int type;
  final String message;
  final String? name;
  @override
  State<MessageWidgget> createState() => MessageWidggetState();
}

class MessageWidggetState extends State<MessageWidgget> {
  @override
  void initState() {
    super.initState();
    isUser = widget.type == Configs.messageType[Configs.userGroup];
    setState(() {});
  }

  bool isUser = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser && widget.name != null)
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50),
              child: Text(widget.name!, style: Styles.inputStyle),
            ),
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isUser)
                Container(
                  width: 40,
                  height: 40,
                  decoration: const ShapeDecoration(
                    color: Styles.primaryColor3,
                    shape: OvalBorder(),
                  ),
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.only(right: 8),
                  child: SvgPicture.asset(
                    Configs.iconsMessageProfile[widget.type],
                    // width: 42,
                    // height: 42,
                    color: Colors.white,
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: ShapeDecoration(
                  color: isUser ? const Color(0xFFFFF8CC) : Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 12,
                      offset: Offset(0, 8),
                      spreadRadius: -4,
                    )
                  ],
                ),
                child: Text(widget.message, style: Styles.textStyle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
