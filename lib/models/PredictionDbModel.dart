class Prediction {
  
  final String name;
  final double confidence;
  bool showCausesAndRecommendations;

  Prediction({
    required this.name,
    required this.confidence,
    this.showCausesAndRecommendations = false,
  });


}
