//
//  ViewController.swift
//  BlueLogin
//
//  Created by Andres Guevara Caprio on 8/17/20.
//  Copyright © 2020 Andres Guevara Caprio. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    var user : User? = nil
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = nil
        // Do any additional setup after loading the view.
    }
    
    func isValidEmail() -> Bool{
        guard let email = emailField.text else {
            return false
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword() -> Bool {
        guard let password = passwordField.text else {
            return false
        }
        let passwordRegEx = "^.{6}$"
        
        let passwordPred = NSPredicate(format:"SELF MATCHES %@",passwordRegEx)
        return passwordPred.evaluate(with: password)
        
    }
    
    func displayInvalidEmailOrPassword(displayText: String = "Incorrect Email or Password"){
        let alert = UIAlertController(title: "Login Error", message:displayText, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    

    @IBAction func logInPressed(_ sender: Any) {
        
        loginButton.isEnabled = false
        
        defer {
            loginButton.isEnabled = true
        }
        
        // Check if user exists. If it does, reansition to Home controller
        if (!isValidEmail() || !isValidPassword()) {
            displayInvalidEmailOrPassword()
            return
        }
        
        guard let user = getUser(id: emailField.text!) else {
            // User doesn't exist. Show aler to sign up
            displayInvalidEmailOrPassword(displayText: "User not found. Verify email was entered correctly")
            return
        }

        if (!user.password!.elementsEqual(passwordField.text!)){
            displayInvalidEmailOrPassword()
            return
        }
        
        self.user = user
        
        // Move to HOME
        print("Move to HOME")
        performSegue(withIdentifier: "toHome", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let homeController = segue.destination as! HomeViewController
        homeController.user = self.user
        
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        let signUpAlert = UIAlertController(title: "Sign Up", message: "Are you sure you want to sign-up?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.signUpNewUser()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        signUpAlert.addAction(ok)
        signUpAlert.addAction(cancel)
        
        self.present(signUpAlert, animated: true, completion: nil)
        
    }
    
    func saveUser(){
        do {
            try context.save()
        } catch {
            print("Error saving: \(error)")
        }
        
    }
    
    func getUser(id: String) -> User?{
        var user : [User]
        
        let userFetchRequest : NSFetchRequest<User> = User.fetchRequest()
        userFetchRequest.predicate = NSPredicate(format: "email == %@", id)
        do {
            user = try context.fetch(userFetchRequest)
        } catch {
            print("Error loading items: \(error)")
            return nil
        }
        return user.count > 0 ? user.first : nil
    }
    
    func signUpNewUser(){
        UserManager.shared.getNewUser()
        { [weak self] results in
            switch results {
            case .success(let user):
                self?.createUser(userToCreate: user.first!)
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "toHome", sender: self)
                }
            case .failure(let error):
                print(error)
                fatalError()
            }
        }
    }
    
    func createUser(userToCreate : UserInfo) {
        let newUser = User(context: self.context)
        newUser.city = userToCreate.location.city
        newUser.country = userToCreate.location.country
        newUser.email = userToCreate.email
        newUser.first = userToCreate.name.first
        newUser.gender = userToCreate.gender
        newUser.last = userToCreate.name.last
        newUser.password = userToCreate.login.password
        newUser.phone = userToCreate.phone
        newUser.picture = userToCreate.picture.medium
//        newUser.post_code = userToCreate.location.postcode
        newUser.registered = userToCreate.registered.date
        newUser.state = userToCreate.location.state
        newUser.street = "\(userToCreate.location.street.number) \(userToCreate.location.street.name)"
        newUser.title = userToCreate.name.title
        self.user = newUser
        self.saveUser()
        
    }
    
    
}

extension UIImageView {
    func load(url: URL?) {
        DispatchQueue.global().async { [weak self] in
            guard let url = url else {
                self?.image = UIImage(systemName: "questionmark.square")
                return
            }
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
            }
            
    }
}

