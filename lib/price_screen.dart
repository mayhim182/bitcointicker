import 'dart:convert';

import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

const apiKey = '72EC2785-B0B3-43E1-8EA1-D6C4E7C17DDF';

class PriceScreen extends StatefulWidget {
  // const PriceScreen({Key? key}) : super(key: key);

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String currentPrice = '0';

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> getCurrencyData(String currency) async {
    String coinApiUrl =
        'https://rest.coinapi.io/v1/exchangerate/BTC/$currency?apiKey=$apiKey';
    var url = Uri.parse(coinApiUrl);
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      double lastPrice = decodedData['rate'];
      setState(() {
        currentPrice = lastPrice.toString();
        // print(currentPrice);
      });
      return lastPrice;
    } else {
      print(response.statusCode);
      throw 'problem with get request';
    }
  }
  //
  // Future<dynamic> getCurrencyDataForCurrency(String selectedCurrency) async{
  //   String coinApiUrl='https://rest.coinapi.io/v1/exchangerate/BTC/$selectedCurrency?apiKey=$apiKey';
  //   var url=Uri.parse(coinApiUrl);
  //   http.Response response=await http.get(url);
  //   if(response.statusCode==200) {
  //     var decodedData = jsonDecode(response.body);
  //     double lastPrice = decodedData['rate'];
  //     setState(() {
  //       currentPrice=lastPrice.toString();
  //       print(currentPrice);
  //     });
  //     return lastPrice;
  //   }
  //   else{
  //     print(response.statusCode);
  //     return 0;
  //   }
  // }

  String selectedCurrency = 'INR';

  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];
      selectedCurrency=currency;
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency, //the first item in the list
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value.toString();
          getCurrencyData(selectedCurrency);
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Text> pickerItem = [];
    List<String> pickedItem=[];
    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];
      pickerItem.add(Text(currency));
      pickedItem.add(currency);
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
        setState(() {
          selectedCurrency=pickedItem[selectedIndex].toString();
          getCurrencyData(selectedCurrency);
        });
      },
      children: pickerItem,
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return androidDropDown();
    } else if (Platform.isAndroid) {
      return iosPicker();
    }
    return androidDropDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Column(
                  children:[
                   Text(
                    '1 BTC=$currentPrice $selectedCurrency',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                    SizedBox(
                      width: double.infinity,
                      height: 10.0,
                    ),
                    Text(
                      '1 ETH=$currentPrice $selectedCurrency',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(
                      width: double.infinity,
                      height: 10.0,
                    ),

                    Text(
                      '1 LTC=$currentPrice $selectedCurrency',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                ],
                )
                ),
              ),
            ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}

// DropdownButton<String>(
// value:selectedCurrency,//the first item in the list
// items:getDropDownItems(),
// onChanged: (value){
// setState(() {
// selectedCurrency=value.toString();
// });
// },),
