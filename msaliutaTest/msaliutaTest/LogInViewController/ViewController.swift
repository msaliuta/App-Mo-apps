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

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bgr")!)
        delegateTextField()
        // Do any additional setup after loading the view.
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
                        self?.performSegue(withIdentifier: "next", sender: nil)
                    }
                case .failure(let error):
                    print("error", error)
                    self?.errorLabel.alpha = 1
                    self?.errorLabel.text = "Не верный логин или пароль"
                }
            }
        }
    }
    
}

extension ViewController: UITextFieldDelegate {
    func delegateTextField() {
        loginTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next" {
            let nav = segue.destination as! UINavigationController
            let destinationVC = nav.topViewController as! AppListViewController
            destinationVC.userToken = tmpResponce;
        }
    }
}

