import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String selectedCurrency = 'USD';
  DropdownButton<String> AndroidPicker(){
    List<DropdownMenuItem<String>> dropdownItems = [];
    for(String currency in currenciesList){
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
        value: selectedCurrency,
        items: dropdownItems,
        onChanged: (String? newvalue){
          setState(() {
            selectedCurrency = newvalue!;
            getData();
          });
        });
  }
  CupertinoPicker iosPicker(){
    List<Text> pickerItems = [];
    for(String currency in currenciesList){
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
        itemExtent: 32,
        onSelectedItemChanged: (selectedIndex){
          setState(() {
            selectedCurrency = currenciesList[selectedIndex];
            getData();
          });
        },
        children: pickerItems);
  }
  Map<String, String> coinValue = {};
  bool isWaiting = false;
  String bitcoinValue = '?';
  void getData()async{
    isWaiting = true;
    try{
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValue = data;
      });
    }
    catch(e){
      print(e);
    }
  }
  @override
  void initState(){
    super.initState();
    getData();
  }
  // Widget? getPicker(){
  //   if(Platform.isIOS){
  //     return iosPicker();
  //   }
  //   else if(Platform.isAndroid){
  //     return AndroidPicker();
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Tickers',
        style: TextStyle(
          fontSize: 25,
          color: Colors.black
        ),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptoCard(
            cryptoCurrency: 'BTC',
            value: isWaiting ? '?' : coinValue['BTC'],
            selectedCurrency: selectedCurrency,
            myimage: 'images/bitcoin.png',
          ),
          CryptoCard(
            cryptoCurrency: 'ETH',
            value: isWaiting ? '?' : coinValue['ETH'],
            selectedCurrency: selectedCurrency,
            myimage: 'images/eth.png',
          ),
          CryptoCard(
            cryptoCurrency: 'LTC',
            value: isWaiting ? '?' : coinValue['LTC'],
            selectedCurrency: selectedCurrency,
            myimage: 'images/ltc.png',

          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Color(0xFF0A304B),
            child: Platform.isIOS ? iosPicker() : AndroidPicker()
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    this.value,
    this.selectedCurrency,
    this.cryptoCurrency,
    this.myimage
});
  final String? value;
  final String? selectedCurrency;
  final String? cryptoCurrency;
  final String? myimage;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      child: Padding(
        padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
        child: Card(
          color: Color(0xFF0A304B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.currency_exchange_outlined,
                      size: 40,
                      color: Color(0xFFFFB343),
                    ),
                    Text(
                      '1 $cryptoCurrency = $value $selectedCurrency',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 100,
                  height: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(20)
                      ),
                      image: DecorationImage(
                        image: AssetImage(myimage!),
                      )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}



