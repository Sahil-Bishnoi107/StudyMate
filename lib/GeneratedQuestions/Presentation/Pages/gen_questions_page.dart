import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/DependancyInjections.dart/service_locator.dart';
import 'package:study_mate/GeneratedQuestions/Domain/Entities/gen_question.dart';
import 'package:study_mate/GeneratedQuestions/Presentation/Bloc/gen_questions_bloc.dart';
import 'package:study_mate/GeneratedQuestions/Presentation/Bloc/gen_questions_events.dart';
import 'package:study_mate/GeneratedQuestions/Presentation/Bloc/gen_questions_states.dart';
import 'package:study_mate/LoadingScreen/LoadingAnimations.dart';
import 'package:study_mate/Test/Presentation/Widgets/fixedTextWidget.dart';
import 'package:study_mate/Test/Presentation/Widgets/question_button.dart';
import 'package:study_mate/Test/Presentation/Widgets/question_option.dart';
import 'package:study_mate/fonts.dart';


class GenQuestionsPage extends StatelessWidget {
  const GenQuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GenQuestionsBloc>(
      create: (_) => sl<GenQuestionsBloc>()
        ..add(GenQuestionsLoadEvent(subject: 'physics')),
      child: const _GenQuestionsView(),
    );
  }
}


class _GenQuestionsView extends StatefulWidget {
  const _GenQuestionsView();

  @override
  State<_GenQuestionsView> createState() => _GenQuestionsViewState();
}

class _GenQuestionsViewState extends State<_GenQuestionsView> {
  String _selectedSubject = 'physics';

  static const List<Map<String, String>> _subjects = [
    {'value': 'physics', 'label': 'Physics'},
    {'value': 'chemistry', 'label': 'Chemistry'},
    {'value': 'mathematics', 'label': 'Mathematics'},
  ];

  void _changeSubject(String? newValue) {
    if (newValue == null || newValue == _selectedSubject) return;
    setState(() => _selectedSubject = newValue);
    context
        .read<GenQuestionsBloc>()
        .add(GenQuestionsChangeSubjectEvent(subject: newValue));
  }

  Future<void> _showConfirmRemoveDialog(
    BuildContext ctx,
    List<String> selectedIds,
  ) async {
    final confirmed = await showDialog<bool>(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        title: const Text(
          'Remove Selected Questions?',
          style: TextStyle(fontFamily: Fonts.nunito, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'This will permanently remove ${selectedIds.length} '
          'question${selectedIds.length == 1 ? '' : 's'} from the system. '
          'This action cannot be undone.',
          style: const TextStyle(fontFamily: Fonts.outfit),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.grey, fontFamily: Fonts.nunito)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            child: const Text('Remove',
                style: TextStyle(fontFamily: Fonts.nunito, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true && ctx.mounted) {
      ctx.read<GenQuestionsBloc>().add(GenQuestionsRemoveEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<GenQuestionsBloc, GenQuestionsStates>(
        listener: (ctx, state) {
          if (state is GenQuestionsError && state.previousState != null) {
            // Next-page error with existing data — show snackbar and restore
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(state.message,
                    style: const TextStyle(fontFamily: Fonts.outfit)),
                backgroundColor: Colors.redAccent,
                action: SnackBarAction(
                  label: 'OK',
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
            );
            ctx.read<GenQuestionsBloc>()
                .add(GenQuestionsRestoreEvent(state: state.previousState!));
          }

          if (state is GenQuestionsRemoveSuccess) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(
                content: Text('Questions removed successfully.',
                    style: TextStyle(fontFamily: Fonts.outfit)),
                backgroundColor: Colors.green,
              ),
            );
            ctx.read<GenQuestionsBloc>()
                .add(GenQuestionsRestoreEvent(state: state.updatedState));
          }

          if (state is GenQuestionsRemoveError) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(state.message,
                    style: const TextStyle(fontFamily: Fonts.outfit)),
                backgroundColor: Colors.redAccent,
              ),
            );
            ctx.read<GenQuestionsBloc>()
                .add(GenQuestionsRestoreEvent(state: state.previousState));
          }
        },
        builder: (ctx, state) {
          
          if (state is GenQuestionsLoading) {
            return Column(
              children: [
                _appBar(height, width, context),
                Expanded(
                  child: Center(child: LoadingLogo()),
                ),
              ],
            );
          }

         
          if (state is GenQuestionsError && state.previousState == null) {
            return Column(
              children: [
                _appBar(height, width, context),
                _subjectFilter(height, width, ctx),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.redAccent, size: 48),
                          SizedBox(height: height * 0.02),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: Fonts.outfit,
                              fontSize: Responsive.font(ctx, 15),
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: height * 0.03),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              ctx.read<GenQuestionsBloc>().add(
                                    GenQuestionsLoadEvent(
                                        subject: _selectedSubject),
                                  );
                            },
                            child: Text('Retry',
                                style: TextStyle(
                                    fontFamily: Fonts.nunito,
                                    fontSize: Responsive.font(ctx, 14))),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          // ----------------------------------------------------------------
          // Remove in progress — show full-screen loading
          // ----------------------------------------------------------------
          if (state is GenQuestionsRemoveLoading) {
            return Column(
              children: [
                _appBar(height, width, context),
                Expanded(child: Center(child: LoadingLogo())),
              ],
            );
          }

          // ----------------------------------------------------------------
          // Loaded (main UI)
          // ----------------------------------------------------------------
          GenQuestionsLoaded? loaded;
          if (state is GenQuestionsLoaded) loaded = state;
          // RemoveSuccess/RemoveError also restore via listener; during
          // the brief frame before re-emit, show loading.
          if (loaded == null) {
            return Column(
              children: [
                _appBar(height, width, context),
                Expanded(child: Center(child: LoadingLogo())),
              ],
            );
          }

          // Capture in a final so closures have guaranteed non-null access
          final GenQuestionsLoaded loadedState = loaded;
          final question = loadedState.questions[loadedState.currentIndex];
          final isSelected = loadedState.selectedQuestionIds.contains(question.id);
          final bool isFirst = loadedState.currentIndex == 0;
          final bool isLast = loadedState.currentIndex == loadedState.questions.length - 1;

          return Column(
            children: [
              _appBar(height, width, context),
              Container(height: 1, color: const Color.fromRGBO(200, 200, 200, 0.6)),
              SizedBox(height: height * 0.005),

              // Subject filter
              _subjectFilter(height, width, ctx),
              SizedBox(height: height * 0.005),

              // Question counter
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Row(
                  children: [
                    Text(
                      'Question ${loadedState.currentIndex + 1} / ${loadedState.questions.length} loaded',
                      style: TextStyle(
                        fontFamily: Fonts.inter,
                        fontWeight: FontWeight.w600,
                        fontSize: Responsive.font(ctx, 14),
                        color: Colors.black54,
                      ),
                    ),
                    const Spacer(),
                    if (loadedState.isFetchingNextPage)
                      Row(
                        children: [
                          SizedBox(
                            width: Responsive.icon(ctx, 14),
                            height: Responsive.icon(ctx, 14),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(width: width * 0.015),
                          Text(
                            'Loading more…',
                            style: TextStyle(
                              fontFamily: Fonts.outfit,
                              fontSize: Responsive.font(ctx, 12),
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.005),
              Container(height: 1, color: const Color.fromRGBO(220, 220, 220, 0.7)),

              // Question + options (scrollable)
              Expanded(
                child: SingleChildScrollView(
                  child: _questionSection(
                    height,
                    width,
                    ctx,
                    question,
                    loadedState.currentIndex,
                    loadedState.questions.length,
                  ),
                ),
              ),

              Container(height: 1, color: const Color.fromRGBO(220, 220, 220, 0.7)),
              SizedBox(height: height * 0.01),

              // Select Question button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: GestureDetector(
                  onTap: () {
                    ctx.read<GenQuestionsBloc>().add(
                          GenQuestionsToggleSelectEvent(questionId: question.id),
                        );
                  },
                  child: Container(
                    height: height * 0.055,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.white,
                      border: Border.all(
                        color: isSelected ? Colors.green : Colors.black,
                        width: 1.2,
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: isSelected ? Colors.green : Colors.black,
                            size: Responsive.icon(ctx, 18),
                          ),
                          SizedBox(width: width * 0.02),
                          Text(
                            isSelected
                                ? 'Question Selected ✓'
                                : 'Select Question',
                            style: TextStyle(
                              fontFamily: Fonts.nunito,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.font(ctx, 14),
                              color: isSelected ? Colors.green : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.01),

              // Previous / Next navigation
              Row(
                children: [
                  SizedBox(width: width * 0.05),
                  GestureDetector(
                    onTap: isFirst
                        ? null
                        : () => ctx
                            .read<GenQuestionsBloc>()
                            .add(GenQuestionsNavigatePrevEvent()),
                    child: Opacity(
                      opacity: isFirst ? 0.35 : 1.0,
                      child: queButton(height, width, false, ctx),
                    ),
                  ),
                  SizedBox(width: width * 0.1),
                  GestureDetector(
                    onTap: (isLast && !loaded.hasMore)
                        ? null
                        : () => ctx
                            .read<GenQuestionsBloc>()
                            .add(GenQuestionsNavigateNextEvent()),
                    child: Opacity(
                      opacity: (isLast && !loaded.hasMore) ? 0.35 : 1.0,
                      child: queButton(height, width, true, ctx),
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.015),
              Container(height: 1, color: const Color.fromRGBO(200, 200, 200, 0.6)),
              SizedBox(height: height * 0.01),

              // Mark Questions button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: GestureDetector(
                  onTap: () {
                    if (loadedState.selectedQuestionIds.isEmpty) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'No questions selected. Tap "Select Question" on any question first.',
                            style: TextStyle(fontFamily: Fonts.outfit),
                          ),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }
                    _showConfirmRemoveDialog(ctx, loadedState.selectedQuestionIds);
                  },
                  child: Container(
                    height: height * 0.055,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: loadedState.selectedQuestionIds.isEmpty
                          ? Colors.white
                          : Colors.redAccent.withValues(alpha: 0.08),
                      border: Border.all(
                        color: loadedState.selectedQuestionIds.isEmpty
                            ? const Color.fromRGBO(200, 200, 200, 1)
                            : Colors.redAccent,
                        width: 1.2,
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: loaded.selectedQuestionIds.isEmpty
                                ? Colors.black38
                                : Colors.redAccent,
                            size: Responsive.icon(ctx, 18),
                          ),
                          SizedBox(width: width * 0.02),
                          Text(
                            loaded.selectedQuestionIds.isEmpty
                                ? 'Mark Questions (0 selected)'
                                : 'Mark Questions (${loaded.selectedQuestionIds.length} selected)',
                            style: TextStyle(
                              fontFamily: Fonts.nunito,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.font(ctx, 14),
                              color: loaded.selectedQuestionIds.isEmpty
                                  ? Colors.black38
                                  : Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
            ],
          );
        },
      ),
    ));
  }


  Widget _appBar(double height, double width, BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          minHeight: height * 0.05, maxHeight: height * 0.1),
      width: width,
      padding: EdgeInsets.only(
          left: width * 0.04,
          right: width * 0.04,
          bottom: height*0.01,
          top: height * 0.005),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(LucideIcons.chevronLeft,
                size: Responsive.icon(context, 28)),
          ),
          SizedBox(width: width * 0.05),
          Text(
            'AI Questions',
            style: TextStyle(
              fontFamily: Fonts.nunito,
              fontWeight: FontWeight.bold,
              fontSize: Responsive.font(context, 20),
            ),
          ),
          const Spacer(),
          
        ],
      ),
    );
  }


  Widget _subjectFilter(double height, double width, BuildContext ctx) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.006),
      child: Row(
        children: [
          Text(
            'Subject:',
            style: TextStyle(
              fontFamily: Fonts.nunito,
              fontWeight: FontWeight.w600,
              fontSize: Responsive.font(ctx, 14),
            ),
          ),
          SizedBox(width: width * 0.03),
          Container(
            height: height * 0.042,
            padding: EdgeInsets.symmetric(horizontal: width * 0.03),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.2),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedSubject,
                onChanged: _changeSubject,
                style: TextStyle(
                  fontFamily: Fonts.nunito,
                  fontSize: Responsive.font(ctx, 14),
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                items: _subjects
                    .map((s) => DropdownMenuItem(
                          value: s['value'],
                          child: Text(s['label']!),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


Widget _questionSection(
  double height,
  double width,
  BuildContext context,
  GenQuestion question,
  int currIndex,
  int totalLoaded,
) {
  final String difficulty = question.difficulty.isNotEmpty
      ? question.difficulty[0].toUpperCase() + question.difficulty.substring(1)
      : '';

  return Container(
    width: width,
    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height * 0.015),

        
        Row(
          children: [
            Text(
              'Question ${currIndex + 1} of $totalLoaded',
              style: TextStyle(
                fontFamily: Fonts.inter,
                fontWeight: FontWeight.w700,
                fontSize: Responsive.font(context, 16),
              ),
            ),
            const Spacer(),
            if (difficulty.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.025, vertical: 4),
                decoration: BoxDecoration(
                  color: _difficultyColor(question.difficulty).withValues(alpha: 0.1),
                  border: Border.all(
                      color: _difficultyColor(question.difficulty), width: 1),
                ),
                child: Text(
                  difficulty,
                  style: TextStyle(
                    fontFamily: Fonts.nunito,
                    fontSize: Responsive.font(context, 12),
                    fontWeight: FontWeight.bold,
                    color: _difficultyColor(question.difficulty),
                  ),
                ),
              ),
          ],
        ),

        SizedBox(height: height * 0.015),

        // Question description with LaTeX
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: height * 0.03,
            maxHeight: height * 0.55,
            minWidth: width * 0.9,
            maxWidth: width * 0.9,
          ),
          child: MixedMathText(
            text: question.description,
            textStyle: TextStyle(
              fontFamily: Fonts.rubik,
              fontWeight: FontWeight.w700,
              color: const Color.fromRGBO(60, 60, 60, 1),
              fontSize: Responsive.font(context, 16),
            ),
          ),
        ),

        SizedBox(height: height * 0.03),

        // Options — static/non-clickable (isSelected always false)
        if (question.options.isNotEmpty)
          QuestionOption(
            question.options[0], height, width, false, 'A', context),
        if (question.options.length > 1)
          QuestionOption(
            question.options[1], height, width, false, 'B', context),
        if (question.options.length > 2)
          QuestionOption(
            question.options[2], height, width, false, 'C', context),
        if (question.options.length > 3)
          QuestionOption(
            question.options[3], height, width, false, 'D', context),

        SizedBox(height: height * 0.02),
      ],
    ),
  );
}

Color _difficultyColor(String difficulty) {
  switch (difficulty.toLowerCase()) {
    case 'easy':
      return Colors.green;
    case 'medium':
      return Colors.orange;
    case 'hard':
      return Colors.redAccent;
    default:
      return Colors.grey;
  }
}
