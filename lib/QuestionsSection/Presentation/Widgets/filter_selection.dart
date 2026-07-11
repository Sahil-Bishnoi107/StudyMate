import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/QuestionsSection/Domain/QuestionFilters.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/QuestionsBloc.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/QuestionsEvents.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/QuestionsStates.dart';

class FilterSelection extends StatefulWidget {
  final IconData icon;
  final int filterIndex;
  final String type;
  final List<Option> filterOptions;
  const FilterSelection({super.key,required this.filterOptions, required this.type,required this.filterIndex,required this.icon});

  @override
  State<FilterSelection> createState() => _FilterSelectionState();
}

class _FilterSelectionState extends State<FilterSelection> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
       width: width*0.9,
       constraints: BoxConstraints(minHeight: height*0.1, maxHeight: height*0.4),
      margin: EdgeInsets.symmetric(horizontal: width*0.05),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(210, 210, 210, 0.8), ),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white
      ),
      child: Column(
        children: [
          Row(children: [
            Icon(widget.icon), SizedBox(width: width*0.05,), Text(widget.type)
          ],),

          BlocBuilder<Questionsbloc,Questionsstates>(
            builder: (context, state) =>  Wrap(     
              spacing: height*0.02, runSpacing: width*0.02,
              children: List.generate(
                widget.filterOptions.length,
                 (index) => InkWell(
                  onTap: () {
                    BlocProvider.of<Questionsbloc>(context).add(FilterSelectEvent(filterNumber: widget.filterIndex, selectedIndex: index));
                  },
                  child: _tagWidget(height, width, widget.filterOptions[index].filterName, widget.filterOptions[index].isSelected)))
            ),
          )
        ],
      ),
    );
  }
}



Widget _tagWidget(double height, double width,String text,bool isSelected){
  return Container(
    height: height*0.05,
    padding: EdgeInsets.symmetric(horizontal: width*0.02),
    decoration: BoxDecoration(
      border: Border.all(color: isSelected ? Colors.green : const Color.fromRGBO(215, 215, 215, 0.8)),
      borderRadius: BorderRadius.circular(10),
      color: isSelected ? Colors.green : Colors.white
    ),
    child: Center(
      child: Text(text, style: TextStyle(color: isSelected ? Colors.white : Colors.black),),
    ),
  );
}