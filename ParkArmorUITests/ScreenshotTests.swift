import XCTest

@MainActor
class ScreenshotTests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// Home: parking session active, timer running
    func testHomeActive() throws {
        let app = launchApp(args: ["--screenshots"])
        snapshot("01-home-active")
    }

    /// Map view: current location + parked spot pin
    func testMapView() throws {
        let app = launchApp(args: ["--screenshots"])
        snapshot("02-map-view")
    }

    /// Timer settings: duration + notification prefs
    func testTimerSettings() throws {
        let app = launchApp(args: ["-mscreenshots"])
        snapshot("03-timer-settings")
    }

    /// Completed session: duration + distance
    func testSessionComplete() throws {
        let app = launchApp(args: ["--screenshots"])
        snapshot("04-session-complete")
    }

    /// History: list of past sessions
    func testHistory() throws {
        let app = launchApp(args: ["--screenshots"])
        snapshot("05-history")
    }

    /// Pro paywall: upgrade features sheet
    func testUpgradePaywall() throws {
        let app = launchApp(args: ["--screenshots"])
        snapshot("06-upgrade-paywall")
    }

    @discardableResult
    private func launchApp(args: [String]) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = args
        setupSnapshot(app)
        app.launch()
        XCTAssertTrue(
            app.wait(for: .runningForeground, timeout: 30),
            "App did not reach foreground within 30s — aborting to avoid silent 0-PNG run"
        )
        return app
    }
}
