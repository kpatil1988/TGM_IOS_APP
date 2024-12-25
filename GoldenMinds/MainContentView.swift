import SwiftUI


struct MainContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State private var isUserLoggedIn = false
    @State private var showSignIn = false
    @State private var showSignUp = false
    @State private var selectedView: MenuItem = .home
    @State private var isSidebarVisible = false
    @StateObject private var moodCheckinViewModel = MoodCheckinViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            isSidebarVisible.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()

                    Text("GoldenMinds")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()

                    Menu {
                        if isUserLoggedIn {
                            Button(action: { /* Profile action */ }) {
                                Label("Profile", systemImage: "person.fill")
                            }
                            Button(action: { signOut() }) {
                                Label("Sign Out", systemImage: "arrow.right.circle.fill")
                            }
                        } else {
                            Button(action: {
                                showSignIn = true
                            }) {
                                Label("Sign In", systemImage: "arrow.forward.circle.fill")
                            }
                            Button(action: {
                                showSignUp = true
                            }) {
                                Label("Sign Up", systemImage: "person.badge.plus")
                            }
                        }
                    } label: {
                        Image(systemName: "person.circle")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                    .sheet(isPresented: $showSignIn) {
                        SignInView()
                    }
                    .sheet(isPresented: $showSignUp) {
                        SignUpView()
                    }
                }
                .padding()
                .background(Color(UIColor.systemGray6))

                ZStack(alignment: .leading) {
                    TabView(selection: $selectedView) {
                        HomeView()
                            .tag(MenuItem.home)
                            .tabItem {
                                Label("Home", systemImage: "house")
                            }
                        
                        MoodCheckinView(viewModel: moodCheckinViewModel)
                            .tag(MenuItem.moodCheckIn)
                            .tabItem {
                                Label("Mood", systemImage: "smiley")
                            }
                        
                        DailyNurturesView()
                            .tag(MenuItem.dailyNurtures)
                            .tabItem {
                                Label("Nurtures", systemImage: "star")
                            }
                        
                        InsightsView()
                            .tag(MenuItem.insights)
                            .tabItem {
                                Label("Insights", systemImage: "chart.bar")
                            }
                    }
                    .disabled(isSidebarVisible)
                    
                    if isSidebarVisible {
                        SidebarMenu(
                            selectedView: $selectedView,
                            onItemSelected: { item in
                                selectedView = item
                                withAnimation {
                                    isSidebarVisible = false
                                }
                            },
                            toggleTheme: {
                                isDarkMode.toggle()
                            }
                        )
                        .frame(width: 250)
                        .background(Color(UIColor.systemGray5))
                        .transition(.move(edge: .leading))
                        .zIndex(1)
                    }
                }
                .background(
                    Group {
                        if isSidebarVisible {
                            Color.black.opacity(0.3)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    withAnimation {
                                        isSidebarVisible = false
                                    }
                                }
                        }
                    }
                )
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    
    private func signOut() {
        isUserLoggedIn = false
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
    }
}
