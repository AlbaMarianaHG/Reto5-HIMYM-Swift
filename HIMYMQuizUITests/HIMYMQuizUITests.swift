import XCTest

final class HIMYMQuizUITests: XCTestCase {

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

    // MARK: - Screenshot function

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

    // MARK: - Complete quiz

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

        if captureQuestions {
            takeScreenshot(
                app: app,
                name: "01-Welcome"
            )
        }

        startButton.tap()

        for question in 0..<5 {

            let questionLabel = app.staticTexts[
                "PREGUNTA \(question + 1)"
            ]

            XCTAssertTrue(
                questionLabel.waitForExistence(timeout: 10)
            )

            if captureQuestions {
                takeScreenshot(
                    app: app,
                    name: "Question-\(question + 1)"
                )
            }

            let option = app.buttons[
                "answer_\(answers[question])"
            ]

            XCTAssertTrue(
                option.waitForExistence(timeout: 10)
            )

            option.tap()

            let nextButton = app.buttons["next_button"]

            XCTAssertTrue(nextButton.isEnabled)

            nextButton.tap()
        }

        // Verify character result
        let result = app.staticTexts["result_character"]

        XCTAssertTrue(
            result.waitForExistence(timeout: 10)
        )

        XCTAssertEqual(
            result.label,
            resultName
        )

        // Create a simple screenshot name
        let safeResultName = resultName.replacingOccurrences(
            of: " ",
            with: "-"
        )

        takeScreenshot(
            app: app,
            name: "Result-\(safeResultName)"
        )

        app.terminate()
    }

    // MARK: - Test all five characters

    func testCompleteQuizAndCaptureAllScreens() {

        let app = XCUIApplication()

        // Ted: capture welcome and all five questions
        playQuiz(
            app: app,
            answers: characterAnswers[0],
            captureQuestions: true,
            resultName: characterNames[0]
        )

        // Marshall, Lily, Barney and Robin
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
