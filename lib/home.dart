import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas/button_row.dart';
import 'package:gas/number_field.dart';
import 'package:gas/simple_text.dart';
import 'package:gas/touchable_opacity.dart';
import 'package:gas/typography.dart';
import 'package:http/http.dart' as http;

enum BoxFocused { top, bottom }

enum CurrencyFirst { usd, cad }

enum FromCurrency { usd, cad }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void converter() async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'apiKey': 'FLet9v1AEx7tnI4FfaVNTchdt3pL9HH6', // FLet9v1AEx7tnI4FfaVNTchdt3pL9HH6
    };
    try {
      setState(() {
        loading = true;
        somethingWrong = false;
      });
      await http
          .get(
        headers: headers,
        Uri.parse(
          "https://api.apilayer.com/exchangerates_data/convert?to=USD&from=CAD&amount=1",
        ),
      )
          .then(
        (response) {
          setState(() {
            loading = false;
            exchangeRate = json.decode(response.body)["result"];
            readjust();
          });
        },
      ).timeout(const Duration(seconds: 3));
    } catch (e) {
      print("ERROR CAUGHT: $e");
      setState(() {
        loading = false;
        somethingWrong = true;
      });
    }
  }

  bool loading = true;
  bool somethingWrong = false;

  @override
  void initState() {
    converter();
    super.initState();
  }

  CurrencyFirst currencyFirst = CurrencyFirst.cad;
  double exchangeRate = 0.0;
  double topPrice = 2.00;
  double bottomPrice = 0.00;

  String doubleToPrice(double price) => "\$${double.parse((price).toStringAsFixed(2)).toString()}";

  BoxFocused boxFocused = BoxFocused.top;

  double convert(double value, FromCurrency fromCurrency) {
    if (fromCurrency == FromCurrency.usd) {
      return (value / exchangeRate) * 0.264172;
    } else {
      return (value * exchangeRate) / 0.264172;
    }
  }

  String getCurrency(double value) {
    if (currencyFirst == CurrencyFirst.cad) {
      return '${doubleToPrice(exchangeRate)} USD = \$1.00 CAD';
    } else {
      return '\$1.00 USD = \$${(1 / double.parse((exchangeRate).toStringAsFixed(2)).toDouble()).toStringAsFixed(2)} CAD';
    }
  }

  void changeCurrencyOrder() {
    if (currencyFirst == CurrencyFirst.cad) {
      setState(() {
        currencyFirst = CurrencyFirst.usd;
      });
    } else {
      setState(() {
        currencyFirst = CurrencyFirst.cad;
      });
    }
  }

  void readjust() {
    if (boxFocused == BoxFocused.top) {
      bottomPrice = convert(topPrice, FromCurrency.cad);
    } else {
      topPrice = convert(bottomPrice, FromCurrency.usd);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: loading
              ? const CupertinoActivityIndicator(color: Colors.white)
              : somethingWrong
                  ? Text(
                      "Something went wrong...",
                      style: kBody.copyWith(color: Colors.white),
                    )
                  : TouchableOpacity(
                      onTap: () => changeCurrencyOrder(),
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          getCurrency(exchangeRate),
                          style: kBody.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
        ),
      ),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: loading
              ? const CupertinoActivityIndicator()
              : somethingWrong
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SimpleTextButton(onTap: () => converter(), text: "Try again"),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .75,
                          child: Text(
                            "Can't connect, or API request limit exausted (250 calls / month).",
                            style: kBody.copyWith(
                              color: Colors.black.withOpacity(0.2),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              setState(() {
                                boxFocused = BoxFocused.top;
                              });
                            },
                            onLongPress: () {
                              HapticFeedback.lightImpact();
                              setState(() {
                                boxFocused = BoxFocused.top;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.only(top: 20),
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: NumberField(
                                  postFix: "CAD / litre",
                                  value: doubleToPrice(topPrice),
                                  boxFocused: boxFocused,
                                  whichBoxThisIs: BoxFocused.top,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              setState(() {
                                boxFocused = BoxFocused.bottom;
                              });
                            },
                            onLongPress: () {
                              HapticFeedback.lightImpact();
                              setState(() {
                                boxFocused = BoxFocused.bottom;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 20),
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: NumberField(
                                  postFix: "USD / gal",
                                  value: doubleToPrice(bottomPrice),
                                  boxFocused: boxFocused,
                                  whichBoxThisIs: BoxFocused.bottom,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.blue,
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).padding.bottom * 2, left: 15, right: 15, top: 15),
                            child: Column(
                              children: [
                                ButtonRow(
                                  l1: () {
                                    setState(() {
                                      readjust();
                                      boxFocused == BoxFocused.top ? topPrice -= .01 : bottomPrice -= .01;
                                    });
                                  },
                                  l2: () => setState(() {
                                    readjust();
                                    boxFocused == BoxFocused.top ? topPrice -= .1 : bottomPrice -= .1;
                                  }),
                                  r1: () => setState(() {
                                    readjust();
                                    boxFocused == BoxFocused.top ? topPrice += .01 : bottomPrice += .01;
                                  }),
                                  r2: () => setState(() {
                                    readjust();
                                    boxFocused == BoxFocused.top ? topPrice += .1 : bottomPrice += .1;
                                  }),
                                ),
                                SizedBox(height: MediaQuery.of(context).padding.bottom * 2),
                                SimpleTextButton(
                                  infiniteWidth: true,
                                  onTap: () => converter(),
                                  text: "Reload/Sync Rate Data",
                                ),
                                // TODO: change laoding state here
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
