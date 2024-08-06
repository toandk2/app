import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DialogAction extends StatelessWidget {
  const DialogAction(
      {Key? key,
      this.icon,
      this.contentWidget,
      required this.title,
      required this.content,
      required this.text1,
      required this.text2,
      required this.onTap1,
      required this.onTap2,
      this.colorButton1})
      : super(key: key);
  final Widget? icon;
  final String title;
  final Widget? contentWidget;
  final String content;
  final String text1;
  final String text2;
  final Function onTap1;
  final Function onTap2;
  final Color? colorButton1;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) SizedBox.square(dimension: 120, child: icon),
            if (icon != null) const Gap(24),
            Text(
              title,
              style: Styles.headline3Style.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const Gap(6),
            Text(
              content,
              style: Styles.textStyle,
              textAlign: TextAlign.center,
            ),
            contentWidget ?? const SizedBox(),
            const Gap(36),
            GFButton(
              onPressed: () => onTap1.call(),
              text: text1,
              size: 46,
              color: colorButton1 ?? GFColors.PRIMARY,
              textStyle: Styles.headline4Style.copyWith(color: Colors.white),
              fullWidthButton: true,
              borderShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
            const Gap(6),
            GFButton(
              onPressed: () => onTap2.call(),
              size: 46,
              text: text2,
              color: const Color(0xFFEBF2F8),
              textStyle:
                  Styles.headline4Style.copyWith(color: Styles.primaryColor3),
              fullWidthButton: true,
              borderShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
          ],
        ),
      ),
    );
  }
}

class DialogQr extends StatelessWidget {
  const DialogQr({Key? key, required this.title, required this.qrUrl})
      : super(key: key);
  final String title;
  final String qrUrl;

  @override
  Widget build(BuildContext context) {
    final renderObjectKey = GlobalKey();
    double qrsize = MediaQuery.of(context).size.width * 0.5;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Styles.headline3Style.copyWith(fontSize: 20),
            ),
            const Gap(12),
            RepaintBoundary(
              key: renderObjectKey,
              child: QrImage(
                data: qrUrl,
                backgroundColor: Colors.white,
                version: QrVersions.auto,
                size: qrsize - 20,
              ),
            ),
            const Gap(12),
            GFButton(
              onPressed: () => getWidgetImage(renderObjectKey),
              size: 46,
              text: 'Tải mã QR code',
              icon: SvgPicture.asset('assets/icons/profile/bxs-download.svg'),
              color: const Color(0xFFEBF2F8),
              textStyle:
                  Styles.headline4Style.copyWith(color: Styles.primaryColor3),
              fullWidthButton: true,
              borderShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
            const Gap(12),
            GFButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: qrUrl));
                Fluttertoast.showToast(
                    msg: "Sao chép đường dẫn đơn hàng thành công ");
              },
              text: 'Chia sẻ đơn hàng',
              size: 46,
              color: GFColors.PRIMARY,
              icon: SvgPicture.asset('assets/icons/profile/bxs-share.svg'),
              textStyle: Styles.headline4Style.copyWith(color: Colors.white),
              fullWidthButton: true,
              borderShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
            const Gap(24),
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  const Spacer(),
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: Image.asset(
                      "assets/images/logo.png",
                    ),
                  ),
                  Text(
                    Configs.userGroup == 1
                        ? 'hokinhdoanh.\nonline'
                        : 'dothi\nthongminh1',
                    style: const TextStyle(
                      color: Color(0xFF303030),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
