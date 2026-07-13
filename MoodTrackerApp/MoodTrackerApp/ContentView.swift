// Heer Soni - heersoni@iu.edu
// Carley Rodenbush - cjrodenb@iu.edu
// MoodTrackerApp
// 5 May, 2026

import SwiftUI

struct ContentView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var historyViewModel = HistoryViewModel()
    @StateObject private var chartsViewModel = ChartsViewModel()
    @StateObject private var notificationManager = NotificationManager()

    var body: some View {
        TabView {
            HomeView(
                viewModel: homeViewModel,
                notificationManager: notificationManager
            )
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }

            HistoryView(viewModel: historyViewModel)
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("History")
                }

            ChartsView(viewModel: chartsViewModel)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Charts")
                }
        }
        .tint(Color(red: 0.23, green: 0.22, blue: 0.72))
        .onAppear {
            notificationManager.requestPermission { granted in
                if granted {
                    notificationManager.scheduleDailyReminder()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
