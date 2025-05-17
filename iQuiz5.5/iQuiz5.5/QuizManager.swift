class QuizManager {
    private var questions: [Question]
    private var currentQuestionIndex: Int
    private var score: Int
    private var skippedCount: Int

    init(questions: [Question]) {
        self.questions = questions
        self.currentQuestionIndex = 0
        self.score = 0
        self.skippedCount = 0
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
