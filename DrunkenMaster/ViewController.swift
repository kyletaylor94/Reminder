//
//  ViewController.swift
//  DrunkenMaster
//
//  Created by Turdesán Csaba on 2023. 02. 12..
//

import UIKit
import UserNotifications

class ViewController: UIViewController,UNUserNotificationCenterDelegate {
    
    let notifications = UNUserNotificationCenter.current()

    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var okButtonLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        okButtonLabel.isHidden = true
        // Do any additional setup after loading the view.
        notifications.requestAuthorization(options: [.alert, .sound]) { (permissionGranted, error) in
            if (!permissionGranted){
                print("Permission Denied")
            }
        }
        notifications.delegate = self
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        first()
        second()
    }
    
    
    
    func formattedDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y HH:mm"
        return formatter.string(from: date)
    }
    
    
    func first() {
        let notifications = UNUserNotificationCenter.current()
        
        notifications.getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                
                let title = self.titleTextField.text!
                let message = self.messageTextField.text!
                let date = self.datePicker.date
                
                if (settings.authorizationStatus == .authorized){
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = message
                    content.sound = UNNotificationSound.default
                    
                    let dateComp = Calendar.current.dateComponents([.year, .month, .month , .day, .hour, .minute], from: date)
                    
                    var trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: true)
                    
                    var request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    self.notifications.add(request) { (error) in
                        if (error != nil){
                            print("error" + error.debugDescription)
                            self.okButtonLabel.isHidden = false
                            return
                        }
                    }
                    self.okButtonLabel.isHidden = false
                    
                }
            }
        }
    }
    
    func second() {
        let notifications = UNUserNotificationCenter.current()
        
        notifications.getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                let title = self.titleTextField.text!
                let message = self.messageTextField.text!
                let date = self.datePicker.date
                
                if (settings.authorizationStatus == .authorized){
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = message
                    content.sound = UNNotificationSound.default
                    
                    let dateComp = Calendar.current.dateComponents([.year, .month, .month , .day, .hour, .minute], from: date)
                    
                    var trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
                    
                    var request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    self.notifications.add(request) { (error) in
                        if (error != nil){
                            print("error" + error.debugDescription)
                            return
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func stopButton(_ sender: UIButton) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        self.notifications.removeAllPendingNotificationRequests()
        self.okButtonLabel.text = "Stopped"

    }
    
    
}
