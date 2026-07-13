// Heer Soni - heersoni@iu.edu
// Carley Rodenbush - cjrodenb@iu.edu
// MoodTrackerApp
// 5 May, 2026

import Foundation
import UserNotifications
import Combine
import UIKit

final class NotificationManager: ObservableObject {
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            print("Permission granted: \(granted)")
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            }

            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func scheduleDailyReminder(hour: Int = 12, minute: Int = 15) {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let content = UNMutableNotificationContent()
        content.title = "Mood Check-In"
        content.body = "How are you feeling today? Log your mood in the app."
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )
        
        let request = UNNotificationRequest(
            identifier: "daily_mood_reminder",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule daily reminder: \(error.localizedDescription)")
            } else {
                print("Daily reminder scheduled")
            }
        }
    }

    func openNotificationSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
