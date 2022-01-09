import 'package:flutter/material.dart';
import 'package:qvid/BottomNavigation/AddVideo/add_video.dart';

class ShowException {
  final BuildContext context;
  ShowException({required this.context});
  Container get exceptionContainer => Container(
        margin: EdgeInsets.only(left: 0.0, right: 0.0),
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: 18.0,
              ),
              margin: EdgeInsets.only(top: 13.0, right: 8.0),
              decoration: BoxDecoration(
                  color: Color(0xff2e2f34),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 0.0,
                      offset: Offset(0.0, 0.0),
                    ),
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                      child: Container(
                    height: 80,
                    width: 80,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage("assets/icons/camera-error.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ) //
                      ),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: new Text("Camera Error",
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Color(0xfff5ae78),
                            fontWeight: FontWeight.bold)),
                  ) //
                      ),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: const Text("Camera Stopped Working !!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                        )),
                  ) //
                      ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      child: Container(
                        padding: EdgeInsets.all(0),
                        height: 45,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                          colors: [Color(0xffec4a63), Color(0xff7350c7)],
                          begin: FractionalOffset(0.0, 1),
                          end: FractionalOffset(0.4, 4),
                          stops: [0.1, 0.7],
                        )),
                        child: const Center(
                          child: Text(
                            'Refresh',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'RockWellStd',
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => AddVideo()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
