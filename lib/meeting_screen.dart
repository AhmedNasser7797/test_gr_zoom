import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gr_zoom/gr_zoom.dart';

ZoomOptions zoomOptions = ZoomOptions(
  domain: "zoom.us",
  appKey: zoomApiKey, //API KEY FROM ZOOM
  appSecret: zoomSdkSecrt, //API SECRET FROM ZOOM
);

const zoomApiKey = "zSSayO0ELjaCnT2tKsDc6JgsBWWWHYtW5UXt";
const zoomSdkSecrt = "nhsg2W9sJa0mHJPQPxIxQzLGDdNXK83qVutH";

class MeetingWidget extends StatefulWidget {
  const MeetingWidget({Key? key}) : super(key: key);

  @override
  _MeetingWidgetState createState() => _MeetingWidgetState();
}

class _MeetingWidgetState extends State<MeetingWidget> {
  TextEditingController meetingIdController =
      TextEditingController(text: "76687461403");
  TextEditingController meetingPasswordController =
      TextEditingController(text: "gtf3w1");
  late Timer timer;

  @override
  Widget build(BuildContext context) {
    // new page needs scaffolding!
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join meeting'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 32.0,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                controller: meetingIdController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Meeting ID',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                controller: meetingPasswordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Builder(
                builder: (context) {
                  // The basic Material Design action button.
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () => {
                      {joinMeeting(context)}
                    },
                    child: const Text('Join'),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Builder(
                builder: (context) {
                  // The basic Material Design action button.
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () => {
                      {startMeeting(context)}
                    },
                    child: const Text('Start Meeting'),
                  );
                },
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Builder(
            //     builder: (context) {
            //       // The basic Material Design action button.
            //       return ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //           primary: Colors.blue, // background
            //           onPrimary: Colors.white, // foreground
            //         ),
            //         onPressed: () => startMeetingNormal(context),
            //         child: const Text('Start Meeting With Meeting ID'),
            //       );
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  //API KEY & SECRET is required for below methods to work
  //Join Meeting With Meeting ID & Password
  joinMeeting(BuildContext context) {
    bool _isMeetingEnded(String status) {
      var result = false;

      if (Platform.isAndroid) {
        result = status == "MEETING_STATUS_DISCONNECTING" ||
            status == "MEETING_STATUS_FAILED";
      } else {
        result = status == "MEETING_STATUS_IDLE";
      }

      return result;
    }

    if (meetingIdController.text.isNotEmpty &&
        meetingPasswordController.text.isNotEmpty) {
      var meetingOptions = ZoomMeetingOptions(
          userId: 'username',

          /// pass username for join meeting only --- Any name eg:- EVILRATT.
          meetingId: meetingIdController.text,

          /// pass meeting id for join meeting only
          meetingPassword: meetingPasswordController.text,

          /// pass meeting password for join meeting only
          disableDialIn: "true",
          disableDrive: "true",
          disableInvite: "true",
          disableShare: "true",
          // disableTitlebar: "false",
          // viewOptions: "true",
          noAudio: "false",
          noDisconnectAudio: "false");

      var zoom = Zoom();
      zoom.init(zoomOptions).then((results) {
        if (results[0] == 0) {
          // zoom.onMeetingStatus().listen((status) {
          //   if (kDebugMode) {
          //     print(
          //         "[Meeting Status Stream] : " + status[0] + " - " + status[1]);
          //   }
          //   if (_isMeetingEnded(status[0])) {
          //     if (kDebugMode) {
          //       print("[Meeting Status] :- Ended");
          //     }
          //     timer.cancel();
          //   }
          // });
          if (kDebugMode) {
            print("listen on event channel");
          }
          zoom.joinMeeting(meetingOptions).then((joinMeetingResult) {
            timer = Timer.periodic(const Duration(seconds: 2), (timer) {
              zoom.meetingStatus(meetingOptions.meetingId).then((status) {
                if (kDebugMode) {
                  print("${"[Meeting Status Polling] : " + status[0]} - " +
                      status[1]);
                }
              });
            });
          });
        }
      }).catchError((error) {
        if (kDebugMode) {
          print("[Error Generated] : " + error);
        }
      });
    } else {
      if (meetingIdController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Enter a valid meeting id to continue."),
        ));
      } else if (meetingPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Enter a meeting password to start."),
        ));
      }
    }
  }

  //Start Meeting With Random Meeting ID ----- Emila & Password For Zoom is required.
  startMeeting(BuildContext context) {
    bool _isMeetingEnded(String status) {
      var result = false;

      if (Platform.isAndroid) {
        result = status == "MEETING_STATUS_DISCONNECTING" ||
            status == "MEETING_STATUS_FAILED";
      } else {
        result = status == "MEETING_STATUS_IDLE";
      }

      return result;
    }

    var meetingOptions = ZoomMeetingOptions(
        userId: 'evilrattdeveloper@gmail.com', //pass host email for zoom
        // userPassword: 'Dlinkmoderm0641', //pass host password for zoom
        disableDialIn: "false",
        disableDrive: "false",
        disableInvite: "false",
        disableShare: "false",
        // disableTitlebar: "false",
        // viewOptions: "true",
        noAudio: "false",
        displayName: "ahmed",
        noDisconnectAudio: "false",
        zoomAccessToken:
            "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOm51bGwsImlzcyI6ImF2QUlDR1c4VGZ1dkY3NTNVYXVxenciLCJleHAiOjE2ODYxNzUyODYsImlhdCI6MTY4NjE2OTg4N30.CFj4QYslu9hDXT-xVao0gTe-y5lkmpfnweRi2ioWx9U",
        meetingId: meetingIdController.text,
        meetingPassword: meetingPasswordController.text);

    var zoom = Zoom();
    zoom.init(zoomOptions).then((results) {
      if (results[0] == 0) {
        // zoom.onMeetingStatus().listen((status) {
        //   if (kDebugMode) {
        //     print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
        //   }
        //   if (_isMeetingEnded(status[0])) {
        //     if (kDebugMode) {
        //       print("[Meeting Status] :- Ended");
        //     }
        //     timer.cancel();
        //   }
        //   if (status[0] == "MEETING_STATUS_INMEETING") {
        //     zoom.meetinDetails().then((meetingDetailsResult) {
        //       if (kDebugMode) {
        //         print("[MeetingDetailsResult] :- " +
        //             meetingDetailsResult.toString());
        //       }
        //     });
        //   }
        // });
        zoom.startMeeting(meetingOptions).then((loginResult) {
          if (kDebugMode) {
            // print(
            //     "[LoginResult] :- " + loginResult[0] + " - " + loginResult[1]);
          }
          print("loginResult $loginResult");

          // if (loginResult) {
          //   //SDK INIT FAILED
          //   if (kDebugMode) {
          //     print("loginResult $loginResult");
          //   }
          //   return;
          // } else if (loginResult[0] == "LOGIN ERROR") {
          //   //LOGIN FAILED - WITH ERROR CODES
          //   if (kDebugMode) {
          //     if (loginResult[1] ==
          //         ZoomError.ZOOM_AUTH_ERROR_WRONG_ACCOUNTLOCKED) {
          //       print("Multiple Failed Login Attempts");
          //     }
          //     print((loginResult[1]).toString());
          //   }
          //   return;
          // } else {
          //   //LOGIN SUCCESS & MEETING STARTED - WITH SUCCESS CODE 200
          //   if (kDebugMode) {
          //     print((loginResult[0]).toString());
          //   }
          // }
        }).catchError((error) {
          if (kDebugMode) {
            print("[Error Generated] : " + error.toString());
          }
        });
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("[Error Generated] : " + error);
      }
    });
  }

  //Start Meeting With Custom Meeting ID ----- Emila & Password For Zoom is required.
  // startMeetingNormal(BuildContext context) {
  //   bool _isMeetingEnded(String status) {
  //     var result = false;
  //
  //     if (Platform.isAndroid) {
  //       result = status == "MEETING_STATUS_DISCONNECTING" ||
  //           status == "MEETING_STATUS_FAILED";
  //     } else {
  //       result = status == "MEETING_STATUS_IDLE";
  //     }
  //
  //     return result;
  //   }
  //
  //   ZoomOptions zoomOptions = ZoomOptions(
  //     domain: "zoom.us",
  //     appKey:
  //         "XKE4uWfeLwWEmh78YMbC6mqKcF8oM4YHTr9I", //API KEY FROM ZOOM -- SDK KEY
  //     appSecret:
  //         "bT7N61pQzaLXU6VLj9TVl7eYuLbqAiB0KAdb", //API SECRET FROM ZOOM -- SDK SECRET
  //   );
  //   var meetingOptions = ZoomMeetingOptions(
  //       userId: 'evilrattdeveloper@gmail.com', //pass host email for zoom
  //       // userPassword: 'Dlinkmoderm0641', //pass host password for zoom
  //       meetingId: meetingIdController.text, //
  //       disableDialIn: "false",
  //       disableDrive: "false",
  //       disableInvite: "false",
  //       disableShare: "false",
  //       // disableTitlebar: "false",
  //       // viewOptions: "false",
  //       noAudio: "false",
  //       noDisconnectAudio: "false", meetingPassword: meetingPasswordController.text);
  //
  //   var zoom = Zoom();
  //   zoom.init(zoomOptions).then((results) {
  //     if (results[0] == 0) {
  //       // zoom.onMeetingStatus().listen((status) {
  //       //   if (kDebugMode) {
  //       //     print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
  //       //   }
  //       //   if (_isMeetingEnded(status[0])) {
  //       //     if (kDebugMode) {
  //       //       print("[Meeting Status] :- Ended");
  //       //     }
  //       //     timer.cancel();
  //       //   }
  //       //   if (status[0] == "MEETING_STATUS_INMEETING") {
  //       //     zoom.meetinDetails().then((meetingDetailsResult) {
  //       //       if (kDebugMode) {
  //       //         print("[MeetingDetailsResult] :- " +
  //       //             meetingDetailsResult.toString());
  //       //       }
  //       //     });
  //       //   }
  //       // });
  //       zoom.startMeetingNormal(meetingOptions).then((loginResult) {
  //         if (kDebugMode) {
  //           print("[LoginResult] :- " + loginResult.toString());
  //         }
  //         if (loginResult[0] == "SDK ERROR") {
  //           //SDK INIT FAILED
  //           if (kDebugMode) {
  //             print((loginResult[1]).toString());
  //           }
  //         } else if (loginResult[0] == "LOGIN ERROR") {
  //           //LOGIN FAILED - WITH ERROR CODES
  //           if (kDebugMode) {
  //             print((loginResult[1]).toString());
  //           }
  //         } else {
  //           //LOGIN SUCCESS & MEETING STARTED - WITH SUCCESS CODE 200
  //           if (kDebugMode) {
  //             print((loginResult[0]).toString());
  //           }
  //         }
  //       });
  //     }
  //   }).catchError((error) {
  //     if (kDebugMode) {
  //       print("[Error Generated] : " + error);
  //     }
  //   });
  // }
}
