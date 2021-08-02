//
//  NonTruecallerSignInViewController.swift
//  TrueSDKSample
//
//  Created by Sreedeepkesav M S on 17/11/20.
//  Copyright © 2020 Aleksandar Mihailovski. All rights reserved.
//

import UIKit
import TrueSDK

class NonTruecallerSignInViewController: UIViewController, TCTrueSDKDelegate, TCTrueSDKViewDelegate {

    @IBOutlet weak var errorToast: ErrorToast!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var otpView: UIView!
    
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var otpField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    
    //Default india since the market now is only india
    let defaultCountryCode = "in"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TCTrueSDK.sharedManager().delegate = self
        TCTrueSDK.sharedManager().viewDelegate = self
        
        otpView.isHidden = true
        phoneNumberView.isHidden = false
    }
    
    @IBAction func signUp() {
        view.endEditing(true)
        TCTrueSDK.sharedManager().requestVerification(forPhone: phoneNumberField.text ?? "",
                                                      countryCode: defaultCountryCode)
    }

    @IBAction func continueWithOTP() {
        view.endEditing(true)
        TCTrueSDK.sharedManager().verifySecurityCode(otpField.text ?? "",
                                                     andUpdateFirstname: firstNameField.text ?? "",
                                                     lastName: lastNameField.text ?? "")
    }
    
    private func verifyFields() -> Bool {
        guard otpField.text?.isEmpty == true,
              firstNameField.text?.isEmpty == true else {
            showAlert(with: "Error", message: "Please check the input")
            return false
        }
        
        return true
    }
    
    private func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - TCTrueSDKDelegate -
    
    func didReceive(_ profile: TCTrueProfile) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(with: "Profile already verified",
                      message: "Already verified profile with name: \(profile.firstName ?? "") lastName: \(profile.lastName ?? "") phone: \(profile.phoneNumber ?? "")")
        }
    }
    
    func didFailToReceiveTrueProfileWithError(_ error: TCError) {
        errorToast.error = error
    }
    
    func verificationStatusChanged(to verificationState: TCVerificationState) {
        DispatchQueue.main.async {
            self.handle(verificationState: verificationState)
        }
    }
    
    private func handle(verificationState: TCVerificationState) {
        switch verificationState {
        case .otpInitiated:
            self.otpView.isHidden = false
            self.phoneNumberView.isHidden = true
        case .verificationComplete:
            self.showAlert(with: "Sign up successful",
                           message: "Your otp is validated and profile created.")
        case .otpReceived, .verifiedBefore:
            break
        @unknown default:
            break;
        }
    }
}
