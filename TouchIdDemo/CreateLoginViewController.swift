//
//  CreateLoginViewController.swift
//  TouchIdDemo
//
//  Created by Kamal Ahuja on 7/22/16.
//  Copyright © 2016 KamalAhuja. All rights reserved.
//

import UIKit

class CreateLoginViewController: UIViewController {
    weak var delegate : CreateLoginViewProtocol?
    let keyChainWrapperLogin = KeychainWrapper();
    
    @IBOutlet weak var passwordTextFieldOutlet: UITextField!
    @IBOutlet weak var userNameTextFieldOutlet: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func createLogin(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setValue(userNameTextFieldOutlet.text, forKey: "username")
        keyChainWrapperLogin.mySetObject(passwordTextFieldOutlet.text, forKey: kSecValueData)
        keyChainWrapperLogin.writeToKeychain()
        NSUserDefaults.standardUserDefaults().synchronize()
        delegate?.dismissCreateLoginViewController()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
