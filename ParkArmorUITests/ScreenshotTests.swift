import XCTest

@MainActor
class ScreenshotTests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// Frame 01: Map tab — active parking session visible, timer running
    func testMapActive() throws {
        _ = launchApp(args: ["--screenshots"])
        sleep(4)
        snapshot("01-map-active")
    }

    /// Frame 02: Active parking detail sheet (timer + address + directions)
    func testActiveParkingDetail() throws {
        let app = launchApp(args: ["--screenshots"])
        sleep(4)
        // Tap whatever card/button surfaces the active session detail
        let sessionCard = app.buttons.matching(
            NSPredicate(format: "label CONTAINS[c] 'Ferry' OR label CONTAINS[c] 'Work Parking' OR label CONTAINS[c] 'active' OR identifier CONTAINS[c] 'active'")
        ).firstMatch
        if sessionCard.waitForExistence(timeout: 5) {
            sessionCard.tap()
            sleep(3)
        }
        snapshot("02-active-detail")
    }

    /// Frame 03: History tab — 3 past sessions with addresses + nicknames
    func testHistory() throws {
        let app = launchApp(args: ["--screenshots"])
        sleep(3)
        app.tabBars.buttons["History"].tap()
        sleep(2)
        snapshot("03-history")
    }

    /// Frame 04: Settings tab — preferences + Pro upgrade row
    func testSettings() throws {
        let app = launchApp(args: ["--screenshots"])
        sleep(3)
        app.tabBars.buttons["Settings"].tap()
        sleep(2)
        snapshot("04-settings")
    }

    /// Frame 05: Pro upgrade paywall
    func testUpgradePaywall() throws {
        let app = launchApp(args: ["--screenshots"])
        sleep(3)
        app.tabBars.buttons["Settings"].tap()
        sleep(1)
        let upgradeButton = app.buttons.matching(
            NSPredicate(format: "label CONTAINS[c] 'Pro' OR label CONTAINS[c] 'Upgrade' OR label CONTAINS[c] 'Unlock'")
        ).firstMatch
        if upgradeButton.waitForExistence(timeout: 4) {
            upgradeButton.tap()
            sleep(2)
        }
        snapshot("05-upgrade-paywall")
    }

    /// Frame 06: Save parking confirmation (no active session → free to save)
    func testSavePrompt() throws {
        let app = launchApp(args: ["--screenshots"])
        sleep(4)
        // Tap the primary park-here CTA
        let saveButton = app.buttons.matching(
            NSPredicate(format: "label CONTAINS[c] 'Park' OR label CONTAINS[c] 'Save' OR label CONTAINS[c] 'Here'")
        ).firstMatch
        if saveButton.waitForExistence(timeout: 5) {
            saveButton.tap()
            sleep(2)
        }
        snapshot("06-save-prompt")
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
