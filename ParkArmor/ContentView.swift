import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "app.fill")
                .font(.system(size: 60))
                .foregroundStyle(.tint)
            Text("ParkArmor: Save Your Spot")
                .font(.title2.bold())
            Text("Coming soon from Katafract.")
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
