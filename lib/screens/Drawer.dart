import 'package:flutter/material.dart';

import 'FlaggedVideos.dart';

class NavBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(

        children: [
         Padding(
           padding: const EdgeInsets.all(30.0),
           child: Image.asset(
               "assets/images/cameraIcon.png",
             fit: BoxFit.cover,
           ),
         ),
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
          )
        ],
      ),
    );
  }
}
