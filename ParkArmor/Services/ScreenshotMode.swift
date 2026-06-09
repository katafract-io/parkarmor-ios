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


/// Deep-link route for DETERMINISTIC screenshot capture — shows a real app view
/// directly (no fragile UI tapping). Selected via `--screenshot-route <raw>`.
enum ScreenshotRoute: String {
    case map, history, parked, active
}

extension ScreenshotMode {
    static var route: ScreenshotRoute? {
        guard isEnabled,
              let i = CommandLine.arguments.firstIndex(of: "--screenshot-route"),
              i + 1 < CommandLine.arguments.count else { return nil }
        return ScreenshotRoute(rawValue: CommandLine.arguments[i + 1])
    }
}
