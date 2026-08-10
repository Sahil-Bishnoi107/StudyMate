import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:study_mate/fonts.dart';

class Subscriptionspage extends StatefulWidget {
  const Subscriptionspage({super.key});

  @override
  State<Subscriptionspage> createState() => _SubscriptionspageState();
}

class _SubscriptionspageState extends State<Subscriptionspage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Color greyCol = const Color.fromRGBO(150, 150, 150, 1);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: height*0.05,width: width,
            child: Row(
              children: [
                SizedBox(width: width*0.05,),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(LucideIcons.chevronLeft,size: Responsive.icon(context, 30),)),
                SizedBox(width: width*0.7,
                child: Center(
                  child: Text("Premium Plans",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 18)),),
                ),
                )
              ],
            ),
            ),
            Container(color: const Color.fromRGBO(220, 220, 220, 0.7),width: width*0.9,height: 1.5,),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  
                  children: [
                    SizedBox(height: height*0.3,),
                    Container(
                      height: height*0.1,width: height*0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(height*0.015),
                        //color: Colors.black,
                        border: Border.all(color: greyCol,width: 2)
                      ),
                      child: Icon(LucideIcons.zap,color: greyCol,size: Responsive.icon(context, 40),),
                    ),
                    SizedBox(height: height*0.05,),
                    Text("No Premimum plans available right now",style: TextStyle(color: Colors.grey[600]),)
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}