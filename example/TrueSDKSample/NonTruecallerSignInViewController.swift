//
//  NonTruecallerSignInViewController.swift
//  TrueSDKSample
//
//  Created by Sreedeepkesav M S on 17/11/20.
//  Copyright © 2020 Aleksandar Mihailovski. All rights reserved.
//

import UIKit
import TrueSDK

protocol NonTrueCallerDelegate {
    func didReceiveNonTC(profileResponse : TCTrueProfile)
}

class NonTruecallerSignInViewController: UIViewController, TCTrueSDKDelegate, TCTrueSDKViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var errorToast: ErrorToast!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var otpView: UIView!
    
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var otpField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var countdownLabel: UILabel!
    
    //Default india since the market now is only india
    let defaultCountryCode = "in"
    var delegate: NonTrueCallerDelegate?

    private var timer:Timer?
    private var timeLeft = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(donePressed(_:)))
        
        TCTrueSDK.sharedManager().delegate = self
        TCTrueSDK.sharedManager().viewDelegate = self
        
        otpView.isHidden = true
        phoneNumberView.isHidden = false
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        otpField.delegate = self
    }
    
    @objc func donePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
            showAlert(with: "Error", message: "Please check the input", actionHandler: nil)
            return false
        }
        
        return true
    }
    
    private func showAlert(with title: String, message: String, actionHandler: (() -> Void)?) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { alertAction in
            actionHandler?()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - TCTrueSDKDelegate -
    
    func didReceive(_ profile: TCTrueProfile) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(with: "Profile verified",
                            message: "Profile verified with name: \(profile.firstName ?? "") lastName: \(profile.lastName ?? "") phone: \(profile.phoneNumber ?? "")",
                            actionHandler: {
                                self?.delegate?.didReceiveNonTC(profileResponse: profile)
                                self?.dismiss(animated: true, completion: nil)
                            })
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
            startTtlCountDown()
        case .verificationComplete:
            break;
        case .otpReceived, .verifiedBefore:
            break;
        @unknown default:
            break;
        }
    }
    
    private func startTtlCountDown() {
        guard let ttl = TCTrueSDK.sharedManager().tokenTtl() else { return }
        timeLeft = ttl.intValue
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
    }
    
    @objc private func onTimerFires() {
        timeLeft -= 1
        countdownLabel.text = "Code expires in \(timeLeft) seconds"
        if timeLeft <= 0 {
            stopTtlCountdown()
        }
    }
    
    private func stopTtlCountdown() {
        timer?.invalidate()
        timer = nil
        countdownLabel.text = "OTP expired!"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == otpField else { return true }
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 6
    }
}
