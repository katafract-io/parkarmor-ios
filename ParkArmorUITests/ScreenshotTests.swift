import XCTest

@MainActor
class ScreenshotTests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// Home: parking session active, timer running
    func testHomeActive() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--screenshots"]
        setupSnapshot(app)
        app.launch()
        snapshot("01-home-active")
    }

    /// Map view: current location + parked spot pin
    func testMapView() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--screenshots"]
        setupSnapshot(app)
        app.launch()
        snapshot("02-map-view")
    }

    /// Timer settings: duration + notification prefs
    func testTimerSettings() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--screenshots"]
        setupSnapshot(app)
        app.launch()
        snapshot("03-timer-settings")
    }

    /// Completed session: duration + distance
    func testSessionComplete() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--screenshots"]
        setupSnapshot(app)
        app.launch()
        snapshot("04-session-complete")
    }

    /// History: list of past sessions
    func testHistory() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--screenshots"]
        setupSnapshot(app)
        app.launch()
        snapshot("05-history")
    }

    /// Pro paywall: upgrade features sheet
    func testUpgradePaywall() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--screenshots"]
        setupSnapshot(app)
        app.launch()
        snapshot("06-upgrade-paywall")
    }
}
