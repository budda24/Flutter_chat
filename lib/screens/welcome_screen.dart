import 'package:flash_chat/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';




class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController controller;


  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: Duration(seconds: 1), vsync:
    this);
    animation = ColorTween(begin: Colors.white, end: Colors.lightGreen.shade400)
        .animate
      (controller);
    animation.addListener(() {
      setState(() {

      });
    });
    controller.forward();

  }
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
  void moveToRegiste (){
    Navigator.pushNamed(context,"/registration");
  }
  void moveToLogIn(){
    Navigator.pushNamed(context,"/registration");
  }


  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag:'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                          'Online Tribes',
                        textStyle: TextStyle(
                          color: Colors.black,
                            fontSize: 45.0,
                            fontWeight: FontWeight.w900

                      ),
                        speed: const Duration(milliseconds: 30)
                      )],
                      ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(color: Colors.lightBlueAccent, title: 'Log In',
              onPressed:(){
                Navigator.pushNamed(context,"/login");
              },),
            RoundedButton(color: Colors.blueAccent, title: 'Register',
                onPressed:(){
                  Navigator.pushNamed(context,"/registration");
                }),
            /*Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30.0),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context,"/registration");
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Register',
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}

/*class RoundedButton extends StatelessWidget {
  Color _color;
  String _title;
  Function _onPressed;


  RoundedButton({this._color, this._title, this._onPressed});



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: _color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: () {
            Navigator.pushNamed(context,"/login");
          },
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            _title,
          ),
        ),
      ),
    );
  }
}*/
