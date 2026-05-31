import XCTest

@MainActor
class ScreenshotTests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// Frame 01 — HERO (App Store search result). The saved-spot detail sheet:
    /// named location + photo of the parking sign + "Level 3, Row B" note +
    /// live meter countdown + walk-back distance. This is the converting screen
    /// and MUST be frame 1 (alphabetically-first snapshot name wins ordering).
    func testActiveDetailHero() throws {
        let app = launchApp(args: ["--screenshots"])
        sleep(4)
        // Open the saved-spot detail from the active banner or map pin.
        let opener = app.descendants(matching: .any).matching(
            NSPredicate(format:
                "label CONTAINS[c] 'Embarcadero' OR label CONTAINS[c] 'My Car' OR " +
                "label CONTAINS[c] 'Active parking' OR identifier CONTAINS[c] 'active'")
        ).firstMatch
        if opener.waitForExistence(timeout: 6) {
            opener.tap()
            sleep(3)
        }
        snapshot("01-active-detail")
    }

    /// Frame 02 — Map with the active spot pinned + the active banner up top
    /// (address + live countdown). Reinforces "your car is on the map".
    func testMapActive() throws {
        _ = launchApp(args: ["--screenshots"])
        sleep(4)
        snapshot("02-map-active")
    }

    /// Frame 03 — Meter countdown close-up (beat-the-meter). Opens the detail
    /// sheet, which surfaces the large BrandedCountdown timer.
    func testMeterTimer() throws {
        let app = launchApp(args: ["--screenshots"])
        sleep(4)
        let opener = app.descendants(matching: .any).matching(
            NSPredicate(format:
                "label CONTAINS[c] 'Embarcadero' OR label CONTAINS[c] 'My Car' OR " +
                "label CONTAINS[c] 'Active parking' OR identifier CONTAINS[c] 'active'")
        ).firstMatch
        if opener.waitForExistence(timeout: 6) {
            opener.tap()
            sleep(2)
        }
        // Bring the meter card into view if the sheet scrolls.
        let timerLabel = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS[c] 'Parking Meter'")
        ).firstMatch
        if timerLabel.waitForExistence(timeout: 4) {
            timerLabel.swipeUp()
        }
        sleep(1)
        snapshot("03-meter-timer")
    }

    /// Frame 04 — History tab: past saved spots with addresses + nicknames.
    func testHistory() throws {
        let app = launchApp(args: ["--screenshots"])
        sleep(3)
        app.tabBars.buttons["History"].tap()
        sleep(2)
        snapshot("04-history")
    }

    /// Frame 05 — Settings tab: preferences + Pro row.
    func testSettings() throws {
        let app = launchApp(args: ["--screenshots"])
        sleep(3)
        app.tabBars.buttons["Settings"].tap()
        sleep(2)
        snapshot("05-settings")
    }

    /// Frame 06 — Pro upgrade paywall.
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
