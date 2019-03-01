//
//  LoginViewController.swift
//  CustomerApp
//
//  Created by Essensys-09 on 22/12/17.
//  Copyright © 2017 Essensys-09. All rights reserved.
//

import UIKit
import Alamofire
import GoogleSignIn
import Google
import FBSDKLoginKit

protocol LoginViewControllerDelegate {
    func myVCDidFinishLogin(_ controller: LoginViewController, Id:String)
}
class LoginViewController: UIViewController,GIDSignInUIDelegate, GIDSignInDelegate, UITextFieldDelegate {
    
    var delegate: LoginViewControllerDelegate?
    @IBOutlet weak var viewTop: UIView!
    
    @IBOutlet weak var viewForHide: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblSlider: UILabel!
    
    @IBOutlet weak var viewSignIn: UIView!
    @IBOutlet weak var txtPassword: ACFloatingTextField!
    
    @IBOutlet weak var txtUserName: ACFloatingTextField!
    
    @IBOutlet weak var btnForgotPass: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var viewSocial: UIView!
    
    @IBOutlet weak var btnFacebook: FBSDKLoginButton!
    @IBOutlet weak var btnGoogle: GIDSignInButton!
    
    @IBOutlet weak var btnFacebookSignUp: FBSDKLoginButton!
    
    @IBOutlet weak var btnGoogleSignUp: GIDSignInButton!
    
    @IBOutlet weak var viewSignUp: UIView!
//    @IBOutlet weak var txtUserNameSignU: ACFloatingTextField!
    @IBOutlet weak var txtEmailIDSignUp: ACFloatingTextField!
    @IBOutlet weak var txtMobileSignUp: ACFloatingTextField!
    @IBOutlet weak var txtPasswordSignUp: ACFloatingTextField!
    @IBOutlet weak var txtConfirmPassSignUp: ACFloatingTextField!
    @IBOutlet weak var btnRegister: UIButton!
    
    @IBOutlet weak var viewForgotPass: UIView!
    @IBOutlet weak var viewTopForgotPass: UIView!
    @IBOutlet weak var btnForgotPassTop: UIButton!
    @IBOutlet weak var txtEmailForgotPass: UITextField!
    @IBOutlet weak var btnSendForgotPass: UIButton!
    
    @IBOutlet weak var viewtopReset: UIView!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var viewResetPassword: UIView!
    @IBOutlet weak var txtNewPassReset: UITextField!
    @IBOutlet weak var txtRePassReset: UITextField!
    
    @IBOutlet weak var btnSendReset: UIButton!
    
    var tapGesture = UITapGestureRecognizer()
    var tapGestureView = UITapGestureRecognizer()
    
    var isFromHome : Bool = true
    var isFromChangePass : Bool = false
    
    var outhID:String = ""
    var outhProvider:String = ""
    var outhEmail:String = ""
    var outhName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Init()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
//        hideKeyboardWhenTappedAround()
    }
    
    func Init()
    {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self

        btnSignIn.layer.cornerRadius = btnSignIn.frame.size.height/2
        btnRegister.layer.cornerRadius = btnSignUp.frame.size.height/2
        btnSendForgotPass.layer.cornerRadius = btnSendForgotPass.frame.size.height/2
        btnSendReset.layer.cornerRadius = btnSendReset.frame.size.height/2
        
        txtNewPassReset.attributedPlaceholder = NSAttributedString(string: "Enter new password",
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        txtRePassReset.attributedPlaceholder = NSAttributedString(string: "Re-enter password", attributes: [NSAttributedStringKey.foregroundColor:UIColor.white])

        
        // TAP Gesture
        tapGestureView = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.myviewTapped(_:)))
        tapGestureView.numberOfTapsRequired = 1
        tapGestureView.numberOfTouchesRequired = 1
        self.viewForHide.addGestureRecognizer(tapGestureView)
        self.viewForHide.isUserInteractionEnabled = true
    }
    
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        // handling code
        
        if isFromHome == true {
            self.view.removeFromSuperview()
        } else {
            viewTopForgotPass.isHidden = true
            viewForgotPass.isHidden = true
            viewTop.isHidden = false
            viewSignIn.isHidden = false
            viewSignUp.isHidden = true
            viewtopReset.isHidden = true
            viewResetPassword.isHidden = true
            
            if isFromChangePass != true {
                isFromHome = true
            } else {
                isFromChangePass = false
            }
        }
    }
    
    @IBAction func btnSignInClk(_ sender: Any) {
        Validation()
    }
    
    func Validation()
    {
        let testStr:String = txtUserName.text!
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let isValid:Bool = emailTest.evaluate(with: testStr)
        
        if !isValid {
            txtUserName.errorText = "Email Id"
            txtUserName.showError()
            txtUserName.showError(withText: "Enter Email ID")
            
            txtUserName.errorTextColor = UIColor.red
        }
        else if txtPassword.text == "" || txtPassword.text!.count < 6 {
            txtPassword.errorText = "Password"
            txtPassword.showError()
            txtPassword.showError(withText: "Enter Password")
            
            txtPassword.errorTextColor = UIColor.red
        } else {
            if currentReachabilityStatus != .notReachable
            {
                Login()
            } else {
                self.alert()
            }
        }
    }
    
    func Login()
    {
        showHud("Loading")
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        let param : [String:String] = ["username": txtUserName.text!,
                                       "password": txtPassword.text!
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in param {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to:"http://54.255.247.3/selfserve/webapp/customer-app/ws-login/ws-login.php")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.request!)  // original URL request
                    print(response.response!) // URL response
                    print(response.data!)     // server data
                    print(response.result)   // result of response serialization
                    //                        self.showSuccesAlert()
                    //                    //self.removeImage("frame", fileExtension: "txt")
                    //                    if let JSON = response.result.value {
                    //                        print("JSON: \(JSON)")
                    //
                    //                        self.actInd.stopAnimating()
                    
                    
                    if response.result.isSuccess
                    {
                        if let resJson = response.result.value as? NSDictionary
                        {
                            if let resultJson = resJson.value(forKey: "result") as? NSDictionary
                            {
                                if let responseCode = resultJson.value(forKey: "msg") as? String
                                {
                                    if responseCode == "0"
                                    {
                                        let message :String = resultJson.value(forKey: "msg_string") as! String
                                        let alert = UIAlertController(title: nil, message: "\(message)", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                                            self.hideHUD()
                                        }))
                                        self.present(alert, animated: true, completion: nil)

                                    }
                                    else if responseCode == "1"
                                    {
                                        let customerID :String = resultJson.value(forKey: "customer_id") as! String
                                        let UserName :String = resultJson.value(forKey: "user_email") as! String
                                        let CustomerDOB :String = resultJson.value(forKey: "customer_dob") as! String
                                        let CustomerAdress :String = resultJson.value(forKey: "customer_address") as! String
                                        let CustomerCityID :String = resultJson.value(forKey: "customer_city_id") as! String
                                        let CustomerCity :String = resultJson.value(forKey: "customer_city") as! String
                                        let CustomerName :String = resultJson.value(forKey: "customer_name") as! String
                                        let userMobile :String = resultJson.value(forKey: "user_phone") as! String

                                        
                                        UserDefaults.standard.set(customerID, forKey: "customerID")
                                        UserDefaults.standard.set(UserName, forKey: "userEmail")
                                        UserDefaults.standard.set(CustomerDOB, forKey: "CustomerDOB")
                                        UserDefaults.standard.set(CustomerAdress, forKey: "CustomerAdress")
                                        UserDefaults.standard.set(CustomerCityID, forKey: "CustomerCityID")
                                        UserDefaults.standard.set(CustomerCity, forKey: "CustomerCity")
                                        UserDefaults.standard.set(CustomerName, forKey: "CustomerName")
                                        UserDefaults.standard.set(userMobile, forKey: "userMobile")

                                        
                                        let flagForgotPass: Bool = resultJson.value(forKey: "flagForgotPass") as! Bool
                                        
                                        if flagForgotPass == false
                                        {
                                            self.viewTopForgotPass.isHidden = true
                                            self.viewForgotPass.isHidden = true
                                            self.viewTop.isHidden = true
                                            self.viewSignIn.isHidden = true
                                            self.viewSignUp.isHidden = true
                                            self.viewtopReset.isHidden = false
                                            self.viewResetPassword.isHidden = false
                                            self.isFromHome = false
                                            self.isFromChangePass = true
                                            
                                            self.hideHUD()

                                        } else {
                                            let message :String = resultJson.value(forKey: "msg_string") as! String
                                            let alert = UIAlertController(title: nil, message: "\(message)", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                                                self.hideHUD()
                                                let Id = customerID
                                                self.delegate?.myVCDidFinishLogin(self, Id: Id)
                                                self.view.removeFromSuperview()
                                            }))
                                            self.present(alert, animated: true, completion: nil)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if response.result.isFailure
                    {
                        print("Response Error")
                        self.hideHUD()
                    }
                }
                
                //                    }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    @IBAction func btnLoginClk(_ sender: Any) {
        viewSignIn.isHidden = false
        viewSignUp.isHidden = true
        
        var frame:CGRect = lblSlider.frame
        frame.origin.x = btnLogin.frame.origin.x
        frame.size.width = btnLogin.frame.size.width
        lblSlider.frame = frame
    }
    
    @IBAction func btnSignUpClk(_ sender: Any) {
        viewSignIn.isHidden = true
        viewSignUp.isHidden = false
        
        var frame:CGRect = lblSlider.frame
        frame.origin.x = btnSignUp.frame.origin.x
        frame.size.width = btnSignUp.frame.size.width
        lblSlider.frame = frame
    }
    
    @IBAction func btnForgotPassClk(_ sender: Any) {
        viewTopForgotPass.isHidden = false
        viewForgotPass.isHidden = false
        viewTop.isHidden = true
        viewSignIn.isHidden = true
        viewSignUp.isHidden = true
        isFromHome = false
    }
    
   
    @IBAction func btnRegisterClk(_ sender: Any) {
        ValidationSignUp()
    }
    
    func ValidationSignUp()
    {
        let testStr = txtEmailIDSignUp.text
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValid:Bool = emailTest.evaluate(with: testStr)
        
        let charcterSet  = NSCharacterSet(charactersIn: "0123456789").inverted
        let inputString = txtMobileSignUp.text?.components(separatedBy: charcterSet)
        let filtered = inputString?.joined(separator: "")
        
        if !isValid {
            txtEmailIDSignUp.errorText = "Email Id"
            txtEmailIDSignUp.showError()
            txtEmailIDSignUp.showError(withText: "Enter Email ID")
            
            txtEmailIDSignUp.errorTextColor = UIColor.red
        }
        else if txtMobileSignUp.text!.count < 10 || txtMobileSignUp.text!.count > 15 || txtMobileSignUp.text != filtered || txtMobileSignUp.text == "Mobile no" || checkSpace(str: txtMobileSignUp.text!) {
            txtMobileSignUp.errorText = "Mobile no"
            txtMobileSignUp.showError()
            txtMobileSignUp.showError(withText: "Enter Mobile no")
            txtMobileSignUp.errorTextColor = UIColor.red
        }
        else if txtPasswordSignUp.text == "Password" || txtPasswordSignUp.text!.count < 6 || checkSpace(str: txtPasswordSignUp.text!) {
            txtPasswordSignUp.errorText = "Password"
            txtPasswordSignUp.showError()
            txtPasswordSignUp.showError(withText: "Enter Password")
            txtPasswordSignUp.errorTextColor = UIColor.red
        }
        else if txtConfirmPassSignUp.text == "" {
            txtConfirmPassSignUp.errorText = "Confirm Password"
            txtConfirmPassSignUp.showError()
            txtConfirmPassSignUp.showError(withText: "Enter Confirm Password")
            txtConfirmPassSignUp.errorTextColor = UIColor.red
        }
        else if txtConfirmPassSignUp.text != txtPasswordSignUp.text {
            txtConfirmPassSignUp.errorText = "Confirm Password"
            txtConfirmPassSignUp.showError()
            txtConfirmPassSignUp.showError(withText: "Password mismatch")
            txtConfirmPassSignUp.errorTextColor = UIColor.red
        }
        else {
            if currentReachabilityStatus != .notReachable
            {
                Register()
            } else {
                self.alert()
            }
        }
    }
    
    func checkSpace(str:String) -> Bool
    {
        let rawString: String = str
        let whitespace = CharacterSet.whitespacesAndNewlines
        let trimmed = rawString.trimmingCharacters(in: whitespace)
        if (trimmed.count ) == 0 {
            // Text was empty or only whitespace.
            return true
        }
        return false
    }
    
    func Register()
    {
        showHud("Loading")
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        let param : [String:String] = ["userEmail": txtEmailIDSignUp.text!,
                                       "userMobile": txtMobileSignUp.text!,
                                       "password": txtPasswordSignUp.text!
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in param {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to:"http://54.255.247.3/selfserve/webapp/customer-app/ws-login/ws-signup.php")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.request!)  // original URL request
                    print(response.response!) // URL response
                    print(response.data!)     // server data
                    print(response.result)   // result of response serialization
                   
                    if response.result.isSuccess
                    {
                        if let resJson = response.result.value as? NSDictionary
                        {
                            if let resultJson = resJson.value(forKey: "result") as? NSDictionary
                            {
                                if let responseCode = resultJson.value(forKey: "msg") as? String
                                {
                                    if responseCode == "0" {
                                        
                                        let message :String = resultJson.value(forKey: "msg_string") as! String
                                        let alert = UIAlertController(title: nil, message: "\(message)", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                                            self.hideHUD()
                                        }
                                        ))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                    else if responseCode == "1" {
                                        let customerID :String = resultJson.value(forKey: "customer_id") as! String
                                        let userEmail :String = resultJson.value(forKey: "userEmail") as! String
                                        let userMobile :String = resultJson.value(forKey: "userMobile") as! String
                                        
                                        UserDefaults.standard.set(customerID, forKey: "customerID")
                                        UserDefaults.standard.set(userEmail, forKey: "userEmail")
                                        UserDefaults.standard.set(userMobile, forKey: "userMobile")
                                        
                                        let message :String = resultJson.value(forKey: "msg_string") as! String
                                        let alert = UIAlertController(title: nil, message: "\(message)", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                                            let Id = customerID
                                            self.delegate?.myVCDidFinishLogin(self, Id: Id)
                                            self.view.removeFromSuperview()
                                            self.hideHUD()
                                        }
                                        ))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                    }
                    else if response.result.isFailure
                    {
                        print("Response Error")
                        self.hideHUD()
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    @IBAction func btnFacebookClk(_ sender: Any) {
        
        if currentReachabilityStatus != .notReachable
        {
            UserDefaults.standard.setValue("facebook", forKey: "SIGNIN")
            UserDefaults.standard.synchronize()
            
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
                if (error == nil){
                    if (result?.isCancelled)! {
                        return
                    }
                    else {
                        let fbloginresult : FBSDKLoginManagerLoginResult = result!
                        
                        if(fbloginresult.grantedPermissions.contains("email"))
                        {
                            self.getFBUserData()
                        }
                    }
                }
            }
        } else
        {
            alert()
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil)
        {
            //            let manager = FBSDKLoginManager()
            //            manager.logIn(withReadPermissions: ["user_location"], from: self, handler: nil)
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, location, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print(result!)
                    let fb_data = result as? NSDictionary
                    let email_fb = fb_data?["email"] as! String
                    let fb_firstName = fb_data?["first_name"] as! String
//                    let fb_lastName = fb_data?["last_name"] as! String
                    
                    //                    UserDefaults.standard.set(self.email_fb, forKey: "email")
                    //                    UserDefaults.standard.set(self.fb_firstName, forKey: "first_name")
                    //                    UserDefaults.standard.set(self.fb_lastName, forKey: "last_name")
                    
                    let picture:NSDictionary = fb_data?["picture"] as! NSDictionary
                    let data:NSDictionary = picture.value(forKey: "data") as! NSDictionary
                    
                    let fb_imageURL:String = "\(data.value(forKey: "url")!)"
                    
                    let fb_image = fb_imageURL
                    
                    let FB_ID:String = fb_data?["id"] as! String
                    
                    print("USER >>> \(fb_image)")
                    
                    self.outhID = FB_ID
                    self.outhProvider = "Facebook"
                    self.outhEmail = email_fb
                    self.outhName = fb_firstName
                    
                    if self.currentReachabilityStatus != .notReachable
                    {
                        self.socialLogin()
                    } else {
                        self.alert()
                    }
                }
            })
        }
    }

    @IBAction func btnGoogleClk(_ sender: Any) {
        if currentReachabilityStatus != .notReachable
        {
        UserDefaults.standard.setValue("google", forKey: "SIGNIN")
        UserDefaults.standard.synchronize()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        } else {
            alert()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            
            let fname: String = user.profile.givenName
            let sname: String = user.profile.familyName
            let email: String = user.profile.email
            let token: String = user.authentication.idToken
            let userid:String = user.userID
            let imageUrl = signIn.currentUser.profile.imageURL(withDimension: 120)
            print("image url is \(String(describing: imageUrl?.path))")
            
            print(fname)
            print(sname)
            print(email)
            print(token)
            print(userid)
            
            outhID = userid
            outhProvider = "Google"
            outhEmail = email
            outhName = fname
            
            if currentReachabilityStatus != .notReachable
            {
                socialLogin()
            } else {
                alert()
            }
        }
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }

    
    func socialLogin()
    {
        showHud("Loading")
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        let param : [String:String] = ["outh_uid": outhID,
                                       "outh_provider": outhProvider,
                                       "userEmail": outhEmail,
                                       "customer_name": outhName,
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in param {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to:"http://54.255.247.3/selfserve/webapp/customer-app/ws-login/ws-login-with-social-media.php")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.request!)  // original URL request
                    print(response.response!) // URL response
                    print(response.data!)     // server data
                    print(response.result)   // result of response serialization
                    
                    if response.result.isSuccess
                    {
                        if let resJson = response.result.value as? NSDictionary
                        {
                            if let resultJson = resJson.value(forKey: "result") as? NSDictionary
                            {
                                if let responseCode = resultJson.value(forKey: "msg") as? String
                                {
                                    if responseCode == "0"
                                    {
                                        let message :String = resultJson.value(forKey: "msg_string") as! String
                                        let alert = UIAlertController(title: nil, message: "\(message)", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                                            self.hideHUD()
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    }
                                    else if responseCode == "1"
                                    {
                                        let customerID :String = resultJson.value(forKey: "customer_id") as! String
                                        let UserName :String = resultJson.value(forKey: "user_email") as! String
                                        let CustomerDOB :String = resultJson.value(forKey: "customer_dob") as! String
                                        let CustomerAdress :String = resultJson.value(forKey: "customer_address") as! String
                                        let CustomerCityID :String = resultJson.value(forKey: "customer_city_id") as! String
                                        let CustomerCity :String = resultJson.value(forKey: "customer_city") as! String
                                        let CustomerName :String = resultJson.value(forKey: "customer_name") as! String
                                        
                                        UserDefaults.standard.set(customerID, forKey: "customerID")
                                        UserDefaults.standard.set(UserName, forKey: "userEmail")
                                        UserDefaults.standard.set(CustomerDOB, forKey: "CustomerDOB")
                                        UserDefaults.standard.set(CustomerAdress, forKey: "CustomerAdress")
                                        UserDefaults.standard.set(CustomerCityID, forKey: "CustomerCityID")
                                        UserDefaults.standard.set(CustomerCity, forKey: "CustomerCity")
                                        UserDefaults.standard.set(CustomerName, forKey: "CustomerName")
                                        
                                        let flagForgotPass: Bool = resultJson.value(forKey: "flagForgotPass") as! Bool
                                        
                                        if flagForgotPass == false
                                        {
                                            self.viewTopForgotPass.isHidden = true
                                            self.viewForgotPass.isHidden = true
                                            self.viewTop.isHidden = true
                                            self.viewSignIn.isHidden = true
                                            self.viewSignUp.isHidden = true
                                            self.viewtopReset.isHidden = false
                                            self.viewResetPassword.isHidden = false
                                            self.isFromHome = false
                                            self.isFromChangePass = true
                                            
                                            self.hideHUD()

                                        } else {
                                        let message :String = resultJson.value(forKey: "msg_string") as! String
                                        let alert = UIAlertController(title: nil, message: "\(message)", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                                            let Id = customerID
                                            self.delegate?.myVCDidFinishLogin(self, Id: Id)
                                            self.view.removeFromSuperview()
                                            self.hideHUD()
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if response.result.isFailure
                    {
                        print("Response Error")
                        self.hideHUD()
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        print("logout from facebook")
    }
    
    @IBAction func btnSendForgotPassClk(_ sender: Any) {
        if currentReachabilityStatus != .notReachable
        {
            ForgotPassword()
        }
        else
        {
            self.alert()
        }
    }
    
    func ForgotPassword()
    {
        showHud("Loading")
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        let param : [String:String] = ["userEmail": txtEmailForgotPass.text!,
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in param {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to:"http://54.255.247.3/selfserve/webapp/customer-app/ws-login/ws-forgot.php")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.request!)  // original URL request
                    print(response.response!) // URL response
                    print(response.data!)     // server data
                    print(response.result)   // result of response serialization
                    
                    if response.result.isSuccess
                    {
                        if let resJson = response.result.value as? NSDictionary
                        {
                            if let resultJson = resJson.value(forKey: "result") as? NSDictionary
                            {
                                if let responseCode = resultJson.value(forKey: "msg") as? String
                                {
                                    if responseCode == "0" {
                                    }
                                    else if responseCode == "1" {
                                        self.viewTopForgotPass.isHidden = true
                                        self.viewForgotPass.isHidden = true
                                        self.viewTop.isHidden = false
                                        self.viewSignIn.isHidden = false
                                        self.viewSignUp.isHidden = true
                                    }
                                    
                                    let message :String = resultJson.value(forKey: "msg_string") as! String
                                    let alert = UIAlertController(title: nil, message: "\(message)", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                                        self.hideHUD()
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                    else if response.result.isFailure
                    {
                        print("Response Error")
                        self.hideHUD()
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    @IBAction func btnSendResetClk(_ sender: Any) {
        if txtRePassReset.text == "" || txtNewPassReset.text == "" {
            let alert = UIAlertController(title: nil, message: "Please enter new password and confirm password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if currentReachabilityStatus != .notReachable {
                sendResetPassword()
            }
        }
    }
    
    func sendResetPassword()
    {
        showHud("Loading")
        
        let customer_id :String = UserDefaults.standard.value(forKey: "customerID") as! String
        
        print(txtNewPassReset.text!)
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        let param : [String:String] = ["customer_id": customer_id,
                                       "password": txtNewPassReset.text!
                                       ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in param {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to:"http://54.255.247.3/selfserve/webapp/customer-app/ws-login/ws-reset-password.php")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.request!)  // original URL request
                    print(response.response!) // URL response
                    print(response.data!)     // server data
                    print(response.result)   // result of response serialization
                    
                    
                    if response.result.isSuccess
                    {
                        if let resJson = response.result.value as? NSDictionary
                        {
                            if let resultJson = resJson.value(forKey: "result") as? NSDictionary
                            {
                                if let responseCode = resultJson.value(forKey: "msg") as? String
                                {
                                    if responseCode == "0" {
                                        let message :String = resultJson.value(forKey: "msg_string") as! String
                                        let alert = UIAlertController(title: nil, message: "\(message)", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                                            self.hideHUD()
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                    else if responseCode == "1" {
                                        self.viewTopForgotPass.isHidden = true
                                        self.viewForgotPass.isHidden = true
                                        self.viewTop.isHidden = false
                                        self.viewSignIn.isHidden = false
                                        self.viewSignUp.isHidden = true
                                        self.viewtopReset.isHidden = true
                                        self.viewResetPassword.isHidden = true
                                        
                                        let message :String = resultJson.value(forKey: "msg_string") as! String
                                        let alert = UIAlertController(title: nil, message: "\(message)", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                                            let Id = customer_id
                                            self.delegate?.myVCDidFinishLogin(self, Id: Id)
                                            self.view.removeFromSuperview()
                                            self.hideHUD()
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                    }
                    else if response.result.isFailure
                    {
                        print("Response Error")
                        self.hideHUD()
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    // MARK : Textfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtUserName.resignFirstResponder()
        txtPassword.resignFirstResponder()
        txtEmailIDSignUp.resignFirstResponder()
        txtMobileSignUp.resignFirstResponder()
        txtPasswordSignUp.resignFirstResponder()
        txtConfirmPassSignUp.resignFirstResponder()
        txtEmailForgotPass.resignFirstResponder()
        txtNewPassReset.resignFirstResponder()
        txtRePassReset.resignFirstResponder()
        txtConfirmPassSignUp.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
