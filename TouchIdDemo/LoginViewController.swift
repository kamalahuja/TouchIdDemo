//
//  LoginViewController.swift
//  TouchIdDemo
//
//  Created by Kamal Ahuja on 7/21/16.
//  Copyright © 2016 KamalAhuja. All rights reserved.
//

import UIKit
import LocalAuthentication

protocol CreateLoginViewProtocol : class {
    func dismissCreateLoginViewController();
}
class LoginViewController: UIViewController,CreateLoginViewProtocol {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var touhIdButton: UIButton!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var createLoginScreen: UIButton!
    var localAuthCOntext : LAContext = LAContext()
    
    let keyChainWrapperLogin = KeychainWrapper();
    @IBOutlet weak var createLoginButton: UIButton!
    
    func dismissCreateLoginViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
           touhIdButton.hidden = true
        if localAuthCOntext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: nil) {
            touhIdButton.hidden = false
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func touchIdLoginAction(sender: AnyObject) {
        guard localAuthCOntext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: nil) else {
            let noTouchIdAvailableAlert = UIAlertController(title: "No ToucH Id", message: "Touch Id is not available on this device", preferredStyle: .Alert);
            let okAction = UIAlertAction(title: "Return to Login!!", style: UIAlertActionStyle.Default, handler: nil)
            noTouchIdAvailableAlert.addAction(okAction)
            self.presentViewController(noTouchIdAvailableAlert, animated: true, completion: nil)
            return
        }
        
        localAuthCOntext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Please rest your fingers on home button", reply: {
            (success : Bool, error : NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    let alertVIew = UIAlertController(title: "Login Success", message: "Congratulation!! Your login is sucess", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                    alertVIew.addAction(okAction)
                    self.presentViewController(alertVIew, animated: false, completion: nil)
                } else {
                    if error != nil {
                        var message : NSString = ""
                        var showAlert : Bool = false
                        
                        switch error!.code {
                        case LAError.AuthenticationFailed.rawValue :
                            message = "There was a problem verifying your identity."
                            showAlert = true
                            break;
                        case LAError.UserCancel.rawValue :
                            message = "User has pressed cancel"
                            showAlert = true
                            break;
                        case LAError.UserFallback.rawValue :
                            message = "User pressed Password"
                            showAlert = true
                            break
                        default:
                            message = "default message"
                            showAlert = true
                            break
                        }
                        
                        if showAlert {
                            let alertVIew = UIAlertController(title: "Touch Id Error", message: message as String, preferredStyle: UIAlertControllerStyle.Alert)
                            let okAction = UIAlertAction(title: "Please try again", style: .Default, handler: nil)
                            alertVIew.addAction(okAction)
                            self.presentViewController(alertVIew, animated: false, completion: nil)
                        }
                        
                        
                    }
                }
            })
        })
    }
    @IBAction func submitCreateLoginAction(sender: AnyObject) {
        let createLoginVIewCOntroller : CreateLoginViewController = CreateLoginViewController();
        
        let createLoginNavCOntroller : UINavigationController = UINavigationController.init(rootViewController: createLoginVIewCOntroller)
        createLoginVIewCOntroller.delegate = self
        self.presentViewController(createLoginNavCOntroller, animated: true, completion: nil)
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let storedUserName = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String {
            userNameTextField.text = storedUserName
            createLoginButton.hidden = true
            loginButtonOutlet.hidden = false
         
        } else {
            createLoginButton.hidden = false
            loginButtonOutlet.hidden = true
         
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitYourCredentials(sender: AnyObject) {
        guard userNameTextField.text != nil && passwordTextField.text != nil &&
        self.checkLogin(userNameTextField.text!, password: passwordTextField.text!) else {
            let loginFailedAlertView = UIAlertController(title: "login Problem", message: "Wrong username or password", preferredStyle: .Alert);
            let okAction = UIAlertAction(title: "Return to Login!!", style: UIAlertActionStyle.Default, handler: nil)
            loginFailedAlertView.addAction(okAction)
            self.presentViewController(loginFailedAlertView, animated: true, completion: nil)
            return
        }
        
        let alertVIew = UIAlertController(title: "Login Success", message: "Congratulation!! Your login is sucess", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertVIew.addAction(okAction)
        self.presentViewController(alertVIew, animated: false, completion: nil)
    }

    
    func checkLogin(username: String, password : String) -> Bool {
        guard password == keyChainWrapperLogin.myObjectForKey("v_Data") as? String && username == NSUserDefaults.standardUserDefaults().objectForKey("username") as? String else {
            return false
        }
        return true
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
