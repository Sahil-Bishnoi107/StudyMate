import 'package:flutter/material.dart';
import 'package:study_mate/fonts.dart';

class ProfileSection extends StatelessWidget {
 final String name;
 final String picUrl;
  ProfileSection({super.key,required this.name,required this.picUrl});
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
   // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Row(
      children: [
      Container(
        padding: EdgeInsets.only(left: width*0.085),
        width: width*0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello, ${username}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontFamily: Fonts.inter,fontSize: 30),),
            Text("Ready for Today's Challange",style: TextStyle(fontFamily: Fonts.nunito,fontSize: 12, color: const Color.fromRGBO(170, 170, 170, 1)),)
          ],
        ),
      ),
      Container(
        width: width*0.3,
        child: Center(
          child: Container(
            width: width*0.14,height: width*0.14,
            child: Image.network(
              picUrl, 
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context,error,st){
                return Container(
                   height: 80,
                   width: 80,
                   decoration: BoxDecoration(border: Border.all(color: const Color.fromRGBO(180, 180, 180, 1),width: 1),borderRadius: BorderRadius.circular(60)),
                   child: Icon(Icons.person,size: 44,),
                );
              }),
          ),
        ),
      )
      ],
    );
  }
}