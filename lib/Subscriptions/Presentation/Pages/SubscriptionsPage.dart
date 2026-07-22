import 'package:flutter/material.dart';

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
    return Scaffold(
      body: SizedBox(
        height: height,width: width,
        child: Center(child: Text("Subscriptions are coming soon."),),
      ),
    );
  }
}