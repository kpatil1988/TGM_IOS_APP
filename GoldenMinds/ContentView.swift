import SwiftUI

struct ContentView: View {
    @State private var isSidebarVisible = false
    @StateObject private var moodCheckinViewModel = MoodCheckinViewModel()

    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    // Header with Hamburger icon for Sidebar
                    HStack {
                        Button(action: {
                            withAnimation {
                                isSidebarVisible.toggle() // Toggle sidebar visibility
                            }
                        }) {
                            Image(systemName: "line.horizontal.3") // Hamburger icon
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                        .padding()

                        Spacer()
                        Text("GoldenMinds")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    
                    // Main Content with Bottom Tabs
                    TabView {
                        HomeView()
                            .tabItem {
                                Label("Home", systemImage: "house")
                            }

                        MoodCheckinView(viewModel: moodCheckinViewModel)
                            .tabItem {
                                Label("Mood", systemImage: "smiley")
                            }

                        DailyNurturesView()
                            .tabItem {
                                Label("Nurtures", systemImage: "star")
                            }

                        InsightsView()
                            .tabItem {
                                Label("Insights", systemImage: "chart.bar")
                            }
                    }
                }
            }
            .disabled(isSidebarVisible) // Disable main content interaction if sidebar is open

            // Sidebar Overlay
            if isSidebarVisible {
                // Dark overlay to indicate inactive background
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isSidebarVisible.toggle() // Close sidebar when tapping outside
                        }
                    }
                
                // Sidebar View
                
            }
        }
    }
}


