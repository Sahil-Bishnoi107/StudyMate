class MyQuestionsEvents {}

class LoadMyCollectionsEvent extends MyQuestionsEvents {}

class CreateNewCollectionEvent extends MyQuestionsEvents {
  final String collectionName;
  final int iconIndex;

  CreateNewCollectionEvent({
    required this.collectionName,
    required this.iconIndex,
  });
}

class LoadCollectionQuestionsEvent extends MyQuestionsEvents {
  final String collectionId;
  LoadCollectionQuestionsEvent(this.collectionId);
}

class ClearCollectionQuestionsEvent extends MyQuestionsEvents {}
