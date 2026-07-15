class Rating {
  int rating;
  int contestsGiven;

  Rating({required this.rating, required this.contestsGiven});

  factory Rating.fromJson(Map<String,dynamic> mp){
    int r = mp['user_rating'] ?? 1000;
    int cg = mp['total_contests'] ?? -1;
    return Rating(rating: r, contestsGiven: cg);
  }
}