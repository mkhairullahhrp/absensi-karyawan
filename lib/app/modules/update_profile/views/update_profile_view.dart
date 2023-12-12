import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  
  // const UpdateProfileView({Key? key}) : super(key: key);
  
  final Map<String, dynamic> user = Get.arguments;
  @override
    Widget build(BuildContext context) {
    controller.nipC.text = user["nip"];
    controller.nameC.text = user["name"];
    controller.emailC.text = user["email"];
    print(user);
    return Scaffold (
      appBar: AppBar(
        backgroundColor: Color(0xff3D9970),
        title: Text('UPDATE PROFILE'),
        centerTitle: true,
      ),
      body:  ListView (
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.nipC,
            decoration: InputDecoration(
              labelText: "NIP",
              labelStyle: TextStyle(color: Color(0xff3D9970)),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff3D9970))),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: controller.nameC,
            decoration: InputDecoration(
              labelText: "Nama",
              labelStyle: TextStyle(color: Color(0xff3D9970)),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff3D9970))),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: controller.emailC,
            decoration: InputDecoration(
              labelText: "Email",
              labelStyle: TextStyle(color: Color(0xff3D9970)),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff3D9970))),
            ),
          ),
          SizedBox(height: 25,),
          Text(
            "Photo Profile",
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<UpdateProfileController>(
                builder: (c) {
                  if (c.image != null) {
                    return ClipOval(
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.file(
                          File(c.image!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  } else {
                    if (user["profile"] != null) {
                      return Column(
                        children: [
                          ClipOval(
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Image.network(
                                user["profile"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: (){
                              controller.deleteProfile(user["uid"]);
                            }, 
                            child: Text("delete", style: TextStyle(color: Color(0xff3D9970)))
                          )
                        ],
                      );
                    } else {
                      return Text("no image"); 
                    }
                  }
                }
              ),
              TextButton(
                onPressed: (){
                  controller.pickImage();
                }, 
                child: Text("Choose", style: TextStyle(color: Color(0xff3D9970)),)
              )
            ],
          ),
          SizedBox(height: 30),
          Obx(() => 
            ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xff3D9970), shape: StadiumBorder()),
              onPressed: () async{
                if (controller.isLoading.isFalse) {
                    await controller.updateProfile(user["uid"]);
                  }
                }, 
              child: Text(controller.isLoading.isFalse ? "UPDATE PROFILE" : "LOADING..."),
            ),
          )
        ],
      ),
    );
  }
}
