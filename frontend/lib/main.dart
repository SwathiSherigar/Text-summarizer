import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'text_summarization',
    home: text_summarization(
      num: '',
    ),
  ));
}

class text_summarization extends StatefulWidget {
  final String num;

  const text_summarization({super.key, required this.num});
  @override
  State<text_summarization> createState() => _text_summarizationState();
}

class _text_summarizationState extends State<text_summarization> {
  int currentState = 0;
  String apiResponseText = '';
  String errorMessage = '';
  int count = 0;
  int value2 = 0;
  int value3 = 0;

  final TextEditingController myTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(61, 3, 1, 1),
      appBar: AppBar(
        leadingWidth: currentState == 1 ? kToolbarHeight : 0,
        leading: currentState == 1
            ?
            // Add a back button to the app bar
            IconButton(
                icon: Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  // Navigate back to the previous page
                  setState(() {
                    currentState = 0;
                  });
                },
                color: Color.fromARGB(255, 236, 227, 227))
            : SizedBox.shrink(),
        backgroundColor: Colors.indigoAccent.shade700,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Text Summarization',
              style: GoogleFonts.playfairDisplay(
                fontSize: 28, // Adjust the font size as needed
                fontWeight: FontWeight.bold, // Make it bold
                color: Colors.white, // Change the text color
              ),
            ),
            Center(
              child: Text(
                'Relive the best summary for text',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          currentState == 0
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 16.0),
                  child: Container(
                    height: 250.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: TextField(
                      controller: myTextController,
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top,
                      textAlign: TextAlign.start,
                      autofocus: true,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 247, 247, 247),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Enter text to summarize',
                        labelStyle: TextStyle(
                          color: const Color.fromARGB(255, 239, 212, 210),
                        ),
                        contentPadding: EdgeInsets.all(16.0),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Colors.indigoAccent.shade700),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Colors.indigoAccent.shade700),
                        ),
                        filled: true, // Set to true to enable filling
                        fillColor: const Color.fromARGB(255, 31, 30, 30),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
          SizedBox(height: 16.0),
          currentState == 0
              ? Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // print(myTextController.text);
                        myTextController.text == ''
                            ? setState(() {
                                currentState = 0;
                                // Toggle the state
                              })
                            : setState(() {
                                currentState = 1; // Toggle the state
                              });
                        fetchFromApi(myTextController.text);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xFF304ffe),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              : currentState == 1
                  ? Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Add a text above the existing text box when currentState is 1
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "Summarized Text",
                                  style: GoogleFonts.openSans(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(
                                        255, 240, 230, 230),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Card_num(
                                      num: 'Input word count',
                                      valuue1: count,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Card_num(
                                      num: 'Output word count',
                                      valuue1: value3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 16.0, 16.0, 16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 31, 30, 30),
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(
                                      color: Color(0xFF304ffe),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        apiResponseText,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color.fromARGB(
                                              255, 247, 247, 247),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]),
                    )
                  : SizedBox.shrink(),
        ],
      ),
    );
  }

  void fetchFromApi(String text) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/items/"),
        headers: {
          'Content-Type': 'application/json'
        }, // Set content type to JSON
        body: jsonEncode({
          'rawdoc': text,
        }), // Encode the data as JSON
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Decoded JSON: $data');
        setState(() {
          // Set the received text to display in State 1
          apiResponseText = data['summary'] ?? '';
          count = data['num_words_input'];
          value3 = data['num_words_summary'];

          // Initialize to empty string
          currentState = 1;
          print('api:$apiResponseText');
          print(count);
          print(value3);
        });
        // Your code to handle the JSON data
      } else {
        print("Failed to fetch data. Status Code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }
}

class Card_num extends StatelessWidget {
  final String num;
  final int valuue1;

  const Card_num({super.key, required this.num, required this.valuue1});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    // Calculate the width of the Card
    double cardWidth = screenSize.width / 2.55;
    return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Color(0xFF304ffe),
        child: SizedBox(
          width: cardWidth,
          // Add content to the card using the child property
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  num,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(247, 240, 240, 240)),
                ),
                SizedBox(height: 8.0),
                Text(
                  valuue1.toString(),
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ));
  }
}
