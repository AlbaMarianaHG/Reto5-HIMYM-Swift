import XCTest

final class HIMYMQuizUITests: XCTestCase {

    // Respuestas para obtener cada uno de los cinco personajes.
    // Cada número representa una opción de respuesta.

    let characterAnswers: [[Int]] = [
        [0, 4, 0, 2, 0], // Ted
        [1, 0, 1, 1, 1], // Marshall
        [2, 3, 2, 3, 2], // Lily
        [3, 1, 3, 4, 3], // Barney
        [4, 2, 4, 0, 4]  // Robin
    ]

    let characterNames = [
        "Ted Mosby",
        "Marshall Eriksen",
        "Lily Aldrin",
        "Barney Stinson",
        "Robin Scherbatsky"
    ]

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    // MARK: - Capturas de pantalla

    func takeScreenshot(
        app: XCUIApplication,
        name: String
    ) {
        let attachment = XCTAttachment(
            screenshot: app.screenshot()
        )

        attachment.name = name
        attachment.lifetime = .keepAlways

        add(attachment)
    }

    // MARK: - Recorrido completo del cuestionario

    func playQuiz(
        app: XCUIApplication,
        answers: [Int],
        captureQuestions: Bool,
        resultName: String
    ) {

        app.launch()

        let startButton = app.buttons["start_button"]

        XCTAssertTrue(
            startButton.waitForExistence(timeout: 10)
        )

        // Captura de bienvenida
        if captureQuestions {
            takeScreenshot(
                app: app,
                name: "01-Welcome"
            )
        }

        startButton.tap()

        // Recorrer las cinco preguntas
        for question in 0..<5 {

            let questionLabel = app.staticTexts[
                "PREGUNTA \(question + 1)"
            ]

            XCTAssertTrue(
                questionLabel.waitForExistence(timeout: 10)
            )

            // Capturar cada pregunta
            if captureQuestions {
                takeScreenshot(
                    app: app,
                    name: "Question-\(question + 1)"
                )
            }

            // Seleccionar una respuesta
            let option = app.buttons[
                "answer_\(answers[question])"
            ]

            XCTAssertTrue(
                option.waitForExistence(timeout: 10)
            )

            option.tap()

            // Comprobar que el botón siguiente está habilitado
            let nextButton = app.buttons["next_button"]

            XCTAssertTrue(nextButton.isEnabled)

            nextButton.tap()
        }

        // Comprobar el resultado
        let result = app.staticTexts["result_character"]

        XCTAssertTrue(
            result.waitForExistence(timeout: 10)
        )

        XCTAssertEqual(
            result.label,
            resultName
        )

        // Capturar el personaje obtenido
        takeScreenshot(
            app: app,
            name: "Result-\(resultName.replacingOccurrences(
                of: " ",
                with: "-"
            ))"
        )

        app.terminate()
    }

    // MARK: - Prueba de los cinco personajes

    func testCompleteQuizAndCaptureAllScreens() {

        let app = XCUIApplication()

        // Primer recorrido: Ted y capturas de las preguntas.
        playQuiz(
            app: app,
            answers: characterAnswers[0],
            captureQuestions: true,
            resultName: characterNames[0]
        )

        // Recorridos restantes: Marshall, Lily, Barney y Robin.
        for index in 1..<characterAnswers.count {

            playQuiz(
                app: app,
                answers: characterAnswers[index],
                captureQuestions: false,
                resultName: characterNames[index]
            )
        }
    }
}
