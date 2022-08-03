import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'cameraApp.dart';

class AllowAccessScreen extends StatelessWidget {
  const AllowAccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Image.asset("assets/images/selfie.png"),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Permission Required",
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "camera app needs to access the following permission,without this permission,the application could not run properly.",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Camera",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          "To take photos and videos",
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xffa4d4fc)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Storage",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          "To save photos and videos",
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xfff5ecfe)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.photo_camera_back,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 200,
                ),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(11)),
                    child: TextButton(
                      onPressed: () async {
                        await Permission.storage.request();
                        await Permission.camera.request();
                        Permission.microphone.request().then((value) async {
                          print( await Permission.microphone.isGranted);
                          if ((await Permission.microphone.isGranted) ==
                              PermissionStatus.granted.isGranted) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomCamera()));
                          }
                        }).catchError((onError) {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 60, left: 60),
                        child: Text(
                          "Allow Access",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
