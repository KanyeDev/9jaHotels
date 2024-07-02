import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../ble/page/ble_page.dart';
import '../../auth/login/page/login.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key, required this.userName, required this.email});
  final String userName, email;

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<String> title = [
    "Manage Property & Rooms",
    "Hotel's wallet",
    "All Bookings",
    "Out of Order",
    "Breakfast List",
    "Room Categories",
    "Guest's Arrival List",
    "Guest's Check-Out List",
    "Dirty Room",
    "Manage Staffs",
    "Help - Live Chat",
    "Log Out"
  ];
  List<IconData> icons = [
    Icons.file_open,
    Icons.attach_money,
    CupertinoIcons.money_dollar_circle,
    Icons.cancel,
    Icons.food_bank,
    Icons.star,
    Icons.list_alt_sharp, // TODO: Change This
    Icons.check_box,
    Icons.cleaning_services,
    CupertinoIcons.checkmark_shield_fill,
    CupertinoIcons.question_square,
    Icons.logout
  ];

  // This will take each page to navigate to
  List<Widget> pagesToNavigateTo = [
    const LoginScreen(), // this would be each page in the [Drawer] list tile
    const LoginScreen(),
    const LoginScreen(),
    const LoginScreen(),
    const LoginScreen(),
    const LoginScreen(),
    const LoginScreen(),
    const LoginScreen(),
    const LoginScreen(),
    const LoginScreen(),
    const LoginScreen(),
    const LoginScreen()
  ];

  void logout(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Drawer(shape: const ContinuousRectangleBorder(),
      backgroundColor: Colors.white,
      child: GlowingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        color: Colors.red[300]!,
        child: RefreshIndicator( color: Colors.red, onRefresh: ()async{
          await Future.delayed(const Duration(milliseconds:200));
        },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Gap(25),
                    Stack(
                      children: [
                        SizedBox(
                          height: 170,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            'assets/images/hotel.jpg',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Positioned(
                          top: 20,
                          left: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                radius: 25,
                                backgroundColor: Color(0xffB02700),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                              const Gap(30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.userName,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    widget.email,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(5),
                    Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),
                    ListTileItems(
                      title: 'IOT Devices',
                      icons: FontAwesomeIcons.redditAlien,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BluetoothApp()));
                      },
                    ),
                    Column(
                      children: List.generate(title.length, (index) {
                        return ListTileItems(
                          title: title[index],
                          icons: icons[index],
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    pagesToNavigateTo[index]));
                          },
                        );
                      }),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListTileItems extends StatelessWidget {
  const ListTileItems({
    super.key,
    required this.title,
    required this.icons,
    required this.onTap,
  });

  final String title;
  final IconData icons;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Icon(
            icons,
            color: Colors.grey,
          ),
          title: Text(
            title,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
        Divider(
          color: Colors.grey[300],
          thickness: 1,
        ),
      ],
    );
  }
}

