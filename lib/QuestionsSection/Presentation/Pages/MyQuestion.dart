import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/QuestionsSection/Domain/Collection.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/MyQuestionsBloc/MyQuestionsBloc.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/MyQuestionsBloc/MyQuestionsEvents.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/MyQuestionsBloc/MyQuestionsStates.dart';
import 'package:study_mate/QuestionsSection/Presentation/Pages/CollectionQuestionPage.dart';
import 'package:study_mate/fonts.dart';

class MyQuestion extends StatefulWidget {
  const MyQuestion({super.key});

  @override
  State<MyQuestion> createState() => _MyQuestionState();
}

class _MyQuestionState extends State<MyQuestion> {
  String searchQuery = "";

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

  Collection? _selectedCollection;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MyQuestionsBloc>(context).add(LoadMyCollectionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<MyQuestionsBloc, MyQuestionsStates>(
        listener: (context, state) {
          if (state is MyQuestionsErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
          if (state is MyQuestionsActionSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is MyQuestionsLoadedState &&
              state.collectionQuestions.isNotEmpty &&
              _selectedCollection != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CollectionQuestionPage(collection: _selectedCollection!),
              ),
            ).then((_) {
              _selectedCollection = null;
            });
          }
        },
        builder: (context, state) {
          if (state is MyQuestionsInitialState ||
              state is MyQuestionsLoadingState) {
            return Center(
              child: LoadingAnimationWidget.beat(color: Colors.green, size: 50),
            );
          }

          if (state is MyQuestionsLoadedState) {
            return _buildContent(height, width, state);
          }

          return Center(child: Text("Error loading collections"));
        },
      ),
    );
  }

  Widget _buildContent(
    double height,
    double width,
    MyQuestionsLoadedState state,
  ) {
    // Local filtering
    List<Collection> filteredCollections = state.collections.where((col) {
      return col.collectionname.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height * 0.045),
        _header(height, width),
        Container(
          height: 1,
          width: width,
          color: const Color.fromRGBO(230, 230, 230, 1),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height * 0.01),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _headerText(height, width),

                      SizedBox(height: height * 0.015),
                      _searchBar(height, width),

                      SizedBox(height: height * 0.025),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "YOUR COLLECTIONS",
                            style: TextStyle(
                              fontFamily: Fonts.outfit,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "${filteredCollections.length} Total",
                            style: TextStyle(
                              fontFamily: Fonts.outfit,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      ...filteredCollections
                          .map((col) => _collectionTile(height, width, col))
                          .toList(),
                      SizedBox(height: height * 0.03),
                      _createCollectionButton(height, width),
                      SizedBox(height: height * 0.1), // padding at bottom
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _header(double height, double width) {
    return SizedBox(
      height: height * 0.05,
      child: Row(
        children: [
          SizedBox(width: width * 0.03),

          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(LucideIcons.chevronLeft, color: Colors.black, size: 25),
          ),
          SizedBox(width: width * 0.05),
          Text(
            "My Questions",
            style: TextStyle(
              fontFamily: Fonts.outfit,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar(double height, double width) {
    return Container(
      height: height * 0.055,
      decoration: BoxDecoration(
        color: Colors.white,

        border: Border.all(color: Colors.black),
      ),
      child: TextField(
        onChanged: (val) {
          setState(() {
            searchQuery = val;
          });
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.black),
          hintText: "Search your collections...",
          hintStyle: TextStyle(
            fontFamily: Fonts.outfit,
            color: const Color.fromRGBO(110, 110, 110, 1),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 15, top: height * 0.01),
        ),
      ),
    );
  }

  Widget _createCollectionButton(double height, double width) {
    return GestureDetector(
      onTap: () {
        _showCreateCollectionBottomSheet(context);
      },
      child: Container(
        width: width,
        height: height * 0.055,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          "Create Collection",
          style: TextStyle(
            color: Colors.white,
            fontFamily: Fonts.outfit,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _collectionTile(double height, double width, Collection col) {
    int iconIndex = col.iconIndex < collectionIcons.length && col.iconIndex >= 0
        ? col.iconIndex
        : 0;

    return GestureDetector(
      onTap: () {
        _selectedCollection = col;
        BlocProvider.of<MyQuestionsBloc>(
          context,
        ).add(LoadCollectionQuestionsEvent(col.collectionId));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: height * 0.02),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.03),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromRGBO(76, 175, 80, 0.5),
                ),
              ),
              child: Icon(
                collectionIcons[iconIndex],
                color: Colors.green,
                size: 24,
              ),
            ),
            SizedBox(width: width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    col.collectionname,
                    style: TextStyle(
                      fontFamily: Fonts.outfit,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  //  SizedBox(height: 5),
                  Text(
                    "${col.questions} Questions",
                    style: TextStyle(
                      fontFamily: Fonts.nunito,
                      color: Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showCreateCollectionBottomSheet(BuildContext context) {
    String localNewCollectionName = "";
    int localSelectedIconIndex = 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            double height = MediaQuery.of(context).size.height;
            double width = MediaQuery.of(context).size.width;

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: EdgeInsets.all(width * 0.05),
                  height: height * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 5),
                          Icon(Icons.bookmark_add_outlined),
                          const SizedBox(width: 5),
                          Text(
                            "Create New ",
                            style: TextStyle(
                              fontFamily: Fonts.outfit,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          Text(
                            "Collection",
                            style: TextStyle(
                              fontFamily: Fonts.outfit,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          SizedBox(
                            width: width * 0.8,
                            child: Text(
                              "Organise your questions by choosing a collection to save this question for future review.",
                              style: TextStyle(
                                fontFamily: Fonts.outfit,
                                fontSize: 10,
                                color: const Color.fromRGBO(110, 110, 110, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.03),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Collection Name",
                          hintStyle: TextStyle(
                            fontFamily: Fonts.outfit,
                            color: const Color.fromRGBO(110, 110, 110, 1),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        onChanged: (val) {
                          localNewCollectionName = val;
                        },
                      ),
                      SizedBox(height: height * 0.03),
                      Text(
                        "Select Icon",
                        style: TextStyle(
                          fontFamily: Fonts.outfit,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      SizedBox(
                        height: height * 0.25,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  localSelectedIconIndex = index;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 4),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: localSelectedIconIndex == index
                                      ? Colors.green
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  collectionIcons[index],
                                  color: localSelectedIconIndex == index
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: height*0.055,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            if (localNewCollectionName.isNotEmpty) {
                              BlocProvider.of<MyQuestionsBloc>(
                                this.context,
                              ).add(
                                CreateNewCollectionEvent(
                                  collectionName: localNewCollectionName,
                                  iconIndex: localSelectedIconIndex,
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            "Create Collection",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: Fonts.nunito,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

Widget _headerText(double height, double width) {
  return Row(
    children: [
      Text(
        "Manage",
        style: TextStyle(
          fontFamily: Fonts.outfit,
          color: Colors.black,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(
        " Your",
        style: TextStyle(
          fontFamily: Fonts.outfit,
          color: Colors.black,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(
        " Collections",
        style: TextStyle(
          fontFamily: Fonts.outfit,
          color: Colors.green,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}
