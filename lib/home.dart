import 'package:flutter/material.dart';
import 'package:flutter_mentor_quiz_app_tut/answer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Icon> _scoreTracker = [];
  int _questionIndex = 0;
  int _totalScore = 0;
  bool answerWasSelected = false;
  bool endOfQuiz = false;
  bool correctAnswerSelected = false;

  void _questionAnswered(bool answerScore) {
    setState(() {
      // answer was selected
      answerWasSelected = true;
      // check if answer was correct
      if (answerScore) {
        _totalScore++;
        correctAnswerSelected = true;
      }
      // adding to the score tracker on top
      /*_scoreTracker.add(
        answerScore
            ? Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            : Icon(
                Icons.clear,
                color: Colors.red,
              ),
      );*/
      //when the quiz ends
      if (_questionIndex + 1 == _questions.length) {
        endOfQuiz = true;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _questionIndex++;
      answerWasSelected = false;
      correctAnswerSelected = false;
    });
    // what happens at the end of the quiz
    if (_questionIndex >= _questions.length) {
      _resetQuiz();
    }
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
      _scoreTracker = [];
      endOfQuiz = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Time for Quiz',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                if (_scoreTracker.length == 0)
                  SizedBox(
                    height: 25.0,
                  ),
                if (_scoreTracker.length > 0) ..._scoreTracker
              ],
            ),
            Container(
              width: double.infinity,
              height: 130.0,
              margin: EdgeInsets.only(bottom: 10.0, left: 30.0, right: 30.0),
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  _questions[_questionIndex]['question'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ...(_questions[_questionIndex]['answers']
                    as List<Map<String, Object>>)
                .map(
              (answer) => Answer(
                answerText: answer['answerText'],
                answerColor: answerWasSelected
                    ? answer['score']
                        ? Colors.green
                        : Colors.red
                    : null,
                answerTap: () {
                  // if answer was already selected then nothing happens onTap
                  if (answerWasSelected) {
                    return;
                  }
                  //answer is being selected
                  _questionAnswered(answer['score']);
                },
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40.0),
              ),
              onPressed: () {
                if (!answerWasSelected) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Please select an answer before going to the next question'),
                  ));
                  return;
                }
                _nextQuestion();
              },
              child: Text(endOfQuiz ? 'Re-attempt Quiz' : 'Next Question'),
            ),
            Container(
              //padding: EdgeInsets.all(20.0),
              width: 100.0,
              height: 60.0,
              margin: EdgeInsets.only(bottom: 5.0, left: 15.0, right: 15.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Center(
              child: Text(
                '${_totalScore.toString()}/${_questions.length}',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.redAccent),
              ),
              ),
            ),
            if (answerWasSelected && !endOfQuiz)
              Container(
                height: 100,
                width: double.infinity,
                color: correctAnswerSelected ? Colors.green : Colors.red,
                child: Center(
                  child: Text(
                    correctAnswerSelected
                        ? 'Well done, you got it right!'
                        : 'Wrong :/',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (endOfQuiz)
              Container(
                height: 100,
                width: double.infinity,
                color: Colors.lightGreen,
                child: Center(
                  child: Text(
                    _totalScore > 12
                        ? 'Congratulations! Your final score is: $_totalScore'
                        : 'Your final score is: $_totalScore. Better luck next time!',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: _totalScore > 4 ? Colors.deepPurple : Colors.red,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final _questions = const [
  {
    'question': 'Q1: How many bones are in the human body?',
    'answers': [
      {'answerText': '206', 'score': true},
      {'answerText': '205', 'score': false},
      {'answerText': '306', 'score': false},
    ],
  },
  {
    'question':
        'Q2: What is the biggest planet in our solar system?',
    'answers': [
      {'answerText': 'Neptune', 'score': false},
      {'answerText': 'Mars', 'score': false},
      {'answerText': 'Jupiter', 'score': true},
    ],
  },
  {
    'question': 'Q3: Which famous British physicist wrote A Brief History of Time?',
    'answers': [
      {'answerText': 'James Chadwick', 'score': false},
      {'answerText': 'Isaac Newton', 'score': false},
      {'answerText': 'Stephen Hawking', 'score': true},
    ],
  },
  {
    'question': 'Q4: Who is the father of Computer?',
    'answers': [
      {'answerText': 'Albert Einstein', 'score': false},
      {'answerText': 'Charles Babbage', 'score': true},
      {'answerText': 'Dennis Ritchie', 'score': false},
    ],
  },
  {
    'question':
        'Q5: Who is the father of Computer science?',
    'answers': [
      {'answerText': 'Allen Turing', 'score': true},
      {'answerText': 'Michael Faraday', 'score': false},
      {'answerText': 'William Procter Jr.', 'score': false},
    ],
  },
  {
    'question': 'Q6: Which country won the first ever football world cup?',
    'answers': [
      {'answerText': 'Uruguay', 'score': true},
      {'answerText': 'Brazil', 'score': false},
      {'answerText': 'France', 'score': false},
    ],
  },
  {
    'question': 'Q7: Which country won the first ever rugby world cup?',
    'answers': [
      {'answerText': 'New Zealand', 'score': true},
      {'answerText': 'England', 'score': false},
      {'answerText': 'India', 'score': false},
    ],
  },
  {
    'question': 'Q8: In football, which team has won the Champions League (formerly the European Cup) the most?',
    'answers': [
      {'answerText': 'Liverpool', 'score': false},
      {'answerText': 'Barcelona', 'score': false},
      {'answerText': 'Real Madrid', 'score': true},
    ],
  },
  {
    'question': 'Q9: Which national team are called “Baggy Greens”?',
    'answers': [
      {'answerText': 'Pakistan', 'score': false},
      {'answerText': 'Australia', 'score': true},
      {'answerText': 'England', 'score': false},
    ],
  },
  {
    'question': 'Q10: What is Roger Federer home country?',
    'answers': [
      {'answerText': 'Switzerland', 'score': true},
      {'answerText': 'Denmark', 'score': false},
      {'answerText': 'Australia', 'score': false},
    ],
  },
  {
    'question': 'Q11: Dhaka is the capital of Bangladesh. On which river it is situated?',
    'answers': [
      {'answerText': 'Meghna', 'score': false},
      {'answerText': 'Buriganga', 'score': true},
      {'answerText': 'Padma', 'score': false},
    ],
  },
  {
    'question': 'Q12: What is the national language of Bangladesh?',
    'answers': [
      {'answerText': 'Urdu', 'score': false},
      {'answerText': 'English', 'score': false},
      {'answerText': 'Bangla', 'score': true},
    ],
  },
  {
    'question': 'Q13: The nation of Bangladesh was formed from the historic region of Bengal. In which year did it gain independence?',
    'answers': [
      {'answerText': '1948', 'score': false},
      {'answerText': '1952', 'score': false},
      {'answerText': '1971', 'score': true},
    ],
  },
  {
    'question': 'Q14: What is the currency of Bangladesh?',
    'answers': [
      {'answerText': 'Dirham', 'score': false},
      {'answerText': 'Taka', 'score': true},
      {'answerText': 'Rupi', 'score': false},
    ],
  },
  {
    'question': 'Q15: What is the national flower of Bangladesh?',
    'answers': [
      {'answerText': 'Water Lily', 'score': true},
      {'answerText': 'Sunflower', 'score': false},
      {'answerText': 'Rose', 'score': false},
    ],
  },
  {
    'question': 'Q16: What’s the national flower of Japan? ',
    'answers': [
      {'answerText': 'Orchid', 'score': false},
      {'answerText': 'Tulip', 'score': false},
      {'answerText': 'Cherry blossom', 'score': true},
    ],
  },
  {
    'question': 'Q17: What’s the smallest country in the world?',
    'answers': [
      {'answerText': 'Singapur', 'score': false},
      {'answerText': 'Maldives', 'score': false},
      {'answerText': 'The Vatican', 'score': true},
    ],
  },
  {
    'question': 'Q18: What’s the national animal of Australia?',
    'answers': [
      {'answerText': 'Crocodiles', 'score': false},
      {'answerText': 'Red Kangaroo', 'score': true},
      {'answerText': 'Tiger', 'score': false},
    ],
  },
  {
    'question': 'Q19: Where is Billie Eilish from?',
    'answers': [
      {'answerText': 'Australia', 'score': false},
      {'answerText': 'Sweden', 'score': false},
      {'answerText': 'Los Angeles', 'score': true},
    ],
  },
  {
    'question': 'Q20: Name the best-selling book series of the 21st century?',
    'answers': [
      {'answerText': 'Harry Potter series', 'score': true},
      {'answerText': 'The Hunger Games', 'score': false},
      {'answerText': 'Twilight series', 'score': false},
    ],
  },
  {
    'question': 'Q21: Name of the first country to launch the satellite into space?',
    'answers': [
      {'answerText': 'China', 'score': false},
      {'answerText': 'US', 'score': false},
      {'answerText': 'Russia', 'score': true},
    ],
  },
  {
    'question': 'Q22: First Woman Prime Minister Of Any Muslim Country?',
    'answers': [
      {'answerText': 'Tansu Çiller (Turkey)', 'score': false},
      {'answerText': 'Sheikh Hasina (Bangladesh)', 'score': false},
      {'answerText': 'Benazir Bhutto (Pakistan)', 'score': true},
    ],
  },
  {
    'question': 'Q23: Name of the first country to issue paper currency?',
    'answers': [
      {'answerText': 'UK', 'score': false},
      {'answerText': 'England', 'score': false},
      {'answerText': 'China', 'score': true},
    ],
  },
  {
    'question': 'Q24: Name of the first Country to make a constitution?',
    'answers': [
      {'answerText': 'Russia', 'score': false},
      {'answerText': 'UK', 'score': false},
      {'answerText': 'US', 'score': true},
    ],
  },
  {
    'question': 'Q25: Who was the first woman to climb Mount Everest?',
    'answers': [
      {'answerText': 'Ms. Sharon Wood (Canada)', 'score': false},
      {'answerText': 'Ms. Bachendri Pal (India)', 'score': false},
      {'answerText': 'Junko Tabei (Japan)', 'score': true},
    ],
  },
  {
    'question': 'Q26: In which city would you find the world’s tallest building?',
    'answers': [
      {'answerText': 'Spain', 'score': false},
      {'answerText': 'Australia', 'score': false},
      {'answerText': 'Dubai', 'score': true},
    ],
  },
  {
    'question': 'Q27: Where is the worlds largest desert?',
    'answers': [
      {'answerText': 'The Antarctic', 'score': true},
      {'answerText': 'Gobi', 'score': false},
      {'answerText': 'Sahara', 'score': false},
    ],
  },
  {
    'question': 'Q28: In which ocean is the worlds deepest oceanic trench, the Mariana?',
    'answers': [
      {'answerText': 'Indian Ocean', 'score': false},
      {'answerText': 'Atlantic', 'score': false},
      {'answerText': 'Pacific', 'score': true},
    ],
  },
  {
    'question': 'Q29: What is the worlds largest island?',
    'answers': [
      {'answerText': 'Madagascar', 'score': false},
      {'answerText': 'Greenland', 'score': true},
      {'answerText': 'Papua New Guinea', 'score': false},
    ],
  },
  {
    'question': 'Q30: Which city has the highest rooftop bar?',
    'answers': [
      {'answerText': 'China', 'score': false},
      {'answerText': 'North Korea', 'score': false},
      {'answerText': 'Hong Kong', 'score': true},
    ],
  },
];
