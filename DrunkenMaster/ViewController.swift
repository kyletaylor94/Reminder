//
//  ViewController.swift
//  DrunkenMaster
//
//  Created by Turdesán Csaba on 2023. 02. 12..
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    let notifications = UNUserNotificationCenter.current()

    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notifications.requestAuthorization(options: [.alert, .sound]) { (permissionGranted, error) in
            if (!permissionGranted){
                print("Permission Denied")
            }
        }
    }

    @IBAction func buttonAction(_ sender: Any) {
        notifications.getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                let title = self.titleTextField.text!
                let message = self.messageTextField.text!
                let date = self.datePicker.date
                
                if (settings.authorizationStatus == .authorized){
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = message
                    
                    let dateComp = Calendar.current.dateComponents([.year, .month, .month , .day, .hour, .minute], from: date)
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    self.notifications.add(request) { (error) in
                        if (error != nil){
                            print("error" + error.debugDescription)
                            return
                        }
                    }
                    let ac = UIAlertController(title: "Enable notifications", message: "To use this feature u must enable notifications in settings", preferredStyle: .alert)
                    
                    let goToSettings = UIAlertAction(title: "Settings", style: .default)
                    { (_)in
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString)
                        else{
                            return
                        }
                        if (UIApplication.shared.canOpenURL(settingsURL)){
                            UIApplication.shared.open(settingsURL) { (_) in}
                                
                            }
                        }
                    ac.addAction(goToSettings)
                    ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in}))
                    self.present(ac, animated: true)
                }
            }
        }
            }
       
    
    
}


func formattedDate(date: Date) -> String{
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM y HH:mm"
    return formatter.string(from: date)
}


