//Singleton class
class ApiKey {
  static final ApiKey _apiKey = ApiKey._internal();
  String? key;

  factory ApiKey() {
    return _apiKey;
  }

  ApiKey._internal();

  void setKey(String key){
    this.key = key;
  }
}