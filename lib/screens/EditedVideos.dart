import 'package:cameraapp/models/EditedVideoModel.dart';
import 'package:cameraapp/models/videoModel.dart';
import 'package:cameraapp/screens/VideoTags.dart';
import 'package:cameraapp/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:video_trimmer/src/videoFlag.dart';
import '../models/videoModel.dart';
import '../shared/globalVars.dart';
import 'EditedVideoPlayer.dart';
class EditedVideos extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print("aaaaa");
    print(EditedVideosBox!.length);
    print("aaaaa");
    return Scaffold(
      appBar: AppBar(
        title: Text("Edited videos"),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<EditedVideoModel>('editedVideos').listenable(),
        builder: (context, Box<EditedVideoModel> items,Widget? widget ) {
          List<int> keys= EditedVideosBox!.keys.cast<int>().toList();
          return ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return itemBuilder(index,EditedVideosBox!,context);
              },
              separatorBuilder: (context, index) {
                return separatorBuilder();
              },
              itemCount: keys.length
          );
        },
      ) ,
    );
  }

  Widget itemBuilder(int key,Box<EditedVideoModel> box,context) {
    int index=box.get(key)!.path!.lastIndexOf("/");
    String path=box.get(key)!.path!.substring(index+1,box.get(key)!.path!.length);
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>EditedVideoPlayer(box.get(key)!.path)));

      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Expanded(child: Text("$path",overflow: TextOverflow.fade,)), Icon(Icons.videocam_rounded)],
            ),
          ),
        ),
      ),
    );
  }

  Widget separatorBuilder() {
    return Container(
      height: 1,
      width: double.infinity,
      color: Colors.black,
    );
  }
}
