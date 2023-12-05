// import 'dart:ffi';

import 'dart:ffi';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';
import '../../../controllers/page_index_controller.dart';


class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();
  // const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HOME'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.PROFILE),
              icon: Icon(Icons.person)
            )
        ],
      ),
      
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Row(
            children: [
              ClipOval(
                child: Container(
                  width: 75,
                  height: 75,
                  color: Colors.grey[200],
                  child: Center(child: Text("X")),
                ),
              ),
              SizedBox(height: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("Jln Raya Gandul"),
                ],
              )
            ],
          ),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[200],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("developer",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10,),
                Text("123412341",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5,),
                Text("Khairul",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[200],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text("Masuk"),
                    Text("-")
                  ],
                ),
                Container(
                  width: 2,
                  height: 40,
                  color: Colors.grey,
                ),
                Column(
                  children: [
                    Text("Keluar"),
                    Text("-")
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Divider(
            color: Colors.grey[300],
            thickness: 2,
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Last 5 days",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              TextButton(
                onPressed: (){}, 
                child: Text("See more"))
            ],
          ),
          SizedBox(height: 10,),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Masuk",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("${DateFormat.yMMMEd().format(DateTime.now())}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text("${DateFormat.jms().format(DateTime.now())}"),
                    SizedBox(height: 10,),
                    Text("Keluar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("${DateFormat.jms().format(DateTime.now())}"),
                  ],
                ),
              );
            }    
          ),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.fingerprint, title: 'Add'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: pageC.pageIndex.value,
        onTap: (int i) => pageC.changePage(i),
      )
    );
  }
}
