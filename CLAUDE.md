# StudyMate – how code is written here

Write code the way the existing hand-written code is written. Do not "improve" the style, do not
introduce new patterns/packages, and do not run `dart format` on files (it would reflow everything).
When unsure, open the nearest sibling file in the same feature and copy its shape.

Best reference files: `lib/Profile/` (whole feature), `lib/Home/Presentation/Pages/Homepage.dart`,
`lib/Contest/Data/ContestRepo.dart`, `lib/QuestionsSection/Presentation/Bloc/`.

## Folder structure

Feature-first, PascalCase folders, same three layers in every feature:

```
lib/<Feature>/
  Data/            <Feature>Repo.dart            (API calls)
  Domain/          <Model>.dart                  (plain model classes, one per file)
  Presentation/
    Bloc/          <Name>Bloc.dart, <Name>Events.dart, <Name>States.dart
    Pages/         <Name>Page.dart
    Widgets/       <Name>Section.dart / <Name>Card.dart ...
```

- If a feature has more than one bloc, each bloc gets its own subfolder: `Bloc/ContestPage/`, `Bloc/MyContest/`.
- New files use PascalCase names (`ContestPage.dart`, `ProfileRepo.dart`). Older snake_case files stay as they are.
- App-wide things live at the top of `lib/`: `fonts.dart` (`Fonts` + `Responsive`), `secure_storage.dart`,
  `ngrok.dart`, `role.dart`, `Networking/` (dio client + interceptors),
  `DependancyInjections.dart/service_locator.dart`, `LoadingScreen/LoadingAnimations.dart`.
- `ApiResponse` is shared from `Authentication/Domain/Entities/ApiResponse.dart`.
- Imports are always absolute `package:study_mate/...`, never relative.

## Adding a feature (wiring)

1. Repo + Bloc registered in `service_locator.dart` with `sl.registerLazySingleton<...>`.
2. Bloc added to the `MultiBlocProvider` list in `main.dart` as `BlocProvider(create: (context) => sl<XBloc>())`.
3. A bloc that only lives for one screen is provided at the push site instead:
   `Navigator.push(context, MaterialPageRoute(builder: (_) => BlocProvider(create: (context) => XBloc(sl<XRepo>()), child: XPage())))`.
4. Page reached with `Navigator.push(context, MaterialPageRoute(builder: (_) => XPage()))`. No named routes, no router package.

## Data layer (repos)

```dart
class ProfileRepo{
  final Dio dio;
  ProfileRepo(this.dio);

  Future<ApiResponse> getMyQuestions()async{
    try{
      var res = await dio.get("/Questions/my-practice-questions");
      if(res.statusCode != 200){return ApiResponse(statusCode: res.statusCode ?? 500);}
      List<PracticeUserQuestion> questions = [];
      for(var v in res.data){
        questions.add(PracticeUserQuestion.fromJson(v));
      }
      return ApiResponse(statusCode: 200,data: questions);
    }
    catch(e){
      print("Exception occured while getting questions : $e");
      return ApiResponse(statusCode: 500);
    }
  }
}
```

- Every method returns `Future<ApiResponse>`, wraps everything in try/catch, never throws to the bloc.
- Check `res.statusCode != 200` first and return early. Lists are built with a plain `for` loop + `.add(X.fromJson(..))`,
  guarded by `json.containsKey("key")` when the list is nested under a key.
- `print(...)` for logging. Method names camelCase (`getContestList`).

## Domain models

Plain classes. No freezed / equatable / json_serializable / copyWith.

- Typed fields, constructor with `required this.x` named params.
- `factory X.fromJson(Map<String, dynamic> json)` reading snake_case keys; `toJson()` only when the model is sent back.
- Nested lists are parsed with a `for` loop inside `fromJson`.

## Bloc

- flutter_bloc `Bloc` (not Cubit). Three files per bloc: Bloc / Events / States.
- Events and states are plain classes extending an empty base class – no sealed, no Equatable:
  ```dart
  class Profilestates {}
  class InitialProfileState extends Profilestates{}
  class LoadingProfileState extends Profilestates{}
  class LoadedProfileState extends Profilestates{
    List<MyContest> contest;
    Student student;
    LoadedProfileState({required this.student,required this.contest});
  }
  class ErrorProfileState extends Profilestates{}
  ```
- State names: `Initial…State`, `Loading…State`, `Loaded…State` / `Success…State`, `Error…State`. Events end in `Event`.
- Bloc takes the repo as a positional constructor arg: `XBloc(this.xRepo) : super(InitialXState())`.
- Small blocs: handlers inline `on<E>((event, emit) async { ... },);`.
  Bigger blocs: `on<E>(_onE);` with private `_onE(E event, Emitter<S> emit)` methods below.
- Handler shape: `emit(Loading)` → call repo → `if(res.statusCode != 200){ emit(Error); return; }` → read `res.data` into typed locals → `emit(Loaded(...))`.
- Updating state = `if (state is XState) { final st = state as XState; emit(XState(... every field ...)); }`.

## Pages

```dart
class ProfilePage extends StatefulWidget { ... }

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<Profilebloc>(context).add(LoadProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<Profilebloc, Profilestates>(
        builder: (context, state) {
          if (state is LoadingProfileState) {
            return Center(child: LoadingLogo());
          } else if (state is LoadedProfileState) {
            return SafeArea(
              child: Column(
                children: [
                  SizedBox(height: height*0.008,),
                  _appBar(height, width, context),
                  Container(color: const Color.fromRGBO(220, 220, 220, 0.8),height: 1,width: width,),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _headerSection(height, width, state.student),
                          SizedBox(height: height*0.02,),
                          RatingGraph(contests: state.contest),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          return Center(child: Text("Failed to load profile", style: TextStyle(color: Colors.red, fontFamily: Fonts.nunito)));
        },
      ),
    );
  }
}

Widget _appBar(double height,double width,BuildContext context){
  return Container(
    height: height*0.05,
    margin: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Row(children: [ ... ]),
  );
}
```

- Load event fired in `initState` with `BlocProvider.of<XBloc>(context).add(...)` (not `context.read`).
- `height` / `width` are read once at the top of `build` and passed down as arguments.
- State handled with `if (state is ...)` chains; loading = `LoadingLogo()`; fallback = red "Failed to load ..." text.
- No `AppBar` widget – a custom `_appBar(...)` row, then a 1px grey `Container` divider, then `Expanded(SingleChildScrollView(Column))`.
- `BlocConsumer` + `ScaffoldMessenger.of(context).showSnackBar(...)` for one-off errors / navigation on state.

## How widgets are split

- The page's `build` is a short list of named pieces with `SizedBox` gaps between them, so the layout reads top to bottom.
- Each piece is a **top-level private function below the page class in the same file**:
  `Widget _name(double height, double width, <data>, BuildContext context)`. Typical names: `_appBar`, `_header`,
  `_headerSection`, `_statSection`, `_card`, `_filters`, `_emptyState`.
- Repeated items get one parameterised function called several times (`_card(height, width, icon, text, header1, header2, ...)`).
- A piece moves into `Presentation/Widgets/` as a `StatelessWidget` class (one per file) when it is big, has its own logic,
  or is reused by another page. It takes data through `required` named params.
- Shared functions without underscore when used across files (`mainDrawer(height, width, context)`).

## UI styling

- Sizes are screen fractions: `height*0.05`, `width*0.9`. Page side padding is `width*0.05`.
  Gaps are `SizedBox(height: height*0.01,)`; small fixed gaps `const SizedBox(height: 5,)` are fine too.
- Font and icon sizes always go through `Responsive.font(context, 14)` / `Responsive.icon(context, 20)`.
- `TextStyle` is written inline on every `Text`. No `Theme`, no shared text-style constants, no colour constants file.
- Colours are written inline (`Colors.green`, `const Color.fromRGBO(220, 220, 220, 0.8)`); copy the fonts and colours the neighbouring widgets use.
- Icons: `LucideIcons.<name>400Dir` (also 200/300 weights); `Bootstrap.*` from icons_plus; Material `Icons.*_sharp`.
- Tappables are `InkWell` / `GestureDetector` around a `Container` – not `ElevatedButton` / `TextButton`.

## Code formatting / small habits

- Compact, hand-formatted. A simple widget stays on one line even if long:
  `Text("Profile",style: TextStyle(color: Colors.black,fontFamily: Fonts.rubik,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 20)),)`
- `height: height*0.05,width: width,` on one line; no spaces around `*`.
- Double quotes for strings.
- Explicit types for locals (`double width`, `List<Contest> contests = []`, `bool isSelected`); `var res` / `final res` for API responses.
- Short local names: `res`, `st`, `que`, `m`, `ts`.
- Very few comments – only a short one-liner where something is not obvious. No doc comments, no section banners.
- Reuse existing identifiers exactly as spelled (e.g. `ChnageFilter`, `ratingChnage`, `Profilebloc`); don't rename them in passing.
- Stick to packages already in `pubspec.yaml`; ask before adding one.
