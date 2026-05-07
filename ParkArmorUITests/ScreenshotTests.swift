import XCTest

@MainActor
class ScreenshotTests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// Frame 01: Map tab — empty state, tap-to-park hero CTA
    func testMapEmpty() throws {
        let app = launchApp(args: ["--screenshots"])
        sleep(3)
        snapshot("01-map-empty")
    }

    /// Frame 02: History tab — empty state with prompt
    func testHistoryEmpty() throws {
        let app = launchApp(args: ["--screenshots"])
        sleep(2)
        app.tabBars.buttons["History"].tap()
        sleep(2)
        snapshot("02-history-empty")
    }

    /// Frame 03: Settings tab — preferences + Pro upgrade row
    func testSettings() throws {
        let app = launchApp(args: ["--screenshots"])
        sleep(2)
        app.tabBars.buttons["Settings"].tap()
        sleep(2)
        snapshot("03-settings")
    }

    /// Frame 04: Pro upgrade paywall
    func testUpgradePaywall() throws {
        let app = launchApp(args: ["--screenshots"])
        sleep(2)
        // Navigate to Settings and tap the first upgrade / Pro button
        app.tabBars.buttons["Settings"].tap()
        sleep(1)
        let upgradeButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Pro' OR label CONTAINS[c] 'Upgrade' OR label CONTAINS[c] 'Unlock'")).firstMatch
        if upgradeButton.waitForExistence(timeout: 4) {
            upgradeButton.tap()
            sleep(2)
        }
        snapshot("04-upgrade-paywall")
    }

    /// Frame 05: Map tab — save parking confirmation prompt
    func testSaveParkingPrompt() throws {
        let app = launchApp(args: ["--screenshots"])
        sleep(2)
        // Tap the primary CTA on the map to initiate parking save
        let saveButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Park' OR label CONTAINS[c] 'Save' OR label CONTAINS[c] 'Here'")).firstMatch
        if saveButton.waitForExistence(timeout: 5) {
            saveButton.tap()
            sleep(2)
        }
        snapshot("05-save-parking")
    }

    /// Frame 06: Widget / CarPlay description in Settings
    func testWidgetInfo() throws {
        let app = launchApp(args: ["--screenshots"])
        sleep(2)
        app.tabBars.buttons["Settings"].tap()
        sleep(1)
        let widgetCell = app.cells.matching(NSPredicate(format: "label CONTAINS[c] 'Widget' OR label CONTAINS[c] 'CarPlay'")).firstMatch
        if widgetCell.waitForExistence(timeout: 4) {
            widgetCell.tap()
            sleep(2)
        }
        snapshot("06-widget-carplay")
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
