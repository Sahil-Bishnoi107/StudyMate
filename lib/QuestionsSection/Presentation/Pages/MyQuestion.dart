import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
    FontAwesome.book_solid,
    FontAwesome.graduation_cap_solid,
    FontAwesome.pencil_solid,
    FontAwesome.calculator_solid,
    FontAwesome.brain_solid,
    FontAwesome.bullseye_solid,
    FontAwesome.book_open_solid,
    FontAwesome.flask_solid,
    FontAwesome.lightbulb_solid,
    FontAwesome.bookmark_solid,
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
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
          }
          if (state is MyQuestionsLoadedState && state.collectionQuestions.isNotEmpty && _selectedCollection != null) {
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => CollectionQuestionPage(collection: _selectedCollection!)),
             ).then((_) {
                _selectedCollection = null;
             });
          }
        },
        builder: (context, state) {
          if (state is MyQuestionsInitialState || state is MyQuestionsLoadingState) {
             return Center(child: LoadingAnimationWidget.beat(color: Colors.green, size: 50));
          }

          if (state is MyQuestionsLoadedState) {
             return _buildContent(height, width, state);
          }

          return Center(child: Text("Error loading collections"));
        },
      ),
    );
  }

  Widget _buildContent(double height, double width, MyQuestionsLoadedState state) {
    // Local filtering
    List<Collection> filteredCollections = state.collections.where((col) {
      return col.collectionname.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(height, width),
            Container(height: 1, width: width, color: const Color.fromRGBO(230, 230, 230, 1)),
            SizedBox(height: height * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("My Questions", style: TextStyle(fontFamily: Fonts.inter, fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text("Organize and manage your study collections", style: TextStyle(fontFamily: Fonts.nunito, color: Colors.grey[600], fontSize: 14)),
                  SizedBox(height: height * 0.03),
                  _searchBar(height, width),
                  SizedBox(height: height * 0.03),
                  _createCollectionButton(height, width),
                  SizedBox(height: height * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("YOUR COLLECTIONS", style: TextStyle(fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
                      Text("${filteredCollections.length} Total", style: TextStyle(fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, color: Colors.green, fontSize: 12)),
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  ...filteredCollections.map((col) => _collectionTile(height, width, col)).toList(),
                  SizedBox(height: height * 0.05), // padding at bottom
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(double height, double width) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.flash_on, color: Colors.white, size: 20),
              ),
              SizedBox(width: 10),
              Text("My Questions", style: TextStyle(fontFamily: Fonts.inter, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          Icon(Icons.person_outline, size: 28),
        ],
      ),
    );
  }

  Widget _searchBar(double height, double width) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onChanged: (val) {
          setState(() {
            searchQuery = val;
          });
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          hintText: "Search your collections...",
          hintStyle: TextStyle(fontFamily: Fonts.nunito, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
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
        padding: EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white),
            SizedBox(width: 8),
            Text("Create Collection", style: TextStyle(color: Colors.white, fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _collectionTile(double height, double width, Collection col) {
    int iconIndex = col.iconIndex < collectionIcons.length && col.iconIndex >= 0 ? col.iconIndex : 0;
    
    return GestureDetector(
      onTap: () {
        _selectedCollection = col;
        BlocProvider.of<MyQuestionsBloc>(context).add(LoadCollectionQuestionsEvent(col.collectionId));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: height * 0.02),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(collectionIcons[iconIndex], color: Colors.green, size: 24),
            ),
            SizedBox(width: width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(col.collectionname, style: TextStyle(fontFamily: Fonts.inter, fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 5),
                  Text("${col.questions} Questions", style: TextStyle(fontFamily: Fonts.nunito, color: Colors.grey[600], fontSize: 13)),
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
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            double height = MediaQuery.of(context).size.height;
            double width = MediaQuery.of(context).size.width;

            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: EdgeInsets.all(width * 0.05),
                height: height * 0.45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Create New Collection", style: TextStyle(fontFamily: Fonts.outfit, fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: height * 0.03),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Collection Name",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onChanged: (val) {
                        localNewCollectionName = val;
                      },
                    ),
                    SizedBox(height: height * 0.03),
                    Text("Select Icon", style: TextStyle(fontFamily: Fonts.nunito, fontWeight: FontWeight.bold)),
                    SizedBox(height: height * 0.02),
                    SizedBox(
                      height: height * 0.08,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: collectionIcons.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                localSelectedIconIndex = index;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: localSelectedIconIndex == index ? Colors.green : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                collectionIcons[index],
                                color: localSelectedIconIndex == index ? Colors.white : Colors.grey[600],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: () {
                          if (localNewCollectionName.isNotEmpty) {
                            BlocProvider.of<MyQuestionsBloc>(this.context).add(
                              CreateNewCollectionEvent(
                                collectionName: localNewCollectionName,
                                iconIndex: localSelectedIconIndex,
                              )
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: Text("Create Collection", style: TextStyle(color: Colors.white, fontFamily: Fonts.nunito, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
