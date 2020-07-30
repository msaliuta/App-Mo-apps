//
//  ViewController.swift
//  msaliutaTest
//
//  Created by Maksym Saliuta on 29.07.2020.
//  Copyright © 2020 Maksym Saliuta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let apiCaller = Api()
    var apiResponce: ApiResponce? = nil
    var tmpResponce: String = ""

    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bgr")!)
        delegateTextField()
        setUpKeyBoard()
    }
    
    func setUpKeyBoard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func logInButton(_ sender: Any) {
        if loginTextField.text == "" && passwordTextField.text == "" {
            errorLabel.alpha = 1
            errorLabel.text = "Заполните все поля"
        } else {
            let urlString = "https://html5.mo-apps.com/api/Account/Login"
            let parameters =  ["userNick" : loginTextField.text!, "password": passwordTextField.text!]
            self.apiCaller.autorizationRequest(urlString: urlString, parameters: parameters) { [weak self] (result) in
                switch result {
                case.success(let autorizationResponse):
                    self?.apiResponce = autorizationResponse
                    print(autorizationResponse.data)
                    DispatchQueue.main.async {
                        self?.tmpResponce = String(autorizationResponse.data)
                        self?.performSegue(withIdentifier: "toAppListViewController", sender: nil)
                    }
                case .failure(let error):
                    print("error", error)
                    self?.errorLabel.alpha = 1
                    self?.errorLabel.text = "Не верный логин или пароль"
                }
            }
        }
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                                       delay: TimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }
    
}

extension ViewController: UITextFieldDelegate {
    func delegateTextField() {
        loginTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAppListViewController" {
            let nav = segue.destination as! UINavigationController
            let destinationVC = nav.topViewController as! AppListViewController
            destinationVC.userToken = tmpResponce;
        }
    }
}

