import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project/pages/MainPage.dart';
import 'package:project/pages/user/Mypage/WrongProblem.dart';
import 'package:project/pages/user/Mypage/WrongProblemCommentaryPage.dart';

class MyApp extends StatelessWidget {
  final int userId;
  final String apiUrl;
  final int index;
  final String profileImagePath;
  const MyApp({
    Key? key,
    required this.index,
    required this.userId,
    required this.apiUrl,
    required this.profileImagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Wrongproblemdetails(
          index: index,
          userId: userId,
          apiUrl: apiUrl,
          profileImagePath: profileImagePath),
    );
  }
}

class Problem {
  final int q_id;
  final String question;
  final List<String> options;
  final int correctOption;

  Problem({
    required this.q_id,
    required this.question,
    required this.options,
    required this.correctOption,
  });
}

class Wrongproblemdetails extends StatefulWidget {
  final int index;
  final int userId;
  final String apiUrl;
  final String profileImagePath;

  Wrongproblemdetails({
    Key? key,
    required this.index,
    required this.userId,
    required this.apiUrl,
    required this.profileImagePath,
  }) : super(key: key);

  @override
  _WrongproblemdetailsState createState() => _WrongproblemdetailsState();
}

class _WrongproblemdetailsState extends State<Wrongproblemdetails> {
  late Future<Problem> _futureProblem;

  @override
  void initState() {
    super.initState();
    _futureProblem = fetchProblem(widget.index);
  }

  Future<Problem> fetchProblem(int index) async {
    final url = Uri.parse('${widget.apiUrl}/scripts/$index/questions');
    final response =
        await http.get(url, headers: {'Accept': 'application/json'});

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body)[0];

      return Problem(
        q_id: jsonResponse['q_id'],
        question: jsonResponse['question'],
        options: [
          jsonResponse['option_1'],
          jsonResponse['option_2'],
          jsonResponse['option_3'],
          jsonResponse['option_4'],
        ],
        correctOption: jsonResponse['answer_option'],
      );
    } else {
      throw Exception('Failed to load question');
    }
  }

  final List<Color> buttonColors = [
    const Color(0xFF8BC0FF),
    const Color(0xFF55A3FF),
    const Color(0xFF0075FF),
    const Color(0xFF0056BD),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Problem>(
          future: _futureProblem,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              Problem problem = snapshot.data!;

              return LayoutBuilder(
                builder: (context, constraints) {
                  double containerWidth = constraints.maxWidth * 0.8;
                  double containerHeight = constraints.maxHeight * 0.65;

                  return Stack(
                    children: [
                      Center(
                        child: Container(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Align(
                            alignment: const Alignment(0, 0.3),
                            child: Container(
                              width: containerWidth,
                              height: containerHeight,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 2,
                                    color: Color(0xFF4399FF),
                                  ),
                                  borderRadius: BorderRadius.circular(17),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 20), // 간격 조정
                                  SizedBox(
                                    width: 224,
                                    child: Text(
                                      problem.question,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14, // 텍스트 크기 조정

                                        fontWeight: FontWeight.w400,
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 20), // 간격 조정
                                  for (int i = 0;
                                      i < problem.options.length;
                                      i++) ...[
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: buttonColors[i],
                                        fixedSize:
                                            const Size(210, 50), // 버튼 크기 조정
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Wrongproblemcommentarypage(
                                                    q_id: problem.q_id,
                                                    selectedChoice:
                                                        problem.options[i],
                                                    selectedChoiceNum: i + 1,
                                                    correctOption:
                                                        problem.correctOption,
                                                    index: widget.index,
                                                    userId: widget.userId,
                                                    apiUrl: widget.apiUrl,
                                                    profileImagePath: widget
                                                        .profileImagePath),
                                          ),
                                        ); // 보기 버튼을 누를 때 페이지로 해당 보기의 텍스트 전달
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                width: 25,
                                                height: 25,
                                                decoration:
                                                    const ShapeDecoration(
                                                  color: Colors.white,
                                                  shape: OvalBorder(),
                                                ),
                                              ),
                                              Text(
                                                '${i + 1}',
                                                style: const TextStyle(
                                                  color: Color(0xFF0075FF),
                                                  fontSize: 20, // 텍스트 크기 조정

                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                              width: 10), // 적절한 간격을 위해 추가
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                problem.options[i],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16, // 텍스트 크기 조정

                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20), // 간격 조정
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 60,
                        right: 50,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            'assets/img/backbtn.png',
                            width: 45,
                            height: 45,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 68,
                        left: 55,
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/img/circle.png',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              '틀린 문제',
                              style: TextStyle(
                                fontSize: 18, // 텍스트 크기 조정
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              return const Text('No data');
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/img/backbtn.png',
              width: 24,
              height: 24,
            ),
            label: 'Back',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/img/homebtn.png',
              width: 28,
              height: 28,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/img/mypagebtn.png',
              width: 24,
              height: 24,
            ),
            label: 'My Page',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pop(context);
              break;
            case 1:
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => MainPage()),
              // );
              break;
            case 2:
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => MainPage()),
              // );
              break;
          }
        },
      ),
    );
  }
}
