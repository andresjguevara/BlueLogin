//
//  HomeViewController.swift
//  BlueLogin
//
//  Created by Andres Guevara Caprio on 8/18/20.
//  Copyright © 2020 Andres Guevara Caprio. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    var user : User? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.firstName.text = self.user!.first!
        self.profilePic.load(url: URL(string: (self.user!.picture)!))
        self.lastName.text = self.user!.last
        self.address.text = String("\(self.user!.street!),\n \(self.user!.city!), \(self.user!.state!), \(self.user!.country!)")
        self.phone.text = self.user?.phone

    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    
}
