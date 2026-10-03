import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/LoadingScreen/LoadingAnimations.dart';
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
    LucideIcons.folder400Dir,
    LucideIcons.folderHeart400Dir,
    LucideIcons.folderOpen400Dir,
    LucideIcons.bookmark400Dir,
    LucideIcons.star400Dir,
    LucideIcons.heart400Dir,
    LucideIcons.brain400Dir,
    LucideIcons.lightbulb400Dir,
    LucideIcons.target400Dir,
    LucideIcons.rocket400Dir,
    LucideIcons.flame400Dir,
    LucideIcons.zap400Dir,
    LucideIcons.medal400Dir,
    LucideIcons.trophy400Dir,
    LucideIcons.gem400Dir,
    LucideIcons.bookOpen400Dir,
    LucideIcons.notebook400Dir,
    LucideIcons.graduationCap400Dir,
    LucideIcons.compass400Dir,
    LucideIcons.puzzle400Dir,
    LucideIcons.atom400Dir,
    LucideIcons.code400Dir,
    LucideIcons.infinity400Dir,
    LucideIcons.dices400Dir,
    LucideIcons.sparkles400Dir,
  ];

  final List<Color> tileColors = [Colors.green, Colors.orange, Colors.blue];

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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error), backgroundColor: Colors.red));
          }
          if (state is MyQuestionsActionSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.green));
          }
          if (state is MyQuestionsLoadedState && state.collectionQuestions.isNotEmpty && _selectedCollection != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CollectionQuestionPage(collection: _selectedCollection!))).then((_) {
              _selectedCollection = null;
            });
          }
        },
        builder: (context, state) {
          if (state is MyQuestionsInitialState || state is MyQuestionsLoadingState) {
            return Center(child: LoadingLogo());
          }

          if (state is MyQuestionsLoadedState) {
            List<Collection> filteredCollections = state.collections.where((col) {
              return col.collectionname.toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();

            return SafeArea(
              child: Column(
                children: [
                  SizedBox(height: height*0.004,),
                  _appBar(height, width),
                  Container(color: const Color.fromRGBO(220, 220, 220, 0.8),height: 1,width: width,),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _headerSection(height, width, state.collections),
                          SizedBox(height: height*0.025,),
                          _searchBar(height, width),
                          SizedBox(height: height*0.025,),
                          _collectionsHeader(height, width, filteredCollections.length),
                          SizedBox(height: height*0.012,),
                          if (filteredCollections.isEmpty)
                            _emptyState(height, width, state.collections.isEmpty)
                          else
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: width*0.05),
                              child: Wrap(
                                spacing: width*0.03,runSpacing: width*0.03,
                                children: filteredCollections.map((col) => _collectionTile(height, width, col)).toList(),
                              ),
                            ),
                          SizedBox(height: height*0.05,),
                        ],
                      ),
                    ),
                  ),
                  Container(color: const Color.fromRGBO(220, 220, 220, 0.8),height: 1,width: width,),
                  SizedBox(height: height*0.015,),
                  _createCollectionButton(height, width),
                  SizedBox(height: height*0.015,),
                ],
              ),
            );
          }

          return Center(child: Text("Error loading collections", style: TextStyle(color: Colors.red, fontFamily: Fonts.nunito)));
        },
      ),
    );
  }

  Widget _appBar(double height,double width){
    return Container(
      height: height*0.05,
      margin: EdgeInsets.symmetric(horizontal: width*0.05),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(LucideIcons.chevronLeft400Dir,size: Responsive.icon(context, 25),)),
          SizedBox(width: width*0.05,),
          Expanded(child: Text("My Questions",style: TextStyle(color: Colors.black,fontFamily: Fonts.rubik,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 18)),)),
        
        ],
      ),
    );
  }

  Widget _headerSection(double height,double width,List<Collection> collections){
    int total = 0;
    for(Collection c in collections){
      total += c.questions;
    }
    return Padding(
      padding: EdgeInsets.only(top: height*0.015,left: width*0.05,right: width*0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Your",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 26),fontWeight: FontWeight.w600,color: Colors.black),),
              Text(" Saved",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 26),fontWeight: FontWeight.w600,color: Colors.green),),
              Text(" Questions",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 26),fontWeight: FontWeight.w600,color: Colors.black),),
              Text(".",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 26),fontWeight: FontWeight.w600,color: Colors.green),),
            ],
          ),
          Text("Everything you bookmarked while practicing, sorted into collections",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 10),color: const Color.fromRGBO(110, 110, 110, 1)),),
          
       /*   Row(
            children: [
              _headerStat(width, total.toString(), total == 1 ? "Question" : "Questions"),
              SizedBox(width: width*0.08,),
              _headerStat(width, collections.length.toString(), collections.length == 1 ? "Collection" : "Collections"),
            ],
          ), */
        ],
      ),
    );
  }

  Widget _headerStat(double width,String stat,String name){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(stat,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 30),fontWeight: FontWeight.w600,color: Colors.black),),
        SizedBox(width: width*0.015,),
        Text(name,style: TextStyle(fontFamily: Fonts.rubik,fontSize: Responsive.font(context, 12),color: const Color.fromRGBO(120, 120, 120, 1)),),
      ],
    );
  }

  Widget _collectionsHeader(double height,double width,int count){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width*0.05),
      child: Row(
        children: [
          Expanded(child: Text("COLLECTIONS",style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 11),fontWeight: FontWeight.bold,color: Colors.blueGrey,letterSpacing: 1),)),
          Text("$count shown",style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 11),color: Colors.blueGrey),),
        ],
      ),
    );
  }

  Widget _searchBar(double height,double width){
    final radius = BorderRadius.circular(Responsive.icon(context, 3));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width*0.05),
      child: TextField(
        onChanged: (val) {
          setState(() {
            searchQuery = val;
          });
        },
        cursorColor: Colors.green,
        style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 13)),
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: Icon(LucideIcons.search400Dir,color: const Color.fromRGBO(120, 120, 120, 1),size: Responsive.icon(context, 18),),
          hintText: "Search your collections",
          hintStyle: TextStyle(fontFamily: Fonts.outfit,color: const Color.fromRGBO(120, 120, 120, 1),fontSize: Responsive.font(context, 13)),
          contentPadding: EdgeInsets.symmetric(vertical: height*0.014),
          enabledBorder: OutlineInputBorder(borderRadius: radius,borderSide: const BorderSide(color: Color.fromRGBO(220, 220, 220, 0.8))),
          focusedBorder: OutlineInputBorder(borderRadius: radius,borderSide: const BorderSide(color: Colors.green)),
        ),
      ),
    );
  }

  // two tiles per row inside the Wrap
  Widget _collectionTile(double height,double width,Collection col){
    int iconIndex = col.iconIndex < collectionIcons.length && col.iconIndex >= 0 ? col.iconIndex : 0;
    Color color = tileColors[iconIndex % tileColors.length];

    return InkWell(
      onTap: () {
        _selectedCollection = col;
        BlocProvider.of<MyQuestionsBloc>(context).add(LoadCollectionQuestionsEvent(col.collectionId));
      },
      child: Container(
        width: width*0.435,
        padding: EdgeInsets.all(width*0.035),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.8)),
          borderRadius: BorderRadius.circular(Responsive.icon(context, 3))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: height*0.05,width: height*0.05,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Responsive.icon(context, 3)),color: color.withValues(alpha: 0.1)),
                child: Icon(collectionIcons[iconIndex],color: color,size: Responsive.icon(context, 22),)
                ),
                const Spacer(),
                Icon(LucideIcons.arrowUpRight400Dir,size: Responsive.icon(context, 16),color: const Color.fromRGBO(120, 120, 120, 1),),
              ],
            ),
            SizedBox(height: height*0.018,),
            Text(col.collectionname,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 14),fontWeight: FontWeight.w600,color: Colors.black),),
            Text(col.questions == 1 ? "1 Question" : "${col.questions} Questions",style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 11),color: Colors.blueGrey),)
          ],
        ),
      ),
    );
  }

  Widget _emptyState(double height,double width,bool noCollections){
    return SizedBox(
      height: height*0.25,width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(noCollections ? LucideIcons.folderOpen200Dir : LucideIcons.search200Dir,size: Responsive.icon(context, 40),color: const Color.fromRGBO(120, 120, 120, 1),),
          SizedBox(height: height*0.01,),
          Text(noCollections ? "No collections yet" : "No matching collections",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 16)),),
          Text(noCollections ? "Create a collection to start saving questions" : "Try a different name, or create a new collection",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 11),color: const Color.fromRGBO(110, 110, 110, 1)),),
        ],
      ),
    );
  }

  Widget _createCollectionButton(double height,double width){
    return InkWell(
      onTap: () {
        _showCreateCollectionBottomSheet(context);
      },
      child: Container(
        height: height*0.05,
        margin: EdgeInsets.symmetric(horizontal: width*0.05),
        decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(Responsive.icon(context, 3))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.plus400Dir,color: Colors.white,size: Responsive.icon(context, 18),),
            SizedBox(width: width*0.02,),
            Text("Create Collection",style: TextStyle(color: Colors.white,fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: Responsive.font(context, 14)),),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Responsive.icon(context, 10)))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            double height = MediaQuery.of(context).size.height;
            double width = MediaQuery.of(context).size.width;
            final radius = BorderRadius.circular(Responsive.icon(context, 3));

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  padding: EdgeInsets.all(width*0.05),
                  height: height*0.62,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(LucideIcons.bookmarkPlus400Dir,size: Responsive.icon(context, 20),),
                          const SizedBox(width: 8),
                          Text("Create New ",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 18),fontWeight: FontWeight.w700,color: Colors.green),),
                          Text("Collection",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 18),fontWeight: FontWeight.w700,color: Colors.black),),
                        ],
                      ),
                      Text("Organise your saved questions into a collection for future review",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 10),color: const Color.fromRGBO(110, 110, 110, 1)),),
                      SizedBox(height: height*0.025,),
                      Text("COLLECTION NAME",style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 10),fontWeight: FontWeight.bold,color: Colors.blueGrey,letterSpacing: 1),),
                      SizedBox(height: height*0.01,),
                      TextField(
                        cursorColor: Colors.green,
                        textCapitalization: TextCapitalization.words,
                        style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 13)),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "e.g. Tricky Mechanics",
                          hintStyle: TextStyle(fontFamily: Fonts.outfit,color: const Color.fromRGBO(120, 120, 120, 1),fontSize: Responsive.font(context, 13)),
                          contentPadding: EdgeInsets.symmetric(horizontal: width*0.035,vertical: height*0.014),
                          enabledBorder: OutlineInputBorder(borderRadius: radius,borderSide: const BorderSide(color: Color.fromRGBO(220, 220, 220, 0.8))),
                          focusedBorder: OutlineInputBorder(borderRadius: radius,borderSide: const BorderSide(color: Colors.green)),
                        ),
                        onChanged: (val) {
                          localNewCollectionName = val;
                        },
                      ),
                      SizedBox(height: height*0.025,),
                      Text("SELECT ICON",style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 10),fontWeight: FontWeight.bold,color: Colors.blueGrey,letterSpacing: 1),),
                      SizedBox(height: height*0.012,),
                      Expanded(
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6,crossAxisSpacing: 8,mainAxisSpacing: 8,childAspectRatio: 1),
                          itemCount: collectionIcons.length,
                          itemBuilder: (context, index) {
                            bool isSelected = localSelectedIconIndex == index;
                            Color color = tileColors[index % tileColors.length];
                            return InkWell(
                              onTap: () {
                                setModalState(() {
                                  localSelectedIconIndex = index;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
                                  borderRadius: radius,
                                  border: Border.all(color: isSelected ? color : const Color.fromRGBO(220, 220, 220, 0.8)),
                                ),
                                child: Icon(collectionIcons[index],size: Responsive.icon(context, 20),color: isSelected ? color : Colors.black,),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: height*0.02,),
                      InkWell(
                        onTap: () {
                          if (localNewCollectionName.isNotEmpty) {
                            BlocProvider.of<MyQuestionsBloc>(this.context).add(CreateNewCollectionEvent(collectionName: localNewCollectionName, iconIndex: localSelectedIconIndex));
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          height: height*0.05,
                          decoration: BoxDecoration(color: Colors.green,borderRadius: radius),
                          child: Center(child: Text("Create Collection",style: TextStyle(color: Colors.white,fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,fontSize: Responsive.font(context, 14)),)),
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
