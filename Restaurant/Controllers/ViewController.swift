//
//  ViewController.swift
//  Restaurant
//
//  Created by rps on 14/06/22.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }

    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    @IBAction func UserDonePressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func passwordDonePressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func onSignInPressed(_ sender: Any) {
        if let safeUser = usernameTextField.text, let safePassword = passwordTextField.text{
            if(safeUser == "admin" && safePassword == "admin"){
                let resturantViewController = storyboard?.instantiateViewController(withIdentifier: "restaurantcontroller") as! UIViewController
                self.navigationController?.setViewControllers([resturantViewController], animated: true)
            }
            else{
                let alert = UIAlertController(title: "Oops", message: "Please enter valid credentials", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
}

