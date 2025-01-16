//
//  WhistleService.swift
//  Turkiye Deprem
//
//  Created by Ahmet OZBERK on 16.01.2025.
//

import AVFoundation
import Foundation
import UIKit
import UserNotifications

class WhistleService: NSObject {
    static let shared = WhistleService()

    private var audioPlayer: AVAudioPlayer?
    private var isPlaying: Bool = false

    private let notificationCategoryId = "whistle_notification_category"

    override init() {
        super.init()
        setupNotifications()
    }

    private func setupNotifications() {
        let stopAction = UNNotificationAction(
            identifier: "STOP_WHISTLE",
            title: "Durdur",
            options: .foreground
        )

        let category = UNNotificationCategory(
            identifier: notificationCategoryId,
            actions: [stopAction],
            intentIdentifiers: [],
            options: []
        )

        UNUserNotificationCenter.current().setNotificationCategories([category])
        UNUserNotificationCenter.current().delegate = self
    }

    func startWhistle() {
        if let soundPath = Bundle.main.path(
            forResource: "sos_sound", ofType: "mp3")
        {
            let soundURL = URL(fileURLWithPath: soundPath)

            do {
                try AVAudioSession.sharedInstance().setCategory(
                    .playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)

                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.numberOfLoops = -1  // Sonsuz döngü
                audioPlayer?.prepareToPlay()  // Eklendi - sesi önceden hazırla
                audioPlayer?.play()
                isPlaying = true

                showNotification()

            } catch {
                print("Ses çalma hatası: \(error.localizedDescription)")
            }
        } else {
            print("Ses dosyası bulunamadı: 'sos_sound.mp3'")
            print("Mevcut bundle içeriği:")
            if let resources = Bundle.main.urls(
                forResourcesWithExtension: "mp3", subdirectory: nil)
            {
                resources.forEach { print($0) }
            }
        }
    }

    func stopWhistle() {
        audioPlayer?.stop()
        isPlaying = false

        UNUserNotificationCenter.current()
            .removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

    private func showNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Deprem Alarmı"
        content.body = "Düdük sesi çalıyor..."
        content.sound = nil  // Kendi ses dosyamızı kullandığımız için bildirim sesi kapalı
        content.categoryIdentifier = notificationCategoryId

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim hatası: \(error.localizedDescription)")
            }
        }
    }
}

extension WhistleService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        if response.actionIdentifier == "STOP_WHISTLE" {
            stopWhistle()
        }
        completionHandler()
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (
            UNNotificationPresentationOptions
        ) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
}
