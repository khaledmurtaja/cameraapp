import 'package:flutter/material.dart';

import 'EditedVideos.dart';
import 'FlaggedVideos.dart';

class NavBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(

          children: [
           Padding(
             padding: const EdgeInsets.all(30.0),
             child: Image.asset(
                 "assets/images/cameraIcon.png",
               fit: BoxFit.cover,
             ),
           ),
            Column(
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>FlaggedVideos()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(20)

                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                              Icons.flag
                          ),
                          Text(
                              "flagged videos",
                              style: TextStyle(
                                  fontSize: 22
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EditedVideos()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(20)

                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                              Icons.flag
                          ),
                          Text(
                              "Edited videos",
                              style: TextStyle(
                                  fontSize: 22
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
