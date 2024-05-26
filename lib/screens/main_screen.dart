import 'package:dog_app/providers/auth/auth_provider.dart';
import 'package:dog_app/screens/feed_upload_screen.dart';
import 'package:dog_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>with SingleTickerProviderStateMixin {
  late TabController tabController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 5, vsync: this);
  }

  void bottomNavigationItemOnTab(int index){
    setState(() {
      tabController.index = index;
    });

  }


  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>false,
      child: Scaffold(
        body: TabBarView(
          controller: tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            FeedUploadScreen(),
            Center(child: Text('1'),),
            Center(child: Text('2'),),
            Center(child: Text('3'),),
            Center(child: Text('4'),),
            Center(child: Text('5'),),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: tabController.index,
          onTap: bottomNavigationItemOnTab,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('유기견'),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
                icon: Text('봉사공고'),
                label: ''
            ),
            BottomNavigationBarItem(
                icon: Text('후원'),
                label: ''
            ),
            BottomNavigationBarItem(
              icon: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('좋아요 누른 유기견'),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('입양'),
              ),
              label: '',
            ),
      
          ],
        ),
      ),
    );
  }
}
