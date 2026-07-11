import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:study_mate/QuestionsSection/Domain/QuestionFilters.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/QuestionsBloc.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/QuestionsEvents.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/QuestionsStates.dart';

class CustomOverlayWidget extends StatefulWidget {
  
  const CustomOverlayWidget({super.key});

  @override
  State<CustomOverlayWidget> createState() => _CustomOverlayWidgetState();
}

class _CustomOverlayWidgetState extends State<CustomOverlayWidget> {
  final LayerLink _layerLink = LayerLink();   // this is a ref to the widget so dropdown moves with teh text of whatever

  OverlayEntry? _overlayEntry;
  
  bool get _isOpen => _overlayEntry != null;

  void _showOverlay(){
    _overlayEntry = _createOverlay();
    Overlay.of(context).insert(_overlayEntry!);
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
                onTap: _removeOverlay,
              ),
            ),

            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 50),
              child: Material(
                elevation: 5,
                color: Colors.white,
                child: SizedBox(
                  height: height*0.1, width: width*0.8,
                  child: BlocBuilder<Questionsbloc,Questionsstates>(
                    builder: (context, state) {
                      List<Option> difficulties = [];
                      if(state is QuestionsInitialState){difficulties = state.filters.difficulty;}
                      return ListView.builder(
                        itemCount: difficulties.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            BlocProvider.of<Questionsbloc>(context).add(FilterSelectEvent(filterNumber: 3, selectedIndex: index));
                          },
                          child: _difficultyOption(height, width, difficulties[index])) ,
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
          _toggle();
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
                Icon(Bootstrap.bullseye),
                SizedBox(width: width*0.02,),
                SizedBox( width: width*0.6,
                  child: Column(
                    children: [
                      Text("LEVEL"),
                      Text("Mixed (Recommended)")
                    ],
                  ),
                ),
               Icon(_isOpen ? Icons.keyboard_arrow_up_outlined : Icons.arrow_downward_outlined)
              ],
            ),
        ),
      ),
    );
  }
}



Widget _difficultyOption(double height, double width,Option option){
  return SizedBox(
    height: height*0.05,width: width*0.8,
    child: Row(
      children: [
        SizedBox(width: width*0.05,),
        SizedBox(width: width*0.6, child: Text(option.filterName),),
        option.isSelected ? Icon(Icons.check) : SizedBox.shrink()
      ],
    ),
  );
}