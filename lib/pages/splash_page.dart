import 'package:flutter/material.dart';
import 'package:flutterapi/constants/app_images.dart';
import 'package:flutterapi/pages/post_pages/list_post_page.dart';
import 'package:flutterapi/utils/open_page_util.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();

    //Delay 1 sec
    Future.delayed(const Duration(seconds: 1), () async{
      //Open page
      openPageMaterial(const ListPostPage(), context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Image Logo
                Image.asset(AppImages.appLogo, width: 100, height: 100,),
                const Text("Flutter Rest API", style: TextStyle(color: Colors.black, fontSize: 20))
              ],
            ),
          )
        ],
      ),
    );
  }
}
