import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:study_mate/QuestionsSection/Domain/QuestionFilters.dart';
import 'package:study_mate/QuestionsSection/Presentation/FiltersBloc/FilterBloc.dart';
import 'package:study_mate/QuestionsSection/Presentation/FiltersBloc/FilterEvents.dart';
import 'package:study_mate/QuestionsSection/Presentation/FiltersBloc/FilterStates.dart';
import 'package:study_mate/fonts.dart';

class CustomOverlayWidget extends StatefulWidget {
  
  const CustomOverlayWidget({super.key});

  @override
  State<CustomOverlayWidget> createState() => _CustomOverlayWidgetState();
}

class _CustomOverlayWidgetState extends State<CustomOverlayWidget> {
  final LayerLink _layerLink = LayerLink();   // this is a ref to the widget so dropdown moves with teh text of whatever

  OverlayEntry? _overlayEntry;    // this is our overlay object
  
  bool get _isOpen => _overlayEntry != null;     // we decide open or close from the fact that overlay is null or not

  void _showOverlay(){
    _overlayEntry = _createOverlay();   // _createOverlay is written below
    Overlay.of(context).insert(_overlayEntry!);    // basically puts the overlay on top of scaffold
  }

  void _removeOverlay(){
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _toggle(){
    if(_isOpen){_removeOverlay();}
    else{_showOverlay();}
  }

  OverlayEntry _createOverlay(){
    return OverlayEntry(builder: (context) {
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;
     return Stack(
        children: [
          Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    _removeOverlay();
                  });
                },
              ),
            ),

            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset:  Offset(0, height*0.055),
              child: Material(
                elevation: 0.4,
                color: Colors.white,
                
                child: SizedBox(
                  height: height*0.15, width: width*0.8,
                  child: BlocBuilder<FilterBloc,FilterStates>(
                    builder: (context, state) {
                      List<Option> difficulties = [];
                      if(state is InitialFiltersState){difficulties = state.filters.difficulty;}
                      return ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: difficulties.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            print("clicked");
                            BlocProvider.of<FilterBloc>(context).add(FilterSelectEvent(filterNumber: 2, selectedIndex: index));
                          },
                          child: _difficultyOption(height, width, difficulties[index],index != difficulties.length-1), ) ,
                        );
                    }
                  ),
                ),
              ),
              )
        ],
      );
    },);
  }
  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return CompositedTransformTarget(
      link: _layerLink,

      child: GestureDetector(
        onTap: () {
         setState(() {
           _toggle();
         }); 
        },
        child: Container(
          height: height*0.06, width: width*0.8,
          decoration: BoxDecoration(
            color: Colors.white, 
            border: Border.all(width: 1.5, color: const Color.fromRGBO(220, 220, 220, 0.8)),
            borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SizedBox(width: width*0.025,),
                Icon(Bootstrap.bullseye,color: Colors.green,),
                SizedBox(width: width*0.032,),
                SizedBox( width: width*0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height*0.01,),
                      SizedBox(
                        height: height*0.015,
                        child: Text("LEVEL",style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 12),fontWeight: FontWeight.bold),)),
                      Text("Mixed (Recommended)",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 14),fontWeight: FontWeight.w600),)
                    ],
                  ),
                ),
               Icon(_isOpen ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_outlined)
              ],
            ),
        ),
      ),
    );
  }
}



Widget _difficultyOption(double height, double width,Option option, bool draw){
  return SizedBox(
    height: height*0.05,width: width*0.8,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              SizedBox(width: width*0.05,),
              SizedBox(width: width*0.65, child: Text(option.filterName.toUpperCase()),),
              if(option.isSelected) Icon(Icons.check) 
            ],
          ),
          SizedBox(height: height*0.012,),
         if(draw) Container(height: 1,width: width*0.8,color: const Color.fromRGBO(220, 220, 220, 0.8),)
        ],
      ),
    ),
  );
}