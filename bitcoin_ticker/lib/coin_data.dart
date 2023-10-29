import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];
const bitcoinUrl = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '6FC96053-B5DF-4F96-96D3-F5563B4647FC';
class CoinData{
  Future getCoinData(String selectedCurrency)async{
    Map<String, String> cryptoPrices = {};
    for(String crypto in cryptoList){
      String url = '$bitcoinUrl/$crypto/$selectedCurrency?apikey=$apiKey';
      Uri uri = Uri.parse(url);
      http.Response response = await http.get(uri);
      if(response.statusCode == 200){
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['rate'];
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      }
      else{
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;

  }
}