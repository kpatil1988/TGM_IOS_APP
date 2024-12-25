import SwiftUI

struct SidebarMenu: View {
    @Binding var selectedView: MenuItem
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false // Persist theme preference
    var onItemSelected: (MenuItem) -> Void
    var toggleTheme: () -> Void

    var body: some View {
        List {
            ForEach(MenuItem.allCases, id: \.self) { item in
                Button(action: {
                    onItemSelected(item)
                }) {
                    Label(item.rawValue.capitalized, systemImage: systemImageName(for: item))
                }
            }
            
            // Add a toggle for dark mode within the list
            Toggle(isOn: $isDarkMode) {
                Label("Dark Mode", systemImage: "moon.stars.fill")
            }
            .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
        .listStyle(SidebarListStyle())
    }
    
    private func systemImageName(for item: MenuItem) -> String {
        switch item {
        case .home:
            return "house"
        case .moodCheckIn:
            return "smiley"
        case .dailyNurtures:
            return "star"
        case .insights:
            return "chart.bar"
        }
    }
}
