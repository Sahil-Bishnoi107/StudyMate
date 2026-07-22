import 'package:flutter/material.dart';
import 'package:study_mate/fonts.dart';

class ProfileSection extends StatelessWidget {
 final String name;
 final String picUrl;

  const ProfileSection({super.key,required this.name,required this.picUrl});
  String fixName(String str){
    String ans = "";
    for(int i = 0;i < str.length;i++){
      if(str[i] == " ") return ans;
      ans += str[i];
    }
    return ans;
  }
  @override
  Widget build(BuildContext context) {
    String username = fixName(name);
 //   double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Row(
      children: [
      Container(
        padding: EdgeInsets.only(left: width*0.085),
        width: width*0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello, $username",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontFamily: Fonts.outfit,fontSize: 30),),
            Text("Ready for Today's Challange?",style: TextStyle(fontFamily: Fonts.nunito,fontSize: 12, color: Colors.blueGrey),)
          ],
        ),
      ),
      SizedBox(
        width: width*0.25,
        child: Center(
          child: SizedBox(
            width: width*0.14,height: width*0.14,
            child: Image.network(
              picUrl, 
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context,error,st){
                return Container(
                   height: 100,
                   width: 100,
                   decoration: BoxDecoration(border: Border.all(color: const Color.fromRGBO(180, 180, 180, 1),width: 1),borderRadius: BorderRadius.circular(60)),
                   child: Transform.scale(
                    scale: 1.3,
                    child: Image.asset('assets/images/profile_pic_girl.png',fit: BoxFit.cover,)
                  //child: Logo(height, width),
                   )
                );
              }),
          ),
        ),
      )
      ],
    );
  }
}