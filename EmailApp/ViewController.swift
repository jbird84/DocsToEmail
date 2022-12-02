//
//  ViewController.swift
//  EmailApp
//
//  Created by Kinney Kare on 12/2/22.
//

import UIKit
import MessageUI

class ViewController: UIViewController {
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var reasonTitleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    let placeholderText = "Use this textfield to add any more details about this event."
    let start = NSRange(location: 0, length: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.text = placeholderText
        textView.textColor = .placeholderText
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SEND", style: .done, target: self, action: #selector(sendTapped))
    }
    
    @objc func sendTapped() {
        if let dateText = dateTextField.text, !dateText.isEmpty {
            if let titleText = reasonTitleTextField.text, !titleText.isEmpty {
                if let bodytext = textView.text, bodytext != placeholderText {
                    //good
                    print("YES we did it!!!")
                    sendEmail(date: dateText, title: titleText, body: bodytext)
                    dateTextField.text = nil
                    reasonTitleTextField.text = nil
                    textView.text = placeholderText
                } else {
                    displayAlert(with: "Please enter more details about this event.")
                }
            } else {
                displayAlert(with: "Please enter a title for this event.")
            }
            
        } else {
            displayAlert(with: "Please enter a valid date.")
        }
    }
        
    private func displayAlert(with text: String) {
        let dialogMessage = UIAlertController(title: "OK", message: text, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
        })
        
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}

extension ViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        // Moves cursor to start when tapped on textView with placeholder
        if textView.text == placeholderText {
            textView.selectedRange = start
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // Manages state of text when changed
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .placeholderText
        } else if textView.text != placeholderText {
            textView.textColor = .label
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Called when you're trying to enter a character (to replace the placeholder)
        if textView.text == placeholderText {
            textView.text = ""
        }
        return true
    }
}

extension ViewController: MFMailComposeViewControllerDelegate {
    func sendEmail(date: String, title: String, body: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setPreferredSendingEmailAddress("kinneykare4@gmail.com")
            mail.setToRecipients(["forthekiddos1718@gmail.com"])
            mail.setSubject("REBA DOCS")   //("Docs About Reba")
            mail.setCcRecipients(["joshkinney2010@yahoo.com", "caseygarus@gmial.com"])
            mail.setMessageBody("<p> Date: \(date)</p> <br /> <p> \(title)</p> <br /> <p> Body: \(body)</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            //TODO: show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
