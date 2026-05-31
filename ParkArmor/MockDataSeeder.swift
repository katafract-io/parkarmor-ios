import Foundation
import MapKit
import SwiftData
import UIKit

/// Injects mock parking sessions into SwiftData for screenshot captures.
/// Called from AppViewModel.configure() when ScreenshotMode.isEnabled.
/// The app uses an in-memory container in screenshot mode, so data is always fresh.
struct MockDataSeeder {
    static func seedDataIfNeeded(into context: ModelContext) {
        guard ScreenshotMode.isEnabled else { return }

        // Active session — the hero. A fully-saved spot: named location,
        // a photo of the parking sign, a "where exactly" note, a live meter
        // countdown, and (via the seeded compass) a walk-back distance.
        let active = ParkingLocation(
            latitude: 37.7956,
            longitude: -122.3933,
            address: "Embarcadero Center Garage, San Francisco, CA",
            notes: "Level 3, Row B • near the blue elevator",
            isActive: true
        )
        active.nickname = "My Car"
        active.savedAt = Date(timeIntervalSinceNow: -47 * 60)
        active.isFavorite = true
        context.insert(active)

        // Photo of the parking sign — generated in-code so no binary asset
        // (and no project.pbxproj asset wiring) is required for the hero frame.
        let signPhoto = ParkingPhoto(
            imageData: parkingSignImageData(),
            caption: "Level 3, Row B"
        )
        signPhoto.location = active
        active.photos = [signPhoto]
        context.insert(signPhoto)

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

    /// Renders a realistic "PERMIT PARKING" style street-sign image so the
    /// hero detail frame shows a photo of the sign the driver snapped. Drawn
    /// in-code (no asset catalog dependency) and high-contrast for ASO.
    private static func parkingSignImageData() -> Data {
        let size = CGSize(width: 600, height: 600)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            let cg = ctx.cgContext

            // Asphalt-ish background so the white sign pops.
            cg.setFillColor(UIColor(red: 0.16, green: 0.18, blue: 0.21, alpha: 1).cgColor)
            cg.fill(CGRect(origin: .zero, size: size))

            // Sign panel.
            let panel = CGRect(x: 90, y: 70, width: 420, height: 460)
            let panelPath = UIBezierPath(roundedRect: panel, cornerRadius: 14)
            UIColor.white.setFill()
            panelPath.fill()
            UIColor(red: 0.0, green: 0.32, blue: 0.62, alpha: 1).setStroke()
            panelPath.lineWidth = 10
            panelPath.stroke()

            let blue = UIColor(red: 0.0, green: 0.32, blue: 0.62, alpha: 1)

            func draw(_ text: String, _ rect: CGRect, size fontSize: CGFloat, color: UIColor, weight: UIFont.Weight) {
                let p = NSMutableParagraphStyle(); p.alignment = .center
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: fontSize, weight: weight),
                    .foregroundColor: color,
                    .paragraphStyle: p,
                ]
                (text as NSString).draw(in: rect, withAttributes: attrs)
            }

            // Blue header bar.
            let header = CGRect(x: 90, y: 70, width: 420, height: 96)
            cg.setFillColor(blue.cgColor)
            cg.fill(header)
            draw("LEVEL 3", CGRect(x: 90, y: 92, width: 420, height: 60), size: 54, color: .white, weight: .heavy)

            draw("ROW B", CGRect(x: 90, y: 196, width: 420, height: 80), size: 88, color: blue, weight: .black)
            draw("PARKING", CGRect(x: 90, y: 300, width: 420, height: 44), size: 36, color: .darkGray, weight: .semibold)
            draw("2 HR MAX", CGRect(x: 90, y: 360, width: 420, height: 50), size: 40, color: .black, weight: .bold)
            draw("8AM – 6PM MON–SAT", CGRect(x: 90, y: 432, width: 420, height: 34), size: 26, color: .darkGray, weight: .medium)
        }
        return image.pngData() ?? Data()
    }
}
