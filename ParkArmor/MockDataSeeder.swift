import Foundation
import MapKit
import SwiftData

/// Injects mock parking sessions into SwiftData for screenshot captures.
/// Called from AppViewModel.configure() when ScreenshotMode.isEnabled.
/// The app uses an in-memory container in screenshot mode, so data is always fresh.
struct MockDataSeeder {
    static func seedDataIfNeeded(into context: ModelContext) {
        guard ScreenshotMode.isEnabled else { return }

        // Active session — 47 minutes in, timer running, nickname set
        let active = ParkingLocation(
            latitude: 37.7956,
            longitude: -122.3933,
            address: "Ferry Building Marketplace, San Francisco, CA",
            notes: "Level 2 • Spot B-42 (near elevator)",
            isActive: true
        )
        active.nickname = "Work Parking"
        active.savedAt = Date(timeIntervalSinceNow: -47 * 60)
        active.isFavorite = true
        context.insert(active)

        let timer = ParkingTimer(
            expiresAt: Date(timeIntervalSinceNow: 13 * 60),
            notificationIdentifier: "screenshot-timer-mock",
            label: "Parking Meter"
        )
        timer.location = active
        active.timer = timer
        context.insert(timer)

        // History entry 1 — yesterday, downtown SF
        let hist1 = ParkingLocation(
            latitude: 37.7793,
            longitude: -122.4193,
            address: "Civic Center Plaza, San Francisco, CA",
            isActive: false
        )
        hist1.savedAt = Date(timeIntervalSinceNow: -86_400)
        context.insert(hist1)

        // History entry 2 — 3 days ago, Oakland, nickname set
        let hist2 = ParkingLocation(
            latitude: 37.8044,
            longitude: -122.2711,
            address: "College Ave & Broadway, Oakland, CA",
            notes: "Street parking",
            isActive: false
        )
        hist2.nickname = "Doctor Appt"
        hist2.savedAt = Date(timeIntervalSinceNow: -3 * 86_400)
        context.insert(hist2)

        // History entry 3 — last week, SFO
        let hist3 = ParkingLocation(
            latitude: 37.6213,
            longitude: -122.3790,
            address: "SFO Garage D, San Francisco International Airport",
            isActive: false
        )
        hist3.savedAt = Date(timeIntervalSinceNow: -7 * 86_400)
        context.insert(hist3)

        try? context.save()
    }
}
