import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/Home/Domain/Entities/Question.dart';
import 'package:study_mate/LoadingScreen/LoadingAnimations.dart';
import 'package:study_mate/QuestionsSection/Data/QuestionsRepo.dart';
import 'package:study_mate/QuestionsSection/Domain/Collection.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/QuestionsBloc.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/QuestionsEvents.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/QuestionsStates.dart';
import 'package:study_mate/Test/Presentation/Widgets/fixedTextWidget.dart';
import 'package:study_mate/Test/Presentation/Widgets/question_option.dart';
import 'package:study_mate/fonts.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  bool isSubmitted = false;
  String? localSelectedOption;
  String newCollectionName = "";
  int selectedIconIndex = 0;
  bool isCreatingCollection = false;

 final List<IconData> collectionIcons = [
  LucideIcons.folder,
  LucideIcons.folderHeart,
  LucideIcons.folderOpen,
  LucideIcons.bookmark,
  LucideIcons.star,
  LucideIcons.heart,
  LucideIcons.brain,
  LucideIcons.lightbulb,
  LucideIcons.target,
  LucideIcons.rocket,
  LucideIcons.flame,
  LucideIcons.zap,
  LucideIcons.medal,
  LucideIcons.trophy,
  LucideIcons.gem,
  LucideIcons.bookOpen,
  LucideIcons.notebook,
  LucideIcons.graduationCap,
  LucideIcons.compass,
  LucideIcons.puzzle,
  LucideIcons.atom,
  LucideIcons.code,
  LucideIcons.infinity,
  LucideIcons.dices,
  LucideIcons.sparkles,
];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<Questionsbloc, Questionsstates>(
        listener: _blocListener,
        builder: (context, state) {
          if (state is FetchingQuestionsState) {
            return Center(
              child: LoadingLogo(),
            );
          }

          if (state is LoadQuestionsState) {
            Question currentQuestion = state.questions[state.currInd];
            
            return SingleChildScrollView(
              child: Column(
                children: [
                  _header(height, width, context, state),
                  SizedBox(height: height * 0.01),
                  Container(height: 1.5, width: width, color: const Color.fromRGBO(200, 200, 200, 0.6)),
                  SizedBox(height: height * 0.02),
                  _questionSection(height, width, currentQuestion, state.currInd, state.questions.length, context),
                ],
              ),
            );
          }

          return Center(
            child: Text(
              "Failed to load questions",
              style: TextStyle(color: Colors.red, fontFamily: Fonts.nunito),
            ),
          );
        },
      ),
    );
  }

  void _blocListener(BuildContext context, Questionsstates state) {
    if (state is QuestionsInitialState) {
      Navigator.pop(context);
    }
    if (state is QuestionSubmitFailedState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error),
          backgroundColor: Colors.red,
        ),
      );
    }
    if (state is QuestionFetchFailed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _header(double height, double width, BuildContext context, LoadQuestionsState state) {
    return Container(
      constraints: BoxConstraints(minHeight: height * 0.05, maxHeight: height * 0.1),
      width: width,
      padding: EdgeInsets.only(left: width * 0.03, right: width * 0.03),
      margin: EdgeInsets.only(top: height * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navigationButtons(context),
          _saveQuestionButton(height, width, context, state),
        ],
      ),
    );
  }

  Widget _navigationButtons(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () {
            BlocProvider.of<Questionsbloc>(context).add(ResetFiltersEvent());
          },
        ),
        Text("Question Practice", style : TextStyle(color : Colors.black, fontFamily : Fonts.outfit,fontWeight: FontWeight.w600, fontSize: 18))
      ],
    );
  }

  Widget _saveQuestionButton(double height, double width, BuildContext context, LoadQuestionsState state) {
    return GestureDetector(
      onTap: () {
        _showSaveBottomSheet(context, state);
      },
      child: Container(
        height: height * 0.035,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color.fromRGBO(200, 200, 200, 1)),
        ),
        child: Center(
          child: Row(
            children: [
              Icon(Bootstrap.bookmark, size: 15, color: Colors.green),
              SizedBox(width: width * 0.015),
              Text("Save to Collection", style: TextStyle(color: Colors.black, fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _questionSection(double height, double width, Question question, int currInd, int totalQuestions, BuildContext context) {
    return Column(
      children: [
        Container(
          width: width,
          height: height*0.72,
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _questionHeader(height, width, question, currInd, totalQuestions),
                SizedBox(height: height * 0.01),
                _questionDescription(height, width, question),
                SizedBox(height: height * 0.01),
                _optionsList(height, width, question),
              ],
            ),
          ),
        ),
        Container(height: 2, width: width, color: const Color.fromRGBO(200, 200, 200, 0.6)),
        SizedBox(height: height * 0.01),
        _actionButtons(height, width, question, context),
      ],
    );
  }

  Widget _questionHeader(double height, double width, Question question, int currInd, int totalQuestions) {
    String difficulty = question.difficulty;
    if (difficulty.length > 2) difficulty = difficulty[0].toUpperCase() + difficulty.substring(1);

    return Row(
      children: [
        Text("Question:",
            style: TextStyle(fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, fontSize: 15)),
        SizedBox(width: width * 0.2),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Bootstrap.exclamation_circle, size: 15, color: Colors.orange),
            SizedBox(width: 5),
            Text(difficulty, style: TextStyle(fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, color: Colors.grey[700])),
          ],
        )),
      ],
    );
  }

  Widget _questionDescription(double height, double width, Question question) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height * 0.03, maxHeight: height * 0.5, minWidth: width * 0.9, maxWidth: width * 0.9),
      child: MixedMathText(
        text: question.description,
        textStyle: TextStyle(fontFamily: Fonts.inter, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _optionsList(double height, double width, Question question) {
    return SizedBox(
      height: height * 0.45,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: question.options.length,
        itemBuilder: (context, index) {
          String option = question.options[index];
          String optionLetter = String.fromCharCode(65 + index);
          bool isSelected = localSelectedOption == option;
          
          if (isSubmitted) {
            bool isCorrect = option == question.correctOption;
            return QuestionReviewOption(option, height, width, isSelected || isCorrect, optionLetter, isCorrect);
          } else {
            return GestureDetector(
              onTap: () {
                setState(() {
                  localSelectedOption = option;
                });
              },
              child: QuestionOption(option, height, width, isSelected, optionLetter),
            );
          }
        },
      ),
    );
  }

  Widget _actionButtons(double height, double width, Question question, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _handleSubmit(question, context),
          child: Container(
            height: height * 0.06,
            width: width * 0.4,
            decoration: BoxDecoration(
              color: isSubmitted ? Colors.grey : Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text("Check", style: TextStyle(color: Colors.white, fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ),
        SizedBox(width: width * 0.05),
        GestureDetector(
          onTap: () => _handleNext(context),
          child: Container(
            height: height * 0.06,
            width: width * 0.4,
            decoration: BoxDecoration(
              color: isSubmitted ? Colors.green : Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text("Next", style: TextStyle(color: Colors.white, fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSubmit(Question question, BuildContext context) {
    if (localSelectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please select an option first"), 
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        ));
      return;
    }
    if (!isSubmitted) {
      setState(() {
        isSubmitted = true;
      });
      question.selectedOption = localSelectedOption;
      BlocProvider.of<Questionsbloc>(context).add(AnswerQuestion(option: localSelectedOption!));
      BlocProvider.of<Questionsbloc>(context).add(SubmitQuestionEvent(id: question.id, Subject: question.subject, difficulty: question.difficulty, isTrue: localSelectedOption == question.correctOption));
    }
  }

  void _handleNext(BuildContext context) {
    if (!isSubmitted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please submit your answer first"), duration: Duration(seconds: 1)));
      return;
    }
    setState(() {
      isSubmitted = false;
      localSelectedOption = null;
    });
    BlocProvider.of<Questionsbloc>(context).add(NextQuestionEvent());
  }

  void _showSaveBottomSheet(BuildContext context, LoadQuestionsState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            double height = MediaQuery.of(context).size.height;
            double width = MediaQuery.of(context).size.width;

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  padding: EdgeInsets.all(width * 0.05),
                  height: isCreatingCollection ? height * 0.6 : height * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                         const SizedBox(width: 5,),
                          Icon(Icons.bookmark_add_outlined),
                          const SizedBox(width: 5,),
                          Text("Save to ", style: TextStyle(fontFamily: Fonts.outfit, fontSize: 20, fontWeight: FontWeight.w600)),
                          
                           Text("Collection", style: TextStyle(fontFamily: Fonts.outfit, fontSize: 20, fontWeight: FontWeight.w600,color: Colors.green)),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 10,),
                         SizedBox(width: width*0.8,
                         child: Text("Organise your questions by choosing a collection to save this question for future review.",
                         style: TextStyle(fontFamily: Fonts.outfit,fontSize: 10,color: const Color.fromRGBO(110, 110, 110, 1)),
                         ), 
                         )
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      if (!isCreatingCollection) 
                        ..._buildCollectionsList(height, width, state, setModalState, context)
                      else 
                        ..._buildCreateCollectionForm(height, width, setModalState, context),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        isCreatingCollection = false;
        newCollectionName = "";
        selectedIconIndex = 0;
      });
    });
  }

  List<Widget> _buildCollectionsList(double height, double width, LoadQuestionsState state, StateSetter setModalState, BuildContext context) {
    return [
      Expanded(
        child: ListView.builder(
          itemCount: state.collections.length,
          itemBuilder: (context, index) {
            Collection col = state.collections[index];
            int ques = state.collections[index].questions;
            String que = ques == 1 ? "$ques Question" : "$ques Questions" ;
            return Column(
              children: [
                ListTile(
                  leading: Icon(collectionIcons[state.collections[index].iconIndex], color: Colors.green,size: 22,),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(col.collectionname, style: TextStyle(fontFamily: Fonts.nunito, fontSize: 13)),
                      Text(que,style: TextStyle(color: const Color.fromRGBO(110, 110, 110, 1), fontFamily: Fonts.outfit, fontSize: 10),)
                    ],
                  ),
                  
                  trailing: IconButton(
                    icon: Icon(LucideIcons.chevronRight, color: Colors.green),
                    onPressed: () => _addQuestionToCollection(col, state, context),
                  ),
                ),
                if(index != state.collections.length-1)Container(height: 1,color: const Color.fromRGBO(220, 220, 220, 0.8),width: width*0.88,)
              ],
            );
          },
        ),
      ),
      SizedBox(height: height * 0.01),
      SizedBox(
        width: double.infinity,
        height: height*0.05,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
          onPressed: () {
            setModalState(() {
              isCreatingCollection = true;
            });
          },
          child: Text("Create New Collection", style: TextStyle(color: Colors.white, fontFamily: Fonts.nunito)),
        ),
      ),
    ];
  }

  Future<void> _addQuestionToCollection(Collection col, LoadQuestionsState state, BuildContext context) async {
    QuestionsRepo repo = BlocProvider.of<Questionsbloc>(context).questionsRepo;
    var res = await repo.AddCollection(col.collectionId, state.questions[state.currInd].id);
    Navigator.pop(context);
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Question Saved"), backgroundColor: Colors.green,behavior: SnackBarBehavior.floating,),);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Question Not Saved"), backgroundColor: Colors.red,behavior: SnackBarBehavior.floating,));
    }
  }

  List<Widget> _buildCreateCollectionForm(double height, double width, StateSetter setModalState, BuildContext context) {
    return [
      TextField(
        decoration: InputDecoration(
          hintText: "Collection Name",
          hintStyle: TextStyle(fontFamily: Fonts.outfit, color: const Color.fromRGBO(110, 110, 110, 1)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
        ),
        onChanged: (val) {
          newCollectionName = val;
        },
      ),
      SizedBox(height: height * 0.02),
      Text("Select an Icon", style: TextStyle(fontFamily: Fonts.outfit, fontWeight: FontWeight.w600)),
      SizedBox(height: height * 0.01),
      _iconSelector(height, setModalState),
      Spacer(),
      SizedBox(
        width: double.infinity,
        height: height*0.05,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: () => _handleCreateCollection(context),
          child: Text("Create", style: TextStyle(color: Colors.white, fontFamily: Fonts.outfit,fontWeight: FontWeight.w600)),
        ),
      ),
    ];
  }

  Widget _iconSelector(double height, StateSetter setModalState) {
    return SizedBox(
      height: height * 0.25,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 1,
      ),
        scrollDirection: Axis.vertical,
        itemCount: collectionIcons.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setModalState(() {
                selectedIconIndex = index;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 4),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: selectedIconIndex == index ? Colors.green : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                collectionIcons[index],
                color: selectedIconIndex == index ? Colors.white : Colors.grey[600],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleCreateCollection(BuildContext context) async {
    if (newCollectionName.isNotEmpty) {
      QuestionsRepo repo = BlocProvider.of<Questionsbloc>(context).questionsRepo;
      var res = await repo.CreateCollection(newCollectionName, selectedIconIndex);
      if (res.statusCode == 200) {
        Navigator.pop(context);
        BlocProvider.of<Questionsbloc>(context).add(UpdateCollectionsEvent());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Collection Created"), backgroundColor: Colors.green));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to create collection"), backgroundColor: Colors.red));
      }
    }
  }
}