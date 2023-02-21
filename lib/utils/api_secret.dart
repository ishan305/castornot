//Singleton class
class ApiSecret {
  static final ApiSecret _apiSecret = ApiSecret._internal();
  String? secret;

  factory ApiSecret() {
    return _apiSecret;
  }

  ApiSecret._internal();

  void setSecret(String secret){
    this.secret = secret;
  }
}