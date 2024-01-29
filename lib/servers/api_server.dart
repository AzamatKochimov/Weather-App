class ApiServer {
  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const String baseUrl = "https://api.api-ninjas.com";
  static const String apiGetAllData = "/v1/weather";
  static const Map<String, String> headers = {
    "X-Api-Key": "pQXlktJXi7ibR4cyIchtfQ==uRQNyZQXwSCrnDmA",
  };
  static Map<String, dynamic> paramGetWeather(String city) {
    return {
      "city": city,
    };
  }
}
