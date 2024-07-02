import 'package:_9jahotel/core/screen_size/mediaQuery.dart';
import 'package:_9jahotel/core/widget/customButton.dart';
import 'package:_9jahotel/features/auth/login/page/login.dart';
import 'package:_9jahotel/features/home/widget/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/utility/buttomSheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.firstName, required this.lastName, required this.email,});
  final String firstName, lastName, email;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  final BottomSheetResponse _bottomSheetResponse = BottomSheetResponse();

  List<String> label = [
    "Total Rooms", "Dirty Rooms", "Pending Checking today", "Pending Checkout today"
  ];
  List<int> number = [9,0,0,0];
  List<Color> colors = [Colors.purple, Colors.orange, Colors.green, Colors.red];
  List<IconData> icons = [Icons.room, Icons.dirty_lens, Icons.nordic_walking, Icons.directions_walk];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  MyDrawer(userName: '${widget.firstName} ${widget.lastName}', email:widget.email,),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xffB02700),
        title: const Text(
          '9jahotels.com for Hotels',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
              },
              icon: const Icon(Icons.logout, color: Colors.white))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: getWidth(context),
            decoration: const BoxDecoration(
                color: Color(0xffB02700),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(15),
                  Text(
                    "Welcome ${widget.firstName}",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const Gap(5),
                  Text(
                    "...a better way to manage hotel rooms",
                    style: TextStyle(fontSize:  13, color: Colors.white),
                  ),
                  const Gap(10),
                  CustomButton(textColor: Colors.white, borderColor: Colors.transparent,borderRadius: 8, color:  const Color(0xffEA5232), text: "Book Room", onTap: (){
                    _bottomSheetResponse.showErrorBottomSheet(context, "Error", "No internet Connection");
                  })
                ],
              ),
            ),

          ),

      const Gap(20),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xffF9E9E6),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Color(0xffF19C89)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.notifications_active,
                    color: Colors.black,
                    size: 40,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Manage Hotel",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Gap( 4),
                        Text(
                          "Manage your Hotel Administration Real Time, Anywhere, Anytime",
                          style: TextStyle(color: Colors.black, fontSize: 13.5, fontWeight:   FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap( 20),
            const Text(
              "Hotel Highlights",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap( 10),
          SizedBox(
            height: 70,
            child: ListView.builder(scrollDirection: Axis.horizontal,
            itemCount: label.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: _buildHighlightCard(
                    icon: icons[index], label: label[index], value: number[index], color: colors[index]),
              );
            }),
          ),
    
            const Gap( 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Available Rooms Today",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "View More",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Gap( 5),
             Center(
              child: Text(
                "No Internet Connection",
                style: TextStyle(color: Colors.grey[300]!, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
        ],
      ),
    );
  }
}


Widget _buildHighlightCard(
    {required IconData icon, required String label, required int value, required Color color} ) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Row(crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: color.withOpacity(0.3)),
          child: Icon(
            icon,
            color: color,
            size: 22,
          ),
        ),
        const Gap( 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.black, fontSize: 10),
            ),
            Text(
              value.toString(),
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
            ),


          ],
        ),

      ],
    ),
  );
}
