//
//  ViewController.swift
//  SwiftTrueSDKHost
//
//  Created by Aleksandar Mihailovski on 16/12/16.
//  Copyright © 2016 True Software Scandinavia AB. All rights reserved.
//

import UIKit
import TrueSDK

enum TrueUserProperties: Int {
    case name = 0
    case phone
    case address
    case email
    case job
    case company
    case countryCode
    case gender
    case url
    case time
    
    func title() -> String {
        switch self {
            case .name:
                return "Name"
            case .phone:
                return "Phone"
            case .address:
                return "Address"
            case .email:
                return "Email"
            case .job:
                return "Job"
            case .company:
                return "Company"
            case .countryCode:
                return "Country"
            case .gender:
                return "Gender"
            case .url:
                return "Url"
            case .time:
                return "Date-Time"
        }
    }
}

typealias userDataModelType = [(String, String)] //Used as an ordered key,value store

func dateString(from timeStamp: Double) -> String {
    let date = Date(timeIntervalSince1970: timeStamp)
    let dateFormatter = DateFormatter()
//    dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
    let strDate = dateFormatter.string(from: date)
    
    return strDate
}

extension TCTrueProfile {
    func tupleList() -> userDataModelType {
        var retVal = userDataModelType()
        
        //Parse full name
        var fullname = self.firstName ?? ""
        fullname = fullname.count > 0 ? "\(self.firstName ?? "") \(self.lastName ?? "")" : (self.lastName ?? "")
        
        //Parse address
        var address = self.street ?? ""
        var zipcity = self.zipCode ?? ""
        let city = self.city ?? ""
        zipcity = zipcity.count > 0 ? "\(zipcity)\(city.count > 0 ? " " : "")\(city)" : city
        address = zipcity.count > 0 ? "\(address)\(address.count > 0 ? ", " : "")\(zipcity)" : address
        
        //Fill user data model
        //Non-optional values for display
        retVal.append((TrueUserProperties.name.title(), fullname))
        retVal.append((TrueUserProperties.phone.title(), self.phoneNumber ?? ""))
        retVal.append((TrueUserProperties.address.title(), address))
        retVal.append((TrueUserProperties.email.title(), self.email ?? ""))
        retVal.append((TrueUserProperties.job.title(), self.jobTitle ?? ""))
        retVal.append((TrueUserProperties.time.title(), dateString(from: self.requestTime)))

        //Optional values for display
        if let companyName = self.companyName {
            retVal.append((TrueUserProperties.company.title(), companyName))
        }
        if let countryCode = self.countryCode {
            retVal.append((TrueUserProperties.countryCode.title(), countryCode.uppercased()))
        }
        if let gender = self.gender.fullGenderName() {
            retVal.append((TrueUserProperties.gender.title(), gender))
        }
        if let url = self.url {
            retVal.append((TrueUserProperties.url.title(), url))
        }
        
        return retVal
    }
}

extension TCTrueSDKGender {
    func fullGenderName() -> String? {
        switch self {
            case .female:
                return "Female"
            case .male:
                return "Male"
            default:
                return nil
        }
    }
}

//MARK: Error display
class ErrorToast: UIView {
    @IBOutlet weak var errorCode: UILabel!
    @IBOutlet weak var errorDescription: UILabel!
    
    var error: Error? {
        didSet {
            if let nserror = error as NSError? {
                DispatchQueue.main.async { [weak self] in
                    self?.errorCode.text = "\(nserror.domain): \(nserror.code)"
                    self?.errorDescription.text = nserror.localizedDescription
                    self?.isHidden = false
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.errorCode.text = ""
                    self?.errorDescription.text = ""
                    self?.isHidden = true
                }
            }
        }
    }
    
    @IBAction func closeMessage(_ sender: UIButton) {
        error = nil
    }
}

//MARK: User profile display
class HostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TCTrueSDKDelegate, TCTrueSDKViewDelegate, NonTrueCallerDelegate {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var profileRequestButton : TCProfileRequestButton!
    @IBOutlet weak var userDataTableView: UITableView!
    @IBOutlet weak var userDataHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorToast: ErrorToast!
    @IBOutlet weak var otpFlowButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    var isUserLoggedIn: Bool = false {
        didSet {
            if isUserLoggedIn {
                profileRequestButton.isHidden = true
                otpFlowButton.isHidden = true
                logOutButton.isHidden = false
            } else {
                profileRequestButton.isHidden = false
                otpFlowButton.isHidden = false
                logOutButton.isHidden = true
            }
        }
    }
    
    fileprivate var userDataModel: userDataModelType = [] {
        didSet {
            DispatchQueue.main.async {
                self.userDataHeightConstraint.constant = CGFloat(self.userDataModel.count) * self.propertyRowHeight
            }
        }
    }
    fileprivate let propertyRowHeight = CGFloat(44.0)

    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImageView.layer.masksToBounds = true
        
        setEmptyUserData()
        userDataTableView.dataSource = self
        userDataTableView.delegate = self
        userDataHeightConstraint.constant = CGFloat(userDataModel.count) * propertyRowHeight
        
        TCTrueSDK.sharedManager().titleType = .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TCTrueSDK.sharedManager().delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        avatarImageView.layer.cornerRadius = avatarImageView.layer.bounds.height / 2
    }
    
    @IBAction func openTitleSelection() {
        let controller = TitleSelectionTableViewController()
        controller.delegate = self
        controller.title = "Select Title"
        let navigationControlelr = UINavigationController(rootViewController: controller)
        present(navigationControlelr, animated: true, completion: nil)
    }
    
    @IBAction func openNonTCFlow(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nonTcSignInViewController = storyboard.instantiateViewController(withIdentifier: "NonTruecallerSignInViewController") as! NonTruecallerSignInViewController
        nonTcSignInViewController.delegate = self
        let navController = UINavigationController(rootViewController: nonTcSignInViewController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }

    //MARK: - Private
    fileprivate func setEmptyUserData() {
        userDataModel = TCTrueProfile().tupleList()
        
        if let avatarImage = UIImage.init(named: "Avatar_addImage") {
            DispatchQueue.main.async {
                self.avatarImageView.image = avatarImage
            }
        }
    }
    
    fileprivate func parseUserData(_ profile: TCTrueProfile) {
        //Convert the values to dictionary for presentation
        userDataModel = profile.tupleList()
        
        //Load the image if any or show the default one 
        if let avatarURL = profile.avatarURL {
            let url = URL(string: avatarURL)
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url!) {
                    DispatchQueue.main.async {
                        self.avatarImageView.image = UIImage(data: data)
                    }
                }
            }
        } else if let avatarImage = UIImage.init(named: "Avatar_Blue") {
            DispatchQueue.main.async {
                self.avatarImageView.image = avatarImage
            }
        }
    }
    
    //MARK: - UITableViewDataSource
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrueUserPropertyTableViewCell.reuseIdentifier()) as! TrueUserPropertyTableViewCell
        
        let (propertyName, propertyValue) = self.userDataModel[indexPath.row];
        cell.propertyNameLabel?.text = propertyName
        cell.propertyValueLabel?.text = propertyValue
        
        return cell
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userDataModel.count
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return propertyRowHeight
    }
    
    //MARK: - TCTrueSDKDelegate
    open func didFailToReceiveTrueProfileWithError(_ error: TCError) {
        errorToast.error = error
        
        setEmptyUserData()
        userDataTableView.reloadData()
        
        HostLogs.sharedInstance.logError(error)
    }
    
    open func didReceive(_ profile: TCTrueProfile) {
        errorToast.error = nil
        
        parseUserData(profile)
        userDataTableView.reloadData()
        isUserLoggedIn = true
    }
    
    open func willRequestProfile(withNonce nonce: String) {
        // You may store the nonce string to verify the response
        print("nonce: \(nonce)")
    }
    
    open func didReceive(_ profileResponse : TCTrueProfileResponse) {
        // Response signature and signature algorithm can be fetched from profileResponse
        // Nonce can also be retrieved from response and checked against the one received in willRequestProfile method
        print("ProfileResponse payload: \(profileResponse.payload ?? "")")
    }
    
    func didReceiveNonTC(profileResponse: TCTrueProfile) {
        errorToast.error = nil
        parseUserData(profileResponse)
        userDataTableView.reloadData()
        isUserLoggedIn = true
    }
    
    @IBAction func logOut(_ sender: Any) {
        isUserLoggedIn = false
        setEmptyUserData()
        userDataTableView.reloadData()
    }
}

extension HostViewController: TitleSelectionTableViewControllerDelegate {
    func didSet(title: TitleType) {
        TCTrueSDK.sharedManager().titleType = title
    }
}
