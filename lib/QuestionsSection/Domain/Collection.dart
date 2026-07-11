class Collection {
  String collectionId;
  String collectionname;
  int questions;
  int iconIndex;

  Collection({required this.collectionId,required this.collectionname, required this.questions, required this.iconIndex});

  factory Collection.fromJson(Map<String,dynamic> mp){
    String collectionId = mp['collection_id'];
    String collectionname = mp['collection_name'];
    int questions = mp['total_questions'];
    int iconIndex = mp['icon_index'];
    return Collection(collectionId: collectionId, collectionname: collectionname, questions: questions, iconIndex: iconIndex);
  }
  
  


}