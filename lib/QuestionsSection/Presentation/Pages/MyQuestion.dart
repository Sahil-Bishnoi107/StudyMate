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


const Color _borderGrey = Color.fromRGBO(220, 220, 220, 0.8);
const Color _mutedText = Color.fromRGBO(100, 100, 100, 1);
const Color _greenTint = Color.fromRGBO(76, 175, 80, 0.1);
const Color _greenBorder = Color.fromRGBO(76, 175, 80, 0.2);

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
              child: LoadingLogo(),
            );
          }

          if (state is MyQuestionsLoadedState) {
            return SafeArea(child: _buildContent(height, width, state));
          }

          return Center(
            child: Text(
              "Error loading collections",
              style: TextStyle(color: Colors.red, fontFamily: Fonts.nunito),
            ),
          );
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
        _header(height, width),
        SizedBox(height: height * 0.005),
        Container(height: 1.25, width: width, color: _borderGrey),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               // SizedBox(height: height * 0.02),
               // _headerText(height, width, context),
                SizedBox(height: height * 0.02),
                _searchBar(height, width),
                SizedBox(height: height * 0.015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "YOUR COLLECTIONS",
                      style: TextStyle(
                        fontFamily: Fonts.rubik,
                        fontWeight: FontWeight.w600,
                        fontSize: Responsive.font(context, 14),
                      ),
                    ),
              /*      Text(
                      "${filteredCollections.length} Total",
                      style: TextStyle(
                        fontFamily: Fonts.nunito,
                        fontWeight: FontWeight.w700,
                        color: Colors.green,
                        fontSize: Responsive.font(context, 12),
                      ),
                    ),  */
                  ],
                ),
                SizedBox(height: height * 0.015),
                if (filteredCollections.isEmpty)
                  _emptyState(height, width, state.collections.isEmpty)
                else
                  ...filteredCollections.map(
                    (col) => _collectionTile(height, width, col),
                  ),
                SizedBox(height: height * 0.1), // padding at bottom
              ],
            ),
          ),
        ),
        Container(height: 1, width: width, color: _borderGrey),
        SizedBox(height: height * 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: _createCollectionButton(height, width),
        ),
        SizedBox(height: height * 0.02),
      ],
    );
  }

  Widget _header(double height, double width) {
    return SizedBox(
      height: height * 0.05,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: width * 0.03),
          IconButton(
            onPressed: () => Navigator.pop(context),
            tooltip: "Back",
            icon: Icon(
              LucideIcons.chevronLeft400Dir,
              color: Colors.black,
              size: Responsive.icon(context, 28),
            ),
          ),
          SizedBox(width: width * 0.02),
          Text(
            "My Questions",
            style: TextStyle(
              fontFamily: Fonts.rubik,
              fontWeight: FontWeight.w600,
              fontSize: Responsive.font(context, 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar(double height, double width) {
    final radius = BorderRadius.circular(Responsive.icon(context, 5));
    return TextField(
      onChanged: (val) {
        setState(() {
          searchQuery = val;
        });
      },
      cursorColor: Colors.green,
      style: TextStyle(
        fontFamily: Fonts.outfit,
        fontSize: Responsive.font(context, 14),
      ),
      decoration: InputDecoration(
        isDense: true,
        prefixIcon: Icon(
          LucideIcons.search400Dir,
          color: _mutedText,
          size: Responsive.icon(context, 20),
        ),
        hintText: "Search your collections...",
        hintStyle: TextStyle(
          fontFamily: Fonts.outfit,
          color: const Color.fromRGBO(118, 118, 118, 1),
          fontSize: Responsive.font(context, 14),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: height * 0.017),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: _borderGrey, width: 1.25),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: Colors.green, width: 1.25),
        ),
      ),
    );
  }

  Widget _emptyState(double height, double width, bool noCollections) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: height * 0.035,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Responsive.icon(context, 5)),
        border: Border.all(color: _greenBorder, width: 1.25),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _greenTint,
            ),
            child: Icon(
              noCollections ? LucideIcons.folderOpen400Dir : LucideIcons.search400Dir,
              color: Colors.green,
              size: Responsive.icon(context, 24),
            ),
          ),
          SizedBox(height: height * 0.012),
          Text(
            noCollections ? "No collections yet" : "No matching collections",
            style: TextStyle(
              fontFamily: Fonts.outfit,
              fontWeight: FontWeight.w600,
              fontSize: Responsive.font(context, 16),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            noCollections
                ? "Create a collection to start saving questions for later review"
                : "Try a different name, or create a new collection",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: Fonts.outfit,
              color: _mutedText,
              fontSize: Responsive.font(context, 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createCollectionButton(double height, double width) {
    return SizedBox(
      width: width,
      height: height * 0.06,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Responsive.icon(context, 10)),
          ),
        ),
        onPressed: () {
          _showCreateCollectionBottomSheet(context);
        },
        child: Text(
          "Create Collection",
          style: TextStyle(
            color: Colors.white,
            fontFamily: Fonts.nunito,
            fontWeight: FontWeight.w700,
            fontSize: Responsive.font(context, 16),
          ),
        ),
      ),
    );
  }

  Widget _collectionTile(double height, double width, Collection col) {
    int iconIndex = col.iconIndex < collectionIcons.length && col.iconIndex >= 0
        ? col.iconIndex
        : 0;
    final radius = BorderRadius.circular(Responsive.icon(context, 5));

    return Padding(
      padding: EdgeInsets.only(bottom: height * 0.01),
      child: Material(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: const BorderSide(color: _borderGrey, width: 1.25),
        ),
        child: InkWell(
          onTap: () {
            _selectedCollection = col;
            BlocProvider.of<MyQuestionsBloc>(
              context,
            ).add(LoadCollectionQuestionsEvent(col.collectionId));
          },
          child: SizedBox(
            height: height * 0.07,
            child: Row(
              children: [
                // Tinted icon block on the left edge of the tile
                Container(
                  width: width * 0.15,
                  height: double.infinity,
                  decoration:  BoxDecoration(
                    color: Colors.green,
                    border: Border(
                      right: BorderSide(color: _greenBorder, width: 1.25),
                    ),
                  ),
                  child: Icon(
                    collectionIcons[iconIndex],
                    color: Colors.white,
                    size: Responsive.icon(context, 22),
                  ),
                ),
                SizedBox(width: width * 0.04),
                Expanded(
                  child: Text(
                    col.collectionname,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: Fonts.nunito,
                      fontWeight: FontWeight.w600,
                      fontSize: Responsive.font(context, 16),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _greenBorder, width: 1.25),
                  ),
                  child: Icon(
                    LucideIcons.arrowRight400Dir,
                    color: Colors.green,
                    size: Responsive.icon(context, 16),
                  ),
                ),
                SizedBox(width: width * 0.035),
              ],
            ),
          ),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            double height = MediaQuery.of(context).size.height;
            double width = MediaQuery.of(context).size.width;
            final radius = BorderRadius.circular(Responsive.icon(context, 5));

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: EdgeInsets.all(width * 0.05),
                  height: height * 0.62,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.bookmarkPlus400Dir,
                            size: Responsive.icon(context, 20),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Create New ",
                            style: TextStyle(
                              fontFamily: Fonts.outfit,
                              fontSize: Responsive.font(context, 18),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "Collection",
                            style: TextStyle(
                              fontFamily: Fonts.outfit,
                              fontSize: Responsive.font(context, 18),
                              fontWeight: FontWeight.w700,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Organise your saved questions into a collection for future review.",
                        style: TextStyle(
                          fontFamily: Fonts.outfit,
                          fontSize: Responsive.font(context, 11),
                          color: _mutedText,
                        ),
                      ),
                      SizedBox(height: height * 0.025),
                      Text(
                        "COLLECTION NAME",
                        style: TextStyle(
                          fontFamily: Fonts.rubik,
                          fontWeight: FontWeight.w600,
                          fontSize: Responsive.font(context, 13),
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      TextField(
                        cursorColor: Colors.green,
                        textCapitalization: TextCapitalization.words,
                        style: TextStyle(
                          fontFamily: Fonts.outfit,
                          fontSize: Responsive.font(context, 14),
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "e.g. Tricky Mechanics",
                          hintStyle: TextStyle(
                            fontFamily: Fonts.outfit,
                            color: const Color.fromRGBO(118, 118, 118, 1),
                            fontSize: Responsive.font(context, 14),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: width * 0.035,
                            vertical: height * 0.017,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: radius,
                            borderSide: const BorderSide(
                              color: _borderGrey,
                              width: 1.25,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: radius,
                            borderSide: const BorderSide(
                              color: Colors.green,
                              width: 1.25,
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          localNewCollectionName = val;
                        },
                      ),
                      SizedBox(height: height * 0.025),
                      Text(
                        "SELECT ICON",
                        style: TextStyle(
                          fontFamily: Fonts.rubik,
                          fontWeight: FontWeight.w600,
                          fontSize: Responsive.font(context, 13),
                        ),
                      ),
                      SizedBox(height: height * 0.012),
                      Expanded(
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 6,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1,
                              ),
                          scrollDirection: Axis.vertical,
                          itemCount: collectionIcons.length,
                          itemBuilder: (context, index) {
                            final isSelected = localSelectedIconIndex == index;
                            return InkWell(
                              borderRadius: radius,
                              onTap: () {
                                setModalState(() {
                                  localSelectedIconIndex = index;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.green
                                      : Colors.white,
                                  borderRadius: radius,
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.green
                                        : const Color.fromRGBO(
                                            215,
                                            215,
                                            215,
                                            0.8,
                                          ),
                                  ),
                                ),
                                child: Icon(
                                  collectionIcons[index],
                                  size: Responsive.icon(context, 22),
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      SizedBox(
                        width: double.infinity,
                        height: height * 0.06,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Responsive.icon(context, 10),
                              ),
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
                              fontWeight: FontWeight.w700,
                              fontSize: Responsive.font(context, 16),
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

Widget _headerText(double height, double width, BuildContext context) {
  final style = TextStyle(
    fontFamily: Fonts.outfit,
    color: Colors.black,
    fontSize: Responsive.font(context, 22),
    fontWeight: FontWeight.w600,
  );
  return Row(
    children: [
      Text("Manage Your", style: style),
      Text(" Collections", style: style.copyWith(color: Colors.green)),
      Text(".", style: style.copyWith(color: Colors.green)),
    ],
  );
}
