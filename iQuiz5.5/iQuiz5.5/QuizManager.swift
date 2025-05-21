import Foundation

class QuizManager {
    static let shared = QuizManager()
    
    private var questions: [Question]
    private var currentQuestionIndex: Int
    private var score: Int
    private var skippedCount: Int
    private var currentTopic: QuizTopic?
    
    private init() {
        self.questions = []
        self.currentQuestionIndex = 0
        self.score = 0
        self.skippedCount = 0
    }
    
    func loadQuiz(for topic: QuizTopic) {
        self.currentTopic = topic
        self.questions = topic.questions.map { Question(text: $0.text, options: $0.answers, correctAnswerIndex: $0.answers.firstIndex(of: $0.answer) ?? 0) }
        resetQuiz()
        
        // Save to local storage
        if let quizzes = StorageManager.shared.loadQuizzes() {
            var updatedQuizzes = quizzes
            if let index = updatedQuizzes.firstIndex(where: { $0.title == topic.title }) {
                updatedQuizzes[index] = topic
            } else {
                updatedQuizzes.append(topic)
            }
            StorageManager.shared.saveQuizzes(updatedQuizzes)
        } else {
            StorageManager.shared.saveQuizzes([topic])
        }
    }

    func getNextQuestion() -> Question? {
        guard currentQuestionIndex < questions.count else { return nil }
        let question = questions[currentQuestionIndex]
        currentQuestionIndex += 1
        return question
    }

    func hasMoreQuestions() -> Bool {
        return currentQuestionIndex < questions.count
    }

    func recordAnswer(isCorrect: Bool) {
        if isCorrect {
            score += 1
        }
    }

    func recordSkip() {
        skippedCount += 1
    }

    func getScore() -> Int {
        return score
    }

    func getTotalQuestions() -> Int {
        return questions.count
    }

    func getSkippedCount() -> Int {
        return skippedCount
    }

    func resetQuiz() {
        currentQuestionIndex = 0
        score = 0
        skippedCount = 0
    }
}
