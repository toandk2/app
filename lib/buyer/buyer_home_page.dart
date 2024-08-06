// import 'package:fluentui_icons/fluentui_icons.dart';
// import 'package:flutter/material.dart';

// import 'package:gap/gap.dart';
// import 'package:getwidget/getwidget.dart';
// import 'package:hkd/anmition/fadeanimation.dart';
// import 'package:hkd/buyer/buyer_notification_screen.dart';
// import 'package:hkd/buyer/buyer_order_detail_screen.dart';
// import 'package:hkd/login_screen.dart';

// import 'package:hkd/ultils/database_helper.dart';
// import 'package:hkd/ultils/func.dart';
// import 'package:hkd/ultils/models.dart';
// import 'package:hkd/ultils/styles.dart';
// import 'package:hkd/widgets/appbar.dart';
// import 'package:intl/intl.dart';

// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:material_dialogs/material_dialogs.dart';
// import 'package:material_dialogs/widgets/buttons/icon_button.dart';
// import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_colorful_tab/flutter_colorful_tab.dart';

// class BuyerHomePage extends StatefulWidget {
//   const BuyerHomePage({Key? key}) : super(key: key);

//   @override
//   State<BuyerHomePage> createState() => _BuyerHomePageState();
// }

// class _BuyerHomePageState extends State<BuyerHomePage>
//     with TickerProviderStateMixin {
//   List<Status> listStatus = [];
//   List<BuyerOrder> orders = [];

//   final NetworkUtil _netUtil = NetworkUtil();
//   final NumberFormat formatter = NumberFormat("#,###");
//   final ScrollController _scrollController = ScrollController();
//   final bool _showBackToTopButton = false;
//   bool firstLoad = true;
//   int unreadNotification = 0;
//   int _status = 0;
//   TabController _tabController;
//   String txtStatus = "Đang tải dữ liệu";
//   @override
//   void initState() {
//     _tabController = TabController(length: 4, vsync: this);
//     super.initState();
//     listStatus = Configs.getStatus();
//     Configs.status = listStatus[0];

//     _tabController.addListener(() {
//       int s = 0;

//       if (_tabController.index == 2) {
//         s = 3;
//       } else if (_tabController.index == 3) {
//         s = 4;
//       } else {
//         s = _tabController.index;
//       }
//       Configs.status = listStatus[s];
//       getOders();
//     });
//     // _scrollController.addListener(() {
//     //   if (_scrollController.offset >= 100) {
//     //     if (!_showBackToTopButton) {
//     //       setState(() {
//     //         _showBackToTopButton = true;
//     //       });
//     //     }
//     //   } else {
//     //     if (_showBackToTopButton) {
//     //       setState(() {
//     //         _showBackToTopButton = false;
//     //       });
//     //     }
//     //   }
//     // });
//     shopCountUnreadNotification();
//     getOders();
//     Configs.appNotification.addListener(() {
//       shopCountUnreadNotification();
//       getOders();
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> shopCountUnreadNotification() async {
//     Map<String, dynamic> body = {
//       "token": Configs.login?.token,
//     };

//     _netUtil.get("buyer_count_unread_notification", body).then((rs) {
//       if (rs != null) {
//         unreadNotification = int.tryParse(rs['count_unread_notification']) ?? 0;
//       } else {
//         unreadNotification = 0;
//       }
//       // setState(() {});
//     });
//   }

//   Future<void> getOders() async {
//     txtStatus = "Đang tải dữ liệu";
//     _status = 0;
//     setState(() {});
//     Map<String, dynamic> body = {
//       "token": Configs.login?.token,
//       "status": Configs.status.status.toString(),
//     };

//     _netUtil.get("buyer_orders", body).then((rs) {
//       if (rs != null && rs['orders'] != null) {
//         orders = (rs["orders"])
//             .map<BuyerOrder>((item) => BuyerOrder.fromJson(item))
//             .toList();
//         if (orders.isNotEmpty) {
//           _status = 2;
//           txtStatus = "Đã tìm thấy ${orders.length} đơn hàng";
//         } else {
//           _status = 3;
//           txtStatus = "Không tìm thấy đơn hàng";
//         }
//         // if (!firstLoad) {
//         //   _scrollToTop();
//         // }
//         firstLoad = false;
//       } else {
//         orders = [];
//         _status = 3;
//         txtStatus = "Không tìm thấy đơn hàng";
//       }
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MyScaffold(
//       // appBar: myAppBar(),
//       // drawer: const MyDrawer(),
//       // backgroundColor: Styles.background,
//       body: Column(
//         children: [
//           Container(
//               padding: EdgeInsets.only(
//                   top: AppBar().preferredSize.height - 20, left: 10, right: 10),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Container(
//                         height: 45,
//                         width: 45,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFFFFFFF),
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                         child: InkWell(
//                             onTap: () async {
//                               final url =
//                                   Uri.tryParse("https://dothithongminh1.vn");

//                               if (await canLaunchUrl(url)) {
//                                 await launchUrl(url);
//                               } else {
//                                 throw 'Could not launch $url';
//                               }
//                             },
//                             child: Image.asset('assets/images/logo.png')),
//                       ),
//                       const SizedBox(
//                         width: 15,
//                       ),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '${DateFormat('EEEE', 'vi_VN').format(DateTime.now())}, ${DateFormat('yMMMMd', 'vi_VN').format(DateTime.now())}',
//                               style: Styles.textStyle,
//                             ),
//                             Text(
//                               Configs.login?.name ?? '',
//                               style: Styles.headline2Style
//                                   .copyWith(color: Styles.black50),
//                             )
//                           ],
//                         ),
//                       ),
//                       // GFIconBadge(
//                       //   padding: const EdgeInsets.all(2),
//                       //   counterChild: unreadNotification > 0
//                       //       ? GFBadge(
//                       //           child: Text(unreadNotification.toString()),
//                       //         )
//                       //       : Container(),
//                       //   child: GFIconButton(
//                       //     color: Colors.transparent,
//                       //     padding: const EdgeInsets.all(2),
//                       //     onPressed: () {
//                       //       Navigator.pushAndRemoveUntil(
//                       //         context,
//                       //         MaterialPageRoute<dynamic>(
//                       //           builder: (BuildContext context) =>
//                       //               const BuyerNotificationScreen(),
//                       //         ), (route) => route is SearchScreen
//                       //       ).then((_) {
//                       //         shopCountUnreadNotification();
//                       //         getOders();
//                       //       });
//                       //     },
//                       //     icon: const Icon(
//                       //       FluentSystemIcons.ic_fluent_alert_regular,
//                       //       color: Styles.black50,
//                       //       size: 30,
//                       //     ),
//                       //   ),
//                       // ),
//                       const Gap(20),
//                       GFIconButton(
//                         color: Colors.transparent,
//                         padding: const EdgeInsets.all(2),
//                         onPressed: () {
//                           dangXuat(context);
//                         },
//                         icon: const Icon(
//                           FluentSystemIcons.ic_fluent_sign_out_regular,
//                           color: Styles.black50,
//                           size: 33,
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               )),
//           const Gap(10),
//           ColorfulTabBar(
//             // selectedHeight: 65,
//             // unselectedHeight: 50,
//             labelColor: Colors.white,
//             unselectedLabelColor: Colors.white,
//             tabs: [
//               TabItem(
//                   title: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [
//                         Icon(MdiIcons.cartVariant),
//                         SizedBox(width: 8),
//                         Text('Đơn mới')
//                       ]),
//                   color: Colors.orange.shade600),
//               TabItem(
//                   title: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [
//                         Icon(MdiIcons.cartCheck),
//                         SizedBox(width: 8),
//                         Text('Xác nhận')
//                       ]),
//                   color: Colors.blue.shade600),
//               TabItem(
//                   title: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [
//                         Icon(MdiIcons.truckDelivery),
//                         SizedBox(width: 8),
//                         Text('Đang chuyển')
//                       ]),
//                   color: const Color(0xff27B893)),
//               TabItem(
//                   title: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [
//                         Icon(FluentSystemIcons
//                             .ic_fluent_checkmark_circle_filled),
//                         SizedBox(width: 8),
//                         Text(
//                           'Hoàn thành',
//                         )
//                       ]),
//                   color: Colors.green.shade600),
//             ],
//             controller: _tabController,
//           ),
//           Container(
//               padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8),
//               decoration: const BoxDecoration(
//                 color: Styles.lightColor,
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.functions,
//                     size: 22,
//                     color: Styles.primaryColor,
//                   ),
//                   Expanded(
//                       child: Text(txtStatus,
//                           style: const TextStyle(
//                               color: Styles.primaryText,
//                               fontSize: 13,
//                               fontWeight: FontWeight.w300))),

//                   // Expanded(
//                   //   child: Container(
//                   //     margin: EdgeInsets.symmetric(horizontal: 20),
//                   //     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                   //     height: 60,
//                   //     width: double.infinity,
//                   //     decoration: BoxDecoration(
//                   //       color: Colors.white,
//                   //       borderRadius: BorderRadius.circular(10),
//                   //       border: Border.all(
//                   //         color: Color(0xFFE5E5E5),
//                   //       ),
//                   //     ),
//                   //     child: Row(
//                   //       children: <Widget>[
//                   //         Expanded(
//                   //           child: DropdownButton<Status>(
//                   //             isExpanded: true,
//                   //             underline: SizedBox(),
//                   //             icon: SvgPicture.asset("assets/images/dropdown.svg"),
//                   //             value: Configs.status,
//                   //             onChanged: (Status val) {
//                   //               Configs.status = val;

//                   //               getOders();
//                   //             },
//                   //             items: listStatus.map((Status tt) {
//                   //               return DropdownMenuItem<Status>(
//                   //                 value: tt,
//                   //                 child: Row(
//                   //                   children: [
//                   //                     Icon(
//                   //                       tt.icon,
//                   //                       color: Styles.primaryColor,
//                   //                       size: ScreenUtil().setSp(20),
//                   //                     ),
//                   //                     SizedBox(width: 15),
//                   //                     Expanded(
//                   //                         child: Text(
//                   //                       tt.name,
//                   //                       style: TextStyle(fontSize: 14),
//                   //                     ))
//                   //                   ],
//                   //                 ),
//                   //               );
//                   //             }).toList(),
//                   //           ),
//                   //         ),
//                   //       ],
//                   //     ),
//                   //   ),
//                   // ),
//                 ],
//               )),
//           const Gap(10),
//           if (_status == 0)
//             Expanded(
//                 child: Container(
//                     color: Colors.white,
//                     padding: const EdgeInsets.all(50),
//                     child: Lottie.asset(
//                       "assets/images/loading.json",
//                       repeat: true,
//                       reverse: true,
//                       animate: true,
//                     ))),
//           if (_status == 2) Expanded(child: _getList(context)),
//           if (_status == 3)
//             Expanded(
//                 child: Container(
//                     color: Colors.white,
//                     padding: const EdgeInsets.all(50),
//                     child: Lottie.asset(
//                       "assets/images/nodata.json",
//                       repeat: true,
//                       reverse: true,
//                       animate: true,
//                     )))
//         ],
//       ),
//       floatingActionButton: _showBackToTopButton
//           ? FloatingActionButton(
//               onPressed: _scrollToTop,
//               backgroundColor: Styles.primaryColor,
//               child: const Icon(
//                 FluentSystemIcons.ic_fluent_arrow_up_circle_filled,
//                 color: Colors.white,
//                 size: 30,
//               ),
//             )
//           : null,
//     );
//   }

//   void _scrollToTop() {
//     _scrollController.animateTo(0,
//         duration: const Duration(seconds: 1), curve: Curves.linearToEaseOut);
//   }

//   void _onRefresh() {
//     getOders();
//   }

//   void _onLoading() {
//     getOders();
//   }

//   Widget _getList(BuildContext context) {
//     return RefreshIndicator(
//         onRefresh: _onRefresh,
//         child: ListView.builder(
//             itemCount: orders.length,
//             controller: _scrollController,
//             scrollDirection: Axis.vertical,
//             itemBuilder: (context, index) {
//               var donHang = orders[index];
//               DateTime ngayDonHang = DateTime.parse(donHang.time);
//               return FadeAnimation(
//                   delay: 1,
//                   child: Container(
//                       alignment: AlignmentDirectional.center,
//                       width: MediaQuery.of(context).size.width,
//                       padding: const EdgeInsets.all(10),
//                       margin:
//                           const EdgeInsets.only(left: 10, right: 10, bottom: 7),
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           boxShadow: [
//                             BoxShadow(
//                                 color: Colors.grey.shade200,
//                                 blurRadius: 1,
//                                 spreadRadius: 1)
//                           ],
//                           borderRadius:
//                               const BorderRadius.all(Radius.circular(10))),
//                       child: Column(children: [
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 '${index + 1}. #${donHang.id} ${donHang.orderName.toUpperCase()} - ${DateFormat('dd/MM/yyyy').format(ngayDonHang)}',
//                                 textAlign: TextAlign.justify,
//                                 overflow: TextOverflow.clip,
//                                 maxLines: 2,
//                                 softWrap: true,
//                                 style: Styles.textStyle
//                                     .copyWith(color: Styles.black50),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const Gap(3),
//                         Row(
//                           children: <Widget>[
//                             InkWell(
//                                 onTap: () {
//                                   _showMaterialDialog(
//                                       context,
//                                       '#${donHang.id}. ${donHang.orderName.toUpperCase()}',
//                                       Configs.qrUrl);
//                                 },
//                                 child: QrImage(
//                                   data: Configs.qrUrl,
//                                   version: QrVersions.auto,
//                                   size: 70.0,
//                                 )),
//                             Expanded(
//                               child: Column(
//                                 children: <Widget>[
//                                   Row(
//                                     children: [
//                                       Container(
//                                           padding:
//                                               const EdgeInsets.only(right: 4),
//                                           child: Icon(
//                                             FluentSystemIcons
//                                                 .ic_fluent_people_regular,
//                                             color: Styles.primaryColor,
//                                             size: 16,
//                                           )),
//                                       Expanded(
//                                           child: Text(
//                                         donHang.buyerName,
//                                         textAlign: TextAlign.left,
//                                         overflow: TextOverflow.clip,
//                                         maxLines: 2,
//                                         softWrap: true,
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.w400,
//                                           fontSize: 12,
//                                           letterSpacing: 0.0,
//                                         ),
//                                       ))
//                                     ],
//                                   ),
//                                   const Gap(3),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: <Widget>[
//                                       Container(
//                                           padding:
//                                               const EdgeInsets.only(right: 4),
//                                           child: Icon(
//                                             FluentSystemIcons
//                                                 .ic_fluent_globe_location_regular,
//                                             color: Styles.primaryColor,
//                                             size: 16,
//                                           )),
//                                       Expanded(
//                                         child: Text(
//                                           donHang.shopAddress,
//                                           textAlign: TextAlign.left,
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 1,
//                                           softWrap: true,
//                                           style: const TextStyle(
//                                             fontWeight: FontWeight.w400,
//                                             fontSize: 12,
//                                             letterSpacing: 0.0,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const Gap(3),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: <Widget>[
//                                       if (donHang.shopPhone != null &&
//                                           donHang.shopPhone.length > 5)
//                                         InkWell(
//                                           onTap: () async {
//                                             final url = Uri.tryParse(
//                                                 "tel://${donHang.shopPhone}");
//                                             if (await canLaunchUrl(url)) {
//                                               await launchUrl(url);
//                                             } else {
//                                               throw 'Could not launch $url';
//                                             }
//                                           },
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(100),
//                                                 color: const Color(0xFFFEF4F3)),
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 3, vertical: 3),
//                                             child: Row(
//                                               children: [
//                                                 Container(
//                                                   decoration:
//                                                       const BoxDecoration(
//                                                           shape:
//                                                               BoxShape.circle,
//                                                           color: Colors.orange),
//                                                   padding:
//                                                       const EdgeInsets.all(3),
//                                                   child: const Icon(
//                                                     FluentSystemIcons
//                                                         .ic_fluent_phone_filled,
//                                                     color: Colors.white,
//                                                     size: 15,
//                                                   ),
//                                                 ),
//                                                 const Gap(6),
//                                                 Text(
//                                                   donHang.shopPhone.replaceAllMapped(
//                                                       RegExp(
//                                                           r'(\d{3})(\d{3})(\d+)'),
//                                                       (Match m) =>
//                                                           "${m[1]} ${m[2]} ${m[3]}"),
//                                                   style: const TextStyle(
//                                                       color: Colors.orange,
//                                                       fontWeight:
//                                                           FontWeight.w600),
//                                                 ),
//                                                 const Gap(6)
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       Expanded(child: Container()),
//                                       InkWell(
//                                         onTap: () {
//                                           Configs.orderId =
//                                               donHang.id.toString();
//                                           Navigator.pushAndRemoveUntil(
//                                               context,
//                                               MaterialPageRoute<dynamic>(
//                                                 builder: (BuildContext
//                                                         context) =>
//                                                     const BuyerOrderDetailScreen(),
//                                               ),
//                                               (route) => route is SearchScreen);
//                                           // .then((_) {
//                                           //   shopCountUnreadNotification();
//                                           //   getOders();
//                                           // });
//                                         },
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(100),
//                                               color:
//                                                   Colors.green.withOpacity(.1)),
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 3, vertical: 3),
//                                           child: Row(
//                                             children: [
//                                               Container(
//                                                 decoration: const BoxDecoration(
//                                                     shape: BoxShape.circle,
//                                                     color: Colors.green),
//                                                 padding:
//                                                     const EdgeInsets.all(3),
//                                                 child: const Icon(
//                                                   FluentSystemIcons
//                                                       .ic_fluent_arrow_right_circle_filled,
//                                                   color: Colors.white,
//                                                   size: 15,
//                                                 ),
//                                               ),
//                                               const Gap(6),
//                                               const Text(
//                                                 'Chi tiết',
//                                                 style: TextStyle(
//                                                     color: Colors.green,
//                                                     fontWeight:
//                                                         FontWeight.w600),
//                                               ),
//                                               const Gap(6)
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 8,
//                         ),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: Styles.primaryColor.withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(
//                                     10,
//                                   ),
//                                 ),
//                                 padding: const EdgeInsets.all(
//                                   10,
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       child: Column(
//                                         children: [
//                                           Text('Giá trị',
//                                               style: Styles.subtitle1Style),
//                                           const SizedBox(
//                                             height: 5,
//                                           ),
//                                           Text(
//                                               '${formatter.format(donHang.amount)}đ',
//                                               style: Styles.headline5Style
//                                                   .copyWith(
//                                                       color: Styles.moneyColor))
//                                         ],
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Column(
//                                         children: [
//                                           Text('Phí giao hàng',
//                                               style: Styles.subtitle1Style),
//                                           const SizedBox(
//                                             height: 5,
//                                           ),
//                                           Text(
//                                               '${formatter.format(donHang.shippingCost)}đ',
//                                               style: Styles.headline5Style
//                                                   .copyWith(
//                                                       color: Styles.moneyColor))
//                                         ],
//                                       ),
//                                     ),
//                                     /*   Expanded(
//                                       child: Column(
//                                         children: [
//                                           Text(
//                                             'Ngày nhận',
//                                             style: Styles.subtitle1Style,
//                                           ),
//                                           SizedBox(
//                                             height: 5,
//                                           ),
//                                           Text(
//                                               donHang.shippingTimeSlot == null
//                                                   ? "N/A"
//                                                   : donHang.shippingTimeSlot,
//                                               style: Styles.headline5Style
//                                                   .copyWith(
//                                                       color: Styles.black50))
//                                         ],
//                                       ),
//                                     ), */
//                                     const Gap(10),
//                                     Container(
//                                       alignment: Alignment.center,
//                                       child: Column(
//                                         children: [
//                                           Text('Giờ nhận hàng',
//                                               style: Styles.subtitle1Style),
//                                           const SizedBox(
//                                             height: 5,
//                                           ),
//                                           Text(
//                                               '${donHang.shippingTimeSlot == null ? "" : '${donHang.shippingTimeSlot}, '}${donHang.shippingTimeSlotFrom}h - ${donHang.shippingTimeSlotTo}h',
//                                               style: Styles.headline5Style
//                                                   .copyWith(
//                                                       color: Styles.black50))
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ])));
//             }));
//   }

//   void _showMaterialDialog(BuildContext context, String title, String qrCode) {
//     double qrsize = MediaQuery.of(context).size.width * 0.95;
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text(title),
//             content: SizedBox(
//               width: qrsize,
//               height: qrsize - 100,
//               child: Center(
//                 child: QrImage(
//                   data: qrCode,
//                   version: QrVersions.auto,
//                   size: qrsize - 20,
//                 ),
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Text('Đóng')),
//             ],
//           );
//         });
//   }

//   void dangXuat(BuildContext context) {
//     Dialogs.materialDialog(
//         msg: 'Bạn có chắc đăng xuất không?',
//         title: "Cảnh báo",
//         color: Colors.white,
//         context: context,
//         customView: Container(
//             padding: const EdgeInsets.all(20),
//             child: Lottie.asset(
//               "assets/images/logout.json",
//               repeat: true,
//               reverse: true,
//               animate: true,
//             )),
//         msgStyle: Styles.textStyle,
//         actions: [
//           IconsOutlineButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             text: 'Không',
//             iconData: Icons.cancel_outlined,
//             textStyle: Styles.textStyle,
//             iconColor: Colors.grey,
//           ),
//           IconsButton(
//             onPressed: () async {
//               Navigator.pop(context);

//               Map<String, dynamic> body = {"token": Configs.login?.token};

//               _netUtil.get("logout", body).then((rs) {});
//               var db = DatabaseHelper();
//               db.deleteUsers();

//               Navigator.of(context)
//                   .pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
//                 return const LoginScreen();
//               }), (route) => route is SearchScreen);
//             },
//             text: 'Có',
//             iconData: FluentSystemIcons.ic_fluent_checkmark_circle_filled,
//             color: Styles.primaryColor,
//             textStyle: Styles.textStyle.copyWith(color: Colors.white),
//             iconColor: Colors.white,
//           ),
//         ]);
//   }
// }
