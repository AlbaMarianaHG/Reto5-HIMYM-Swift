import SwiftUI

struct ContentView: View {

    // MARK: - Colores
    private let navy = Color(
        red: 0.07, green: 0.13, blue: 0.25
    )
    private let yellow = Color(
        red: 1.0, green: 0.78, blue: 0.20
    )
    private let cream = Color(
        red: 0.98, green: 0.97, blue: 0.94
    )

    // MARK: - Estado
    @State private var currentQuestion = 0
    @State private var answers: [Character] = []
    @State private var selectedOption: Int? = nil
    @State private var hasStarted = false
    @State private var isFinished = false
    @State private var result: Character = .ted

    var body: some View {
        ZStack {
            cream
                .ignoresSafeArea()

            if !hasStarted {
                welcomeView
            } else if isFinished {
                resultView
            } else {
                quizView
            }
        }
        .preferredColorScheme(.light)
    }

    // MARK: - Pantalla de bienvenida
    private var welcomeView: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("☂️")
                .font(.system(size: 95))

            Text("HOW I MET\nYOUR MOTHER")
                .font(.system(size: 34, weight: .black))
                .multilineTextAlignment(.center)
                .foregroundColor(navy)

            Text("THE PERSONALITY QUIZ")
                .font(.system(size: 14, weight: .bold))
                .tracking(3)
                .foregroundColor(.gray)

            Rectangle()
                .fill(yellow)
                .frame(width: 80, height: 5)
                .cornerRadius(5)

            Text("Which HIMYM\nCharacter Are You?")
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(navy)

            Text("Responde 5 preguntas y descubre si eres Ted, Marshall, Lily, Barney o Robin.")
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 25)

            Spacer()

            Button(action: startQuiz) {
                HStack {
                    Text("¡COMENZAR!")
                    Image(systemName: "arrow.right")
                }
                .font(.system(size: 17, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(yellow)
                .foregroundColor(navy)
                .cornerRadius(16)
            }
            .padding(.horizontal, 30)

            Text("It's going to be legendary!")
                .font(.system(size: 13, weight: .medium))
                .italic()
                .foregroundColor(.gray)
                .padding(.bottom, 25)
        }
        .padding()
    }

    // MARK: - Pantalla del cuestionario
    private var quizView: some View {
        let question = QuizData.questions[currentQuestion]

        return VStack(spacing: 20) {
            HStack {
                Text("☂️ HIMYM QUIZ")
                    .font(.system(size: 19, weight: .black))
                    .foregroundColor(navy)

                Spacer()

                Text("\(currentQuestion + 1) / \(QuizData.questions.count)")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(navy)
            }

            ProgressView(
                value: Double(currentQuestion + 1),
                total: Double(QuizData.questions.count)
            )
            .tint(yellow)
            .scaleEffect(x: 1, y: 2, anchor: .center)
            .padding(.vertical, 10)

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("PREGUNTA \(currentQuestion + 1)")
                        .font(.system(size: 13, weight: .bold))
                        .tracking(2)
                        .foregroundColor(.gray)

                    Text(question.title)
                        .font(.system(size: 27, weight: .bold))
                        .foregroundColor(navy)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 10)

                    ForEach(question.options) { option in
                        optionButton(option)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Button(action: nextQuestion) {
                HStack {
                    Text(
                        currentQuestion == QuizData.questions.count - 1
                        ? "VER MI RESULTADO"
                        : "SIGUIENTE PREGUNTA"
                    )

                    Image(systemName: "arrow.right")
                }
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    selectedOption == nil
                    ? Color.gray.opacity(0.3)
                    : yellow
                )
                .foregroundColor(navy)
                .cornerRadius(15)
            }
            .disabled(selectedOption == nil)
        }
        .padding(24)
    }

    // MARK: - Opciones de respuesta
    private func optionButton(
        _ option: AnswerOption
    ) -> some View {

        let isSelected = selectedOption == option.id

        return Button {
            selectedOption = option.id
        } label: {
            HStack(spacing: 12) {
                Text(String(
                    UnicodeScalar(65 + option.id)!
                ))
                .font(.system(size: 15, weight: .bold))
                .frame(width: 35, height: 35)
                .background(
                    isSelected ? yellow : cream
                )
                .clipShape(Circle())

                Text(option.text)
                    .font(.system(size: 15, weight: .medium))
                    .multilineTextAlignment(.leading)

                Spacer(minLength: 0)

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(navy)
                }
            }
            .foregroundColor(navy)
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                isSelected
                ? yellow.opacity(0.30)
                : Color.white
            )
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        isSelected ? yellow : Color.gray.opacity(0.2),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Pantalla de resultados
    private var resultView: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("☂️")
                    .font(.system(size: 65))

                Text("¡TU RESULTADO!")
                    .font(.system(size: 16, weight: .bold))
                    .tracking(3)
                    .foregroundColor(.gray)

                Text("YOU ARE...")
                    .font(.system(size: 22, weight: .black))
                    .foregroundColor(navy)

                Text(result.emoji)
                    .font(.system(size: 90))

                Text(result.rawValue)
                    .font(.system(size: 34, weight: .black))
                    .multilineTextAlignment(.center)
                    .foregroundColor(navy)

                Rectangle()
                    .fill(yellow)
                    .frame(width: 90, height: 5)
                    .cornerRadius(5)

                Text(result.description)
                    .font(.system(size: 17))
                    .multilineTextAlignment(.center)
                    .foregroundColor(navy)
                    .padding(22)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(18)

                Text("LEGENDARY!")
                    .font(.system(size: 22, weight: .black))
                    .foregroundColor(navy)

                Button(action: restartQuiz) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("VOLVER A JUGAR")
                    }
                    .font(.system(size: 17, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(yellow)
                    .foregroundColor(navy)
                    .cornerRadius(16)
                }
                .padding(.top, 10)
            }
            .frame(maxWidth: .infinity)
            .padding(25)
        }
    }

    // MARK: - Funciones del cuestionario

    private func startQuiz() {
        currentQuestion = 0
        answers = []
        selectedOption = nil
        isFinished = false
        hasStarted = true
    }

    private func nextQuestion() {
        guard selectedOption != nil else {
            return
        }

        let question = QuizData.questions[currentQuestion]

        guard let selected = question.options.first(
            where: { $0.id == selectedOption }
        ) else {
            return
        }

        answers.append(selected.character)

        if currentQuestion < QuizData.questions.count - 1 {
            currentQuestion += 1
            selectedOption = nil
        } else {
            result = QuizData.calculateResult(
                answers: answers
            )
            isFinished = true
        }
    }

    private func restartQuiz() {
        currentQuestion = 0
        answers = []
        selectedOption = nil
        isFinished = false
        hasStarted = false
    }
}
