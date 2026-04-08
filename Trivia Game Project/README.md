# Trivia-Games
Trivia Game App is a SwiftUI-based iOS application that allows users to test their knowledge by answering trivia questions fetched from an online API. The app includes customizable quiz options, a countdown timer, and real-time scoring. Users can input answers and view their final score at the end of the quiz.

##  Features
-  Custom quiz options (amount, category, difficulty, type)
-  Fetches questions from Open Trivia DB API
-  Countdown timer for the entire quiz
-  Text input for answers
-  Real-time answer validation
-  Final score display after submission
-  HTML decoding for properly formatted questions and answers
-  Clean and responsive UI using SwiftUI

---

##  Technologies Used
- Swift
- SwiftUI
- MVVM Architecture
- URLSession (Networking)
- JSON Decoding
- Open Trivia Database API

---

##  How It Works
1. User selects quiz options (number of questions, difficulty, etc.)
2. App fetches trivia questions from the API
3. Questions are displayed one by one in a scrollable view
4. User inputs answers in text fields
5. Timer counts down during the quiz
6. Upon submission (or when time runs out):
   - Answers are validated
   - Score is calculated and displayed
   - Correct answers are shown

---

## 🎥 Video Walkthrough
My video walkthrough: https://youtu.be/lmEmqQZqTkU

---

##  Challenges Faced
- Handling HTML-encoded text from API responses
- Ensuring accurate answer comparison (case-insensitive and symbol handling)
- Managing timer synchronization with UI updates
- Fixing keyboard input and focus issues in SwiftUI

---

##  Future Improvements
- Multiple choice question support
- Persistent score tracking
- Firebase integration for saving results
- Enhanced UI/UX with animations
- Leaderboard functionality

---

##  Author
Serkens Delice
