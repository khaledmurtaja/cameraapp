import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:cameraapp/screens/Drawer.dart';
import 'package:cameraapp/models/FlagModel.dart';
import 'package:cameraapp/shared/globalVars.dart';
import 'package:cameraapp/main.dart';
import 'package:cameraapp/models/videoModel.dart';
import 'package:cameraapp/shared/videoInfo.dart';
// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:hive/hive.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:path_provider/path_provider.dart';
import 'shared/HelperFunctions.dart';
import 'dart:io';
import 'screens/cameraGallary.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CustomCamera extends StatefulWidget {
  @override
  State<CustomCamera> createState() => _CustomCameraState();
}

class _CustomCameraState extends State<CustomCamera>
    with LifecycleAware, LifecycleMixin, TickerProviderStateMixin {
  bool flashOpened = false;
  bool isEmpty = true;
  String AppExternalPath = "";
  CameraController? cameraController;
  bool isFrontCameraOpened = false;
  final player = AudioPlayer();
  String thumbNailPath = "";
  List<FileSystemEntity> imagesPaths = [];
  double scaleFactor = 0.5;
  double baseScaleFactor = 0.5;
  double minZoom = 1;
  StopWatchTimer? _stopWatchTimer;
  double maxZoom = 1;
  Stream<FileSystemEntity>? internalStorageFiles;
  int customTimer = 0;

  /// this value will be changed according to camera maximum zoom value
  bool isCameraInitialized = true;
  bool rotateCamera = false;
  late TabController _tabController;
  late TabController _fileDurationTabController;
  bool isZooming = false;
  bool IsPictureMode = true;
  bool IsMicEnabled = true;
  bool IsRecording = false;
  final resolutionPresets = ResolutionPreset.values;
  bool fullyZoomed = false;
  bool isPaused = false;
  bool systemStopRecording=false; /// to check if the system stop recording due to specified internal ending(not by user event)

  /// to check if the user tapped the screen double tab=>set max zoom :another doulbe tap=>set min zoom
  ResolutionPreset currentResolutionPreset = ResolutionPreset.max;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double ExposureSliderValue = 0.0;
  List<VideoModel> videoClips = [];
  Directory? AppInternalCash;
  FileSystemEntity? videoRecording;
  bool oneMinSelected = true;
  bool threeMinSelected = false;
  bool fiveMinSelected = false;
  bool durationSelectorPressed = false;
  String durationSelectorText = "1";
  XFile? fileToDelete;
  XFile? fileToSave;
  bool isProcessingVideo=false; // this will be true when the video interval ends(system stop)
  Timer? processingTimer;// this the timer that will stop user events before starting the (system stop);
  int remainingTime=0;

  /// when this is true=> a list will be shown in the app bar, the user
  ///can choose form it the number of minutes to save in a video clip operation

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fileDurationTabController = TabController(length: 3, vsync: this);
    cameraController =
        CameraController(MyAvailableCameras![0], ResolutionPreset.ultraHigh);
    cameraController!.initialize().then((value) async {
      isCameraInitialized = true;
      setState(() {});

      ///getting maximum camera zoom to adjust zooming settings
      cameraController!.getMaxZoomLevel().then((value) {
        maxZoom = value;
      });
      cameraController!
          .getMaxExposureOffset()
          .then((value) => _maxAvailableExposureOffset = value);

      ///set the max exposure value
      cameraController!
          .getMinExposureOffset()
          .then((value) => _minAvailableExposureOffset = value);

      ///set the min exposure value
      AppInternalCash = await getTemporaryDirectory();

      /// getting the directory path && getting the last picture to put it in the thumbnail && getting the list of images paths
      getFilePath().then((value) {
        AppExternalPath = value;
        Directory directory = getDir(value);
        Stream<FileSystemEntity> fileStream = directory.list();
        directory.list().toList().then((value) {
          imagesPaths = value;
        }).catchError((onError) {
          print(onError);
        });
        fileStream.last.then((value) {
          thumbNailPath = value.path;
          isEmpty = false;
          setState(() {});
        }).catchError((onError) {
          print(onError);
        });
      }).catchError((onError) {
        print(onError);
      });
    }).catchError((onError) {
      isCameraInitialized = false;
    });
  }

  @override
  void dispose() {
    //release allocated memory used by camera
    cameraController!.dispose();
    _stopWatchTimer!.dispose().then((value) {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!cameraController!.value.isInitialized) {
      print(2222);
      return Container(
        color: Colors.black,
      );
    } else {
      return Scaffold(
        drawer: NavBar(),
        backgroundColor: Colors.black,
        appBar: AppBar(
            centerTitle: true,
            title: durationSelectorPressed && !IsRecording
                ? TabBar(
                    controller: _fileDurationTabController,
                    indicatorColor: Colors.grey.withOpacity(0),
                    isScrollable: true,
                    tabs: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Text(
                            "1",
                            style: TextStyle(
                                color: oneMinSelected
                                    ? Colors.amber
                                    : Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.access_time_rounded,
                              color:
                                  oneMinSelected ? Colors.amber : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Text(
                            "3",
                            style: TextStyle(
                                color: threeMinSelected
                                    ? Colors.amber
                                    : Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.access_time_rounded,
                              color: threeMinSelected
                                  ? Colors.amber
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Text(
                            "5",
                            style: TextStyle(
                                color: fiveMinSelected
                                    ? Colors.amber
                                    : Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.access_time_rounded,
                              color:
                                  fiveMinSelected ? Colors.amber : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                    onTap: (index) {
                      if (index == 0) {
                        oneMinSelected = true;
                        threeMinSelected = false;
                        fiveMinSelected = false;
                        durationSelectorText = "1";
                        fileDurationInSec = 60;
                        setState(() {});
                      } else if (index == 1) {
                        oneMinSelected = false;
                        threeMinSelected = true;
                        fiveMinSelected = false;
                        durationSelectorText = "3";
                        fileDurationInSec = 180;
                        setState(() {});
                      } else {
                        oneMinSelected = false;
                        threeMinSelected = false;
                        fiveMinSelected = true;
                        durationSelectorText = "5";
                        fileDurationInSec = 300;
                        setState(() {});
                      }
                      _fileDurationTabController.animateTo(index);
                    },
                  )
                : Container(),
            backgroundColor: Colors.black,
            actions: !IsPictureMode
                ? [
                    // IconButton(
                    //   onPressed: (){},
                    //   icon: Icon(
                    //       Icons.settings,
                    //     color: Colors.amber,
                    //     size: 30,
                    //   ),
                    //
                    // ),
                    durationSelectorPressed == false && IsRecording == false
                        ? Stack(
                            children: [
                              Text(
                                "$durationSelectorText",
                                style: TextStyle(color: Colors.amber),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.access_time_rounded,
                                  color: Colors.amber,
                                  size: 30,
                                ),
                                onPressed: () {
                                  durationSelectorPressed =
                                      !durationSelectorPressed;
                                  setState(() {});
                                },
                              ),
                            ],
                          )
                        : Container(),
                    durationSelectorPressed == false && IsRecording == false
                        ? IconButton(
                            onPressed: () {
                              if (IsMicEnabled) {
                                IsMicEnabled = false;
                                setState(() {});
                              } else {
                                IsMicEnabled = true;
                                setState(() {});
                              }
                            },
                            icon: Icon(
                              IsMicEnabled
                                  ? Icons.mic_outlined
                                  : Icons.mic_off_rounded,
                              color: Colors.amber,
                            ))
                        : Container(),
                  ]
                : [],
            leading: durationSelectorPressed == false && IsRecording == false
                ? IconButton(
                    icon: Icon(
                      flashOpened ? Icons.flash_on : Icons.flash_off,
                      size: 20,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        flashOpened = !flashOpened;
                      });
                    },
                  )
                : Container()),
        body: Stack(
          children: [
            Container(
              child: isCameraInitialized
                  ? GestureDetector(
                      onDoubleTap: () {
                        if (!fullyZoomed) {
                          cameraController!.setZoomLevel(maxZoom);
                          fullyZoomed = true;
                        } else {
                          fullyZoomed = false;
                          cameraController!.setZoomLevel(minZoom);
                        }
                      },
                      onTap: () {
                        cameraController!.setFocusMode(FocusMode.auto);
                        if (durationSelectorPressed) {
                          durationSelectorPressed = false;
                          setState(() {});
                        }
                      },
                      onScaleStart: (details) {
                        baseScaleFactor = scaleFactor;
                      },
                      onScaleUpdate: (details) {
                        isZooming = true;
                        setState(() {});
                        scaleFactor = baseScaleFactor * details.scale;
                        if (1 <= scaleFactor && scaleFactor <= maxZoom) {
                          cameraController!.setZoomLevel(scaleFactor);
                        }
                      },
                      child: AspectRatio(
                        aspectRatio: 1 / cameraController!.value.aspectRatio,
                        child: CameraPreview(
                          cameraController!,
                        ),
                      ))
                  : Container(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${ExposureSliderValue.toStringAsFixed(1)} x",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Container(
                  height: 20,
                  child: Slider(
                      value: ExposureSliderValue,
                      min: _minAvailableExposureOffset,
                      max: _maxAvailableExposureOffset,
                      thumbColor: Colors.white,
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey,
                      onChanged: (value) {
                        ExposureSliderValue = value;
                        cameraController!
                            .setExposureOffset(ExposureSliderValue);
                        setState(() {});
                      }),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: !IsRecording
                        ? TabBar(
                            indicator: BoxDecoration(
                                color: Color(0xff212121),
                                borderRadius: BorderRadius.circular(10)),
                            controller: _tabController,
                            isScrollable: true,
                            tabs: [
                              Text(
                                "image",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "video",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                            onTap: (mode) {
                              if (mode == VideoMode) {
                                IsPictureMode = false;
                                setState(() {});
                              } else {
                                IsPictureMode = true;
                                setState(() {});
                              }
                            },
                          )
                        : Container()),
                Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      !IsRecording
                          ? InkWell(
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                    radius: isEmpty == true ||
                                            !thumbNailPath.endsWith(".jpg")
                                        ? 15
                                        : 25,
                                    backgroundImage: isEmpty == false &&
                                            thumbNailPath.endsWith(".jpg")
                                        ? Image.file(File(thumbNailPath)).image
                                        : Image.asset(
                                                "assets/images/defaultThumbnail.png")
                                            .image),
                              ),
                              onTap: () async {
                                Directory directory =
                                    Directory(AppExternalPath);
                                directory.list().length.then((value) {
                                  if (value == 0) {
                                    showCustomToast(
                                      msg: "you don't have any media.",
                                      backGroundColor: Color(0xff343434),
                                      textColor: Colors.white,
                                      fontSize: 16,
                                    );
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CameraGallery(imagesPaths)));
                                  }
                                }).catchError((onError) {});
                              },
                            )
                          : IconButton(
                              color: Colors.white,
                              onPressed: () {
                                if (!isPaused) {
                                  cameraController!
                                      .pauseVideoRecording()
                                      .then((value) {
                                        durationTimer!.cancel();
                                        processingTimer!.cancel();
                                        remainingTime=fileDurationInSec-customProcessingTimer;
                                    isPaused = !isPaused;
                                    _stopWatchTimer!.onExecute
                                        .add(StopWatchExecute.stop);
                                    setState(() {});
                                  }).catchError((onError) {});
                                } else {
                                  print(remainingTime);
                                  cameraController!
                                      .resumeVideoRecording()
                                      .then((value) {
                                    durationTimer=recordingTimer(
                                        duration:remainingTime,
                                        cameraController: cameraController,
                                        IsRecording: IsRecording,
                                        videoClips: videoClips,
                                        function:  (){
                                          setState((){});
                                        }
                                    );
                                    processingTimer=Timer.periodic(Duration(seconds: 1), (timer) {
                                      print(customProcessingTimer);
                                      if(IsRecording&&!isPaused) {
                                        customProcessingTimer += 1;
                                        setState(() {});
                                      }
                                    });
                                    isPaused = !isPaused;
                                    _stopWatchTimer!.onExecute
                                        .add(StopWatchExecute.start);
                                    setState(() {});
                                  }).catchError((OnError) {});
                                }
                              },
                              icon: isPaused
                                  ? Icon(Icons.play_arrow_sharp)
                                  : Icon(Icons.pause)),
                      Padding(
                        padding: const EdgeInsets.only(left: 100, right: 100),
                        child: InkWell(
                          child: IsPictureMode
                              ?  CircleAvatar(
                                  radius: 28,
                                  backgroundColor:Colors.white,
                                )
                              : CircleAvatar(
                                  radius: 28,
                                  backgroundColor: customProcessingTimer<=(fileDurationInSec-3)?Colors.white:Colors.grey,
                                  child: !IsRecording
                                      ? CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Colors.red,
                                        )
                                      : Container(
                                          color: Colors.red,
                                          height: 20,
                                          width: 20,
                                        )),
                          onTap:customProcessingTimer<=fileDurationInSec-3? () async {
                            print("$isProcessingVideo fsdsfd");
                            if (flashOpened) {
                              cameraController!.setFlashMode(FlashMode.torch);
                            }
                            if (IsPictureMode) {
                              cameraController!
                                  .takePicture()
                                  .then((value) async {
                                await player.play(AssetSource(
                                    "audio/camera-shutter-sound.mp3"));
                                cameraController!.setFlashMode(FlashMode.off);
                                String path = await getFilePath();
                                Directory d = Directory(path);
                                value.saveTo("$path/${value.name}");
                                Stream<FileSystemEntity> fileStream = d.list();
                                fileStream.last.then((file) {
                                  imagesPaths.add(file);
                                  thumbNailPath = file.path;
                                  setState(() {
                                    isEmpty = false;
                                  });
                                });
                                // to upgrade the thumbnail
                              }).catchError((onError) {});
                            } else {
                              if (IsRecording&&cameraController!.value.isRecordingVideo) {
                                // after stopping the record
                                IsRecording = false;
                                _stopWatchTimer!.onExecute
                                    .add(StopWatchExecute.stop);
                                if(customProcessingTimer<=fileDurationInSec-3) {
                                  customProcessingTimer=0;
                                  cameraController!
                                      .stopVideoRecording()
                                      .then((video) async {
                                    var info=await videoInfo.getVideoInfoInstance()!.getVideoInfo(video.path);
                                    int duration=info!.duration!~/1000;
                                    print("sdflisldfsiuldj");
                                    print(duration);
                                    print("sdflisldfsiuldj");
                                    VideoModel videoModel=VideoModel(video.path,isFlagged: isFlagged,flagsModels:Flags,videoDuration: duration );
                                    Flags=[];
                                    if(videoModel.isFlagged){
                                      box!.add(videoModel);
                                    }
                                    cameraController!.setFlashMode(FlashMode.off);
                                    videoClips.add(videoModel);
                                        processingTimer!.cancel();
                                    durationTimer!.cancel();
                                    for(int modelIndex=0; modelIndex<videoClips.length; modelIndex++){
                                      print(videoClips.elementAt(modelIndex).path);
                                      File f=File(videoClips[modelIndex].path.toString());
                                      String path=videoClips[modelIndex].path.toString();
                                      int index=path.lastIndexOf("/");
                                      f.copy("$AppExternalPath/${videoClips[modelIndex].path.toString().substring(index+1,path.length)}");
                                      if(!isFlagged) {
                                        File(path).delete();
                                      }
                                    }
                                    isFlagged=false; //reset to initial value
                                    videoClips=[];
                                    // release the list of videos
                                  }).catchError((onError) {
                                    print("$onError");
                                  });
                                  setState(() {
                                  });
                                }// return to it
                              } else {
                                durationTimer=recordingTimer(
                                  duration: fileDurationInSec+1,
                                  cameraController: cameraController,
                                  IsRecording: IsRecording,
                                  videoClips: videoClips,
                                  function: (){
                                    setState((){
                                      customProcessingTimer=0;
                                    });
                                  }
                                );
                                cameraController!
                                    .startVideoRecording()
                                    .then((value) async {
                                  processingTimer=Timer.periodic(Duration(seconds: 1), (timer) {
                                    if(IsRecording&&!isPaused) {
                                      customProcessingTimer += 1;
                                      print(customProcessingTimer);
                                      setState(() {});
                                    }
                                  });
                                  _stopWatchTimer = StopWatchTimer();
                                  IsRecording = true;
                                  _stopWatchTimer!.onExecute
                                      .add(StopWatchExecute.start);
                                  setState(() {});
                                }).catchError((onError) {
                                  print(onError);
                                });
                              }
                            }
                          }:(){
                            showCustomToast(msg: "wait for some seconds (camera is processing data)", textColor: Colors.black, fontSize: 17, backGroundColor: Colors.white);
                          },
                        ),
                      ),
                      !IsRecording
                          ? IconButton(
                              iconSize: 30,
                              onPressed: () {
                                if (isFrontCameraOpened == false) {
                                  cameraController = CameraController(
                                      MyAvailableCameras![1],
                                      ResolutionPreset.max);
                                  rotateCamera = true;
                                } else {
                                  cameraController = CameraController(
                                      MyAvailableCameras![0],
                                      ResolutionPreset.max);
                                  rotateCamera = false;
                                }
                                cameraController!.initialize().then((value) {
                                  setState(() {
                                    isFrontCameraOpened = !isFrontCameraOpened;
                                  });
                                }).catchError((onError) {});
                              },
                              icon: Icon(
                                Icons.switch_camera_outlined,
                                color: Colors.white,
                              ))
                          : InkWell(
                              onTap: () {
                                isFlagged=true;
                                flagPoint=customProcessingTimer;
                                FlagModel model=FlagModel(beforeFlag: 5,afterFlag: 8,flagPoint: flagPoint);
                                Flags.add(model);
                                showCustomToast(
                                    msg:
                                        "flagged on ${_stopWatchTimer!.minuteTime.value}:${_stopWatchTimer!.secondTime.value}",
                                    textColor: Colors.black,
                                    fontSize: 17,
                                    backGroundColor: Colors.white);
                              },
                              child: Icon(
                                Icons.flag,
                                color: Colors.white,
                              ),
                            )
                    ],
                  ),
                ),
              ],
            ),
            !IsRecording
                ? Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(7)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: DropdownButton<ResolutionPreset>(
                            dropdownColor: Colors.black87,
                            underline: Container(),
                            value: currentResolutionPreset,
                            items: [
                              for (ResolutionPreset preset in resolutionPresets)
                                DropdownMenuItem(
                                  child: Text(
                                    preset
                                        .toString()
                                        .split('.')[1]
                                        .toUpperCase(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  value: preset,
                                )
                            ],
                            onChanged: (value) {
                              currentResolutionPreset = value!;
                              if (isFrontCameraOpened) {
                                cameraController = CameraController(
                                    MyAvailableCameras![1],
                                    currentResolutionPreset);
                                cameraController!.initialize().then((value) {
                                  setState(() {});
                                });
                              } else {
                                cameraController = CameraController(
                                    MyAvailableCameras![0],
                                    currentResolutionPreset);
                                cameraController!.initialize().then((value) {
                                  setState(() {});
                                });
                              }
                            },
                            hint: Text("Select item"),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            IsRecording
                ? Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      child: StreamBuilder<int>(
                        stream: _stopWatchTimer!.rawTime,
                        initialData: _stopWatchTimer!.rawTime.value,
                        builder: (context, snap) {
                          final value = snap.data;
                          final displayTime = StopWatchTimer.getDisplayTime(
                              value!,
                              hours: true);
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "$displayTime",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      );
    }
  }

  @override
  void onLifecycleEvent(LifecycleEvent event) {
    if (!isCameraInitialized) {
      if (isFrontCameraOpened == true && rotateCamera == true) {
        cameraController =
            CameraController(MyAvailableCameras![1], ResolutionPreset.max);
      } else {
        cameraController =
            CameraController(MyAvailableCameras![0], ResolutionPreset.max);
      }
      isCameraInitialized = true;
      setState(() {
        cameraController!.initialize().then((value) {});
      });
    }
//when the app camera goes to invisible state=>allocate memory
    if (event == LifecycleEvent.invisible) {
      cameraController!.dispose().then((value) {
        isCameraInitialized = false;
      }).catchError((onError) {});
    }
    //on every life cycle event=> read the media again(to make the thumbnail sync with the latest media stored)
    // the user may put the app in the background , then the user may delete the camera folder , so the
    //thumbnail must be aware of this update and put its default image.
    getFilePath().then((value) {
      Directory d = getDir(value);
      Stream<FileSystemEntity> fileStream = d.list();
      fileStream.last.then((value) {
        thumbNailPath = value.path;
        setState(() {});
        isEmpty = false;
      }).catchError((onError) {
        // this error is thrown when the file system stream is empty
        isEmpty = true;
        imagesPaths = [];
        setState(() {});
      });
    }).catchError((onError) {});
  }
}
