import Foundation
import CoreLocation

struct ScreenshotMode {
    // Accept both conventions: `--screenshots` (fleet-wide standard) and
    // the legacy `-ScreenshotMode` single-dash form.
    static let isEnabled = CommandLine.arguments.contains("--screenshots")
                        || CommandLine.arguments.contains("-ScreenshotMode")

    // When active, bypass onboarding so the main app is always visible.
    static var skipOnboarding: Bool { isEnabled }

    static func seedDataIfEnabled() {
        guard isEnabled else { return }
        // TODO: Wire to real ParkingRepository via ModelContext injection.
    }
}
