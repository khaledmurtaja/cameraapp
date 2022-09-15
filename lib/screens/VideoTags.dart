import 'package:flutter/material.dart';
import 'package:video_trimmer/src/videoFlag.dart';
import '../videoPlayer.dart';

class VideoTags extends StatelessWidget {
  final List<VideoFlag> list;
  final String path;
  final int videoDuration;
VideoTags({required this.list,required this.path,required this.videoDuration});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video's tags"),
      ),
      body: ListView.separated(
          itemBuilder:(context,index)=>itemBuilder(index,context),
          separatorBuilder: (context,index)=>separatorBuilder(),
          itemCount: list.length
      ),
    );
  }
  Widget itemBuilder(int key,context) {
    // box.get(key)!.flagsModels.forEach((element) {
    //   videoFlags.add(VideoFlag(flagPoint: element.flagPoint,afterFlag: element.afterFlag,BeforeFlag: element.beforeFlag));
    // });
    // videoFlagList.add(videoFlags);

    // int index=box.get(key)!.path!.lastIndexOf("/");
    // String path=box.get(key)!.path!.substring(index+1,box.get(key)!.path!.length);
    return InkWell(
      onTap: (){
       Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomTrimmer(path: path,videoFlagList: list,duration: videoDuration,tagKey: key,)));
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
              children: [Expanded(child: Text("Tag "+"${key+1}")), Icon(Icons.flag)],
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
