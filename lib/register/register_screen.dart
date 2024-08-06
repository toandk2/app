import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hkd/anmition/fadeanimation.dart';
import 'package:hkd/register/buyer_register_screen.dart';
import 'package:hkd/register/shipper_register_screen.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:hkd/widgets/appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  _onRegister(int index) {
    switch (index) {
      case 1:
        const url = 'https://hokinhdoanh.online/index.php/m/reg';
        launchUrl(Uri.parse(url));
        // Navigator.push(
        //   context,
        //   MaterialPageRoute<dynamic>(
        //     builder: (BuildContext context) => const ShopRegisterScreen(),
        //   ),
        // );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const ShipperRegisterScreen(),
          ),
        );
        break;
      default:
        Navigator.push(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const BuyerRegisterScreen(),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Đăng ký tài khoản Đô thị Thông minh",
            style: Styles.headline1Style,
          ),
          const Gap(12),
          const Text(
            "Để tiếp tục, vui lòng chọn nhu cầu:",
            style: Styles.textStyle,
          ),
          const Gap(12),
          FadeAnimation(
            delay: 1,
            child: Column(
              children: List.generate(
                Configs.selectType.length,
                (index) {
                  final type = Configs.selectType[index];
                  if (type == null) return const SizedBox();
                  return InkWell(
                    onTap: () {
                      // if(Configs.user==nu)
                      _onRegister(index);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(12),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          // side: BorderSide(
                          //     color: temporaryUserGroup == index
                          //         ? GFColors.PRIMARY
                          //         : Colors.white),
                          borderRadius: BorderRadius.circular(8),
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
                      child: Row(
                        children: [
                          SizedBox(
                            width: 48,
                            height: 48,
                            child: Image.asset(
                                'assets/icons/login/${type['icon']}.png'),
                          ),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${type['text']}',
                                    textAlign: TextAlign.center,
                                    style: Styles.headline4Style),
                                const Gap(4),
                                Text(
                                  '${type['registerText']}',
                                  // textAlign: TextAlign.center,
                                  // maxLines: 2,
                                  style: const TextStyle(
                                      color: Color(0xFF23313E), fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
