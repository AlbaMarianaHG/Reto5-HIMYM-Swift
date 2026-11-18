import Foundation

// MARK: - Personajes

enum Character: String, CaseIterable, Hashable {
    case ted = "Ted Mosby"
    case marshall = "Marshall Eriksen"
    case lily = "Lily Aldrin"
    case barney = "Barney Stinson"
    case robin = "Robin Scherbatsky"

    var emoji: String {
        switch self {
        case .ted: return "💙"
        case .marshall: return "🐻"
        case .lily: return "🎨"
        case .barney: return "👔"
        case .robin: return "🎤"
        }
    }

    var description: String {
        switch self {
        case .ted:
            return "Eres una persona romántica, soñadora y sentimental. Crees en el amor verdadero y nunca dejas de buscar aquello que te hace feliz."

        case .marshall:
            return "Eres leal, divertido/a y de gran corazón. Tus amigos y tu familia son lo más importante para ti."

        case .lily:
            return "Eres creativo/a, inteligente y cariñoso/a. Te gusta ayudar a los demás y siempre encuentras una solución original."

        case .barney:
            return "Eres una persona segura, extrovertida y aventurera. Te encantan las experiencias nuevas y hacer que cada momento sea legendario."

        case .robin:
            return "Eres independiente, valiente y decidido/a. Persigues tus sueños y no tienes miedo de tomar tus propias decisiones."
        }
    }
}

// MARK: - Modelos del cuestionario

struct AnswerOption: Identifiable {
    let id: Int
    let text: String
    let character: Character
}

struct QuizQuestion: Identifiable {
    let id: Int
    let title: String
    let options: [AnswerOption]
}

// MARK: - Preguntas

enum QuizData {
    static let questions: [QuizQuestion] = [
        QuizQuestion(
            id: 1,
            title: "¿Cómo sería tu fin de semana perfecto?",
            options: [
                AnswerOption(id: 0, text: "Buscar el amor o salir con alguien especial.", character: .ted),
                AnswerOption(id: 1, text: "Pasar tiempo con mis amigos y seres queridos.", character: .marshall),
                AnswerOption(id: 2, text: "Organizar planes con las personas que quiero.", character: .lily),
                AnswerOption(id: 3, text: "Salir de fiesta y vivir experiencias increíbles.", character: .barney),
                AnswerOption(id: 4, text: "Viajar, hacer deporte o descubrir algo nuevo.", character: .robin)
            ]
        ),
        QuizQuestion(
            id: 2,
            title: "¿Qué es lo que más valoras en una amistad?",
            options: [
                AnswerOption(id: 0, text: "Que siempre estén ahí para mí.", character: .marshall),
                AnswerOption(id: 1, text: "Que me hagan reír y nunca me aburra.", character: .barney),
                AnswerOption(id: 2, text: "Que respeten mi independencia.", character: .robin),
                AnswerOption(id: 3, text: "Que me escuchen y me den buenos consejos.", character: .lily),
                AnswerOption(id: 4, text: "Que compartamos conversaciones profundas.", character: .ted)
            ]
        ),
        QuizQuestion(
            id: 3,
            title: "Si tuvieras que describirte con una palabra, ¿cuál elegirías?",
            options: [
                AnswerOption(id: 0, text: "Romántico/a.", character: .ted),
                AnswerOption(id: 1, text: "Leal.", character: .marshall),
                AnswerOption(id: 2, text: "Creativo/a.", character: .lily),
                AnswerOption(id: 3, text: "Audaz.", character: .barney),
                AnswerOption(id: 4, text: "Independiente.", character: .robin)
            ]
        ),
        QuizQuestion(
            id: 4,
            title: "¿Cómo reaccionas cuando tienes un problema?",
            options: [
                AnswerOption(id: 0, text: "Intento resolverlo por mi cuenta.", character: .robin),
                AnswerOption(id: 1, text: "Busco apoyo en las personas que quiero.", character: .marshall),
                AnswerOption(id: 2, text: "Analizo todas las posibilidades.", character: .ted),
                AnswerOption(id: 3, text: "Busco una solución diferente y creativa.", character: .lily),
                AnswerOption(id: 4, text: "Confío en mí y encuentro cómo salir adelante.", character: .barney)
            ]
        ),
        QuizQuestion(
            id: 5,
            title: "¿Qué frase representa mejor tu forma de ver la vida?",
            options: [
                AnswerOption(id: 0, text: "El amor siempre vale la pena.", character: .ted),
                AnswerOption(id: 1, text: "La familia y los amigos son lo más importante.", character: .marshall),
                AnswerOption(id: 2, text: "La vida es mejor cuando la compartes.", character: .lily),
                AnswerOption(id: 3, text: "Disfruta la vida y haz que cada momento cuente.", character: .barney),
                AnswerOption(id: 4, text: "Nunca dejes de perseguir tus sueños.", character: .robin)
            ]
        )
    ]

    // Calcula el personaje ganador usando un diccionario,
    // operadores, condicionales y un ciclo for.
    static func calculateResult(
        answers: [Character]
    ) -> Character {
        var scores: [Character: Int] = [:]

        for character in Character.allCases {
            scores[character] = 0
        }

        for answer in answers {
            scores[answer, default: 0] += 1
        }

        var winner: Character = .ted
        var highestScore = -1

        // En caso de empate se usa la primera respuesta
        // del usuario como criterio de desempate.
        for character in Character.allCases {
            let score = scores[character, default: 0]

            if score > highestScore {
                highestScore = score
                winner = character
            } else if score == highestScore &&
                      answers.first == character {
                winner = character
            }
        }

        return winner
    }
}
