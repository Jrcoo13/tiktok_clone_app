import 'package:flutter/material.dart';
import 'package:tiktok_app/ui/home_page.dart';
import 'package:tiktok_app/widgets/upload_icon.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: getFooter(),
      body: Stack(
        children: [
          getBody(),
          const SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Following', 
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                )),
                SizedBox(width: 10,),
                Text(
                  '|', 
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                )),
                SizedBox(width: 10,),
                Text(
                  'For You', 
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800
                )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: const [
        HomePage(),
        Center(
          child: Text("Search Page",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
          ),
        ),
        Center(
          child: Text("Post Page",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
          ),
        ),
        Center(
          child: Text("Inbox Page",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
          ),
        ),
        Center(
          child: Text("Profile Page",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
          ),
        ),
      ],
    );
  }

  Widget getFooter() {

    List buttonItems = [
      {
        'icon': 'assets/icons/home.png', 
        'label': 'Home', 
        'isIcon': true, 
        'color': Colors.white,
        'iconSize': 28.0,
      },
      {
        'icon': 'assets/icons/shopping-bag.png', 
        'label': 'Shop', 
        'isIcon': true, 
        'color': Colors.white,
        'iconSize': 28.0,
      },
      {
        'icon': 'assets/icons/post.png', 
        'label': '', 
        'isIcon': true, 
        'color': null,
        'iconSize': 30.0,
      },
      {
        'icon': 'assets/icons/inbox.png', 
        'label': 'Inbox', 
        'isIcon': true, 
        'color': Colors.white,
        'iconSize': 28.0,
      },
      {
        'icon': 'assets/icons/profile2.png',
        'label': 'Profile', 
        'isIcon': true, 
        'color': Colors.white,
        'iconSize': 28.0,
      }
    ];

    return Container(
        width: double.infinity,
        height: 90.0,
        decoration: const BoxDecoration(
          color: Colors.black,
          border: Border(top: BorderSide(width: 0.3, color: Colors.white))
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 10,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(buttonItems.length, (index) {
              return buttonItems[index]['isIcon']
                  ? InkWell(
                      onTap: () {
                        selectedIndex(index);
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            buttonItems[index]['icon'], 
                            color: buttonItems[index]['color'], 
                            height: buttonItems[index]['iconSize'],),
                          const SizedBox(height: 3),
                          Text(buttonItems[index]['label'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600
                              ))
                        ],
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        selectedIndex(index);
                      },
                      child: const UploadIcon());
            }),
          ),
        ));
  }

  void selectedIndex(index) {
    setState(() {
      pageIndex = index;
    });
  }
  }