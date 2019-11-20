//
//  PrayerNotificationController.swift
//  PrayerNotification
//
//  Created by ahmad shiddiq on 20/11/19.
//  Copyright © 2019 ahmad shiddiq. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class PrayerNotificationController: UIViewController, UNUserNotificationCenterDelegate{
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelKeteranganTime: UILabel!
    @IBOutlet weak var labelTimeNotification: UILabel!
    
    var isGrandtedAccess = false
    private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: .alert, completionHandler: {
            (granted, error) in
            self.isGrandtedAccess = granted
        })
        let stopAction = UNNotificationAction(identifier: "Stop.Action", title: "Stop", options: [])
        let timerCategory = UNNotificationCategory(identifier: "timer.category", actions: [stopAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([timerCategory])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if  response.actionIdentifier == "Stop.Action"{
            stopTimer()
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    @IBAction func pressStart(_ sender: Any) {
        startTime()
    }
    
    @IBAction func pressStop(_ sender: Any) {
        stopTimer()
    }

    
    func startTime(){
        let timeInterval = 5.0
        if isGrandtedAccess && !timer.isValid{
            timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: {
                (timer) in
                self.sendNotification()
            })
        }
    }
    
    func stopTimer(){
        timer.invalidate()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func sendNotification(){
        if isGrandtedAccess{
            let content = UNMutableNotificationContent()
            content.title = "HIIT Timer"
            content.body = "30 Seconds Elapsed"
            content.sound = UNNotificationSound.default
            content.categoryIdentifier = "timer.category"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.001, repeats: false)
            let request = UNNotificationRequest(identifier: "timer.request", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: {
                (error) in
                if let error = error {
                    print("Error posting notification : \(error.localizedDescription)")
                }
            })
        }
    }
}
