# iOS SDK

## Getting started

### Prerequisites

You should have:

1. Truecaller app installed
2. App ID in the "Apple development portal". If you do not have App ID yet, then open Project -> Capabilities -> Enable Associated domains. New app id will be automatically created by Xcode.
3. Sign up at https://developer.truecaller.com/sign-up

### Installation

#### Manual Installation

1. Download the project zip file from the [release section](https://github.com/truecaller/ios-sdk/releases)
2. Unzip the file
3. Copy the TruecallerSDK project files into your project (TrueSDK directory, TrueSDKTests directory and TrueSDK.xcodeproj)
4. Drag and drop TrueSDK.xcodeproj into your project (ie add it as a subproject to your main project).
Embedding it this way will not require any additional script to be run.
5. Add the TruecallerSDK framework (from Products output of TrueSDK.xcodeproj) into the Embedded Binaries section of the General tab of your target

NOTE: We recommend using the CocoaPods integration.

#### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager which automates and simplifies the process of using 3rd-party libraries.

You can install it with the following command:
```bash
$ gem install cocoapods
```
You can create your Podfile using the command (in case you do not already have it):
```bash
$ pod init
```

To integrate TruecallerSDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!

target 'TargetName' do
pod 'TrueSDK'
end
```
Then, run the following command:
```bash
$ pod install
```

### Usage

Add the entry truesdk under LSApplicationQueriesSchemes in into your Info.plist file

```
<key>LSApplicationQueriesSchemes</key>
<array>
<string>truesdk</string>
</array>
```

![Associated domains](https://raw.githubusercontent.com/truecaller/ios-sdk/master/documentation/images/associated-domains.png)

Add the associated domain provided by Truecaller (for example applinks:si44524554ef8e45b5aa83ced4e96d5xxx.truecallerdevs.com) in Your project -> Capabilities > Associated Domains. The prefix 'applinks:' is needed for universal links to function properly. 

**Important:** Replace the '**https://**' part from the provided app link with "**applinks:**". ie _`https://si44524554ef8e45b5aa83ced4e96d5xxx.truecallerdevs.com`_ should become _`applinks:si44524554ef8e45b5aa83ced4e96d5xxx.truecallerdevs.com`_ while adding to entitlements.

(Note that there is **no** _http://_ or _https://_ prefix when setting up the applinks:)

#### Swift

1. Import the TruecallerSDK framework in the class where you want to initialize it (for example AppDelegate) and in the class that you want to receive the profile response. Usually, this will be the ViewController responsible for displaying the True Profile info.

	_Swift 2.3:_
	```swift
	import TrueSDK
	```
	
	_Swift 3:_
	```swift
	import TrueSDK
	```

2. Check if the current device supports the use of TruecallerSDK and (if so) setup TruecallerSDK. We recommend this to be done in the application:didFinishLaunchingWithOptions:

	_Swift 2.3:_
    ```swift
    //Setup TruecallerSDK
    if TCTrueSDK.sharedManager().isSupported() {
        TCTrueSDK.sharedManager().setupWithAppKey(<#YOUR_APP_KEY#>, appLink:  <#YOUR_APP_LINK#>)
    }
    ```
	
	_Swift 3:_
	```swift
    //Setup TruecallerSDK
    if TCTrueSDK.sharedManager().isSupported() {
        TCTrueSDK.sharedManager().setup(withAppKey: <#YOUR_APP_KEY#>, appLink: <#YOUR_APP_LINK#>)
    }
    ```
	
	Use the entire associated domain link provided by Truecaller for YOUR_APP_LINK. For example: `https://si44524554ef8e45b5aa83ced4e96d5xxx.truecallerdevs.com` (including https://).
	
	**Important:** Make sure you type the YOUR_APP_KEY and YOUR_APP_LINK fields correctly. If you mistype the YOUR_APP_LINK field, the permission screen in Truecaller will be shown and immediatelly dismissed. In this case, the SDK will not be able to send a corresponding error back to your app.

3. In AppDelegate implement the method application(application: continue userActivity: restorationHandler:) -> Bool and call the corresponding method of TCTrueSDK.sharedManager(). If the method returns false that means the activity need not be addressed by TruecallerSDK and you can handle it as desired.

	_Swift 2.3:_
    ```swift
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        return TCTrueSDK.sharedManager().application(application, continueUserActivity: userActivity, restorationHandler: restorationHandler)
    }
    ```
	
	_Swift 3:_
	```swift
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Swift.Void) -> Bool {
        return TCTrueSDK.sharedManager().application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
    ```

4. Set the class where you want to receive TruecallerSDK events (the profile or errors) a TCTrueSDKDelegate

	_Swift 2.3:_
    ```swift
    class HostViewController: UIViewController, TCTrueSDKDelegate {
    ```
	
	_Swift 3:_
	```swift
    class HostViewController: UIViewController, TCTrueSDKDelegate {
    ```

5. Implement the two TCTrueSDKDelegate methods

	_Swift 2.3:_
    ```swift
	func didFailToReceiveTrueProfileWithError(error: TCError) {
        //Custom code here
    }
    func didReceiveTrueProfile(profile: TCTrueProfile) {
        //Custom code here
    }
    ```
	
	_Swift 3:_
	```swift
    func didFailToReceiveTrueProfileWithError(_ error: TCError) {
        //Custom code here
    }
    func didReceive(_ profile: TCTrueProfile) {
        //Custom code here
    }
    ```
    
The profile object is of type TCTrueProfile (written in Objective C) which offers the following user data:

```objectivec
typedef NS_ENUM(NSUInteger, TCTrueSDKGender) {
    TCTrueSDKGenderNotSpecified = 0, //
    TCTrueSDKGenderMale, //
    TCTrueSDKGenderFemale, //
};

/*!
 * @class TCTrueProfile
 * @brief The True Profile info returned.
 */

@interface TCTrueProfile : NSObject <NSCoding>

/*! @property firstName @brief User's first name */
@property (nonatomic, strong, nullable, readonly) NSString *firstName;
/*! @property lastName @brief User's last name */
@property (nonatomic, strong, nullable, readonly) NSString *lastName;
/*! @property phoneNumber @brief User's phone number */
@property (nonatomic, strong, nullable, readonly) NSString *phoneNumber;
/*! @property countryCode @brief User's country code */
@property (nonatomic, strong, nullable, readonly) NSString *countryCode;
/*! @property street @brief User's street address */
@property (nonatomic, strong, nullable, readonly) NSString *street;
/*! @property city @brief User's city */
@property (nonatomic, strong, nullable, readonly) NSString *city;
/*! @property zipCode @brief User's zip code */
@property (nonatomic, strong, nullable, readonly) NSString *zipCode;
/*! @property facebookID @brief User's facebook id */
@property (nonatomic, strong, nullable, readonly) NSString *facebookID;
/*! @property twitterID @brief User's twitter id */
@property (nonatomic, strong, nullable, readonly) NSString *twitterID;
/*! @property email @brief User's email */
@property (nonatomic, strong, nullable, readonly) NSString *email;
/*! @property url @brief User's Truecaller profile url */
@property (nonatomic, strong, nullable, readonly) NSString *url;
/*! @property avatarURL @brief User's avatar url */
@property (nonatomic, strong, nullable, readonly) NSString *avatarURL;
/*! @property jobTitle @brief User's job title */
@property (nonatomic, strong, nullable, readonly) NSString *jobTitle;
/*! @property companyName @brief User's company name */
@property (nonatomic, strong, nullable, readonly) NSString *companyName;
/*! @property gender @brief User's gender */
@property (nonatomic, assign, readonly) TCTrueSDKGender gender;
/*! @property isVerified @brief User's account special verification status */
@property (nonatomic, assign, readonly) BOOL isVerified;
/*! @property isAmbassador @brief Is the user a Truecaller ambasador */
@property (nonatomic, assign, readonly) BOOL isAmbassador;
```
6. Set the delegate property of the TCTrueSDK.sharedManager(). Make sure you do this before you request the True Profile.

	_Swift 2.3:_
    ```swift
    TCTrueSDK.sharedManager().delegate = self
    ```
	
	_Swift 3:_
	```swift
    TCTrueSDK.sharedManager().delegate = self
    ```

7. Requesting the True Profile data can be done automatically or manually (either in code or in the Interface Builder):

     a. The TCProfileRequestButton does the True Profile Request automatically. To use the predefined buttons you need to **set the Button Type to Custom** and set auto-layout constraints for the button.
  You can then choose the True button style and corners style of the button in code or in Interface Builder using TCProfileRequestButton property buttonStyle and buttonCornersStyle:

	_Swift 2.3:_
    ```swift
    self.button.buttonStyle = TCButtonStyleBlue
    self.button.buttonCornersStyle = TCButtonCornersStyleRounded
    ```
	
	_Swift 3:_
	```swift
    self.button.buttonStyle = TCButtonStyle.blue.rawValue
    self.button.buttonCornersStyle = TCButtonCornersStyle.rounded.rawValue
    ```

	![Profile request button](https://raw.githubusercontent.com/truecaller/ios-sdk/master/documentation/images/profile-request-button.png)
	
    b. If you prefer to do it yourself, you can use the method requestTrueProfile.

	_Swift 2.3:_
    ```swift
    TCTrueSDK.sharedManager().requestTrueProfile()
    ```
	
	_Swift 3:_
	```swift
    TCTrueSDK.sharedManager().requestTrueProfile()
    ```

#### Objective-C

1. Import the TruecallerSDK framework in the class where you want to initialize it (for example AppDelegate) and in the class that you want to receive the profile response. Usually, this will be the ViewController responsible for displaying the True Profile info.

    ```objectivec
    #import <TrueSDK/TrueSDK.h>
    ```

2. Check if the current device supports the use of TruecallerSDK and (if so) setup TruecallerSDK. We recommend this to be done in the application:didFinishLaunchingWithOptions:

    ```objectivec
    if ([[TCTrueSDK sharedManager] isSupported]) {
        [[TCTrueSDK sharedManager] setupWithAppKey:<#YOUR_APP_KEY#> appLink:<#YOUR_APP_LINK#>];
    }
    ```
	
	Use the entire associated domain link provided by Truecaller for YOUR_APP_LINK. For example: `https://si44524554ef8e45b5aa83ced4e96d5xxx.truecallerdevs.com` (including https://).
	
	**Important:** Make sure you type the YOUR_APP_KEY and YOUR_APP_LINK fields correctly. If you mistype the YOUR_APP_LINK field, the permission screen in Truecaller will be shown and immediatelly dismissed. In this case, the SDK will not be able to send a corresponding error back to your app.

3. In AppDelegate implement the method application:continueUserActivity:restorationHandler: and call the corresponding method of the [TCTrueSDK sharedManager]. If the method returns false that means the activity need not be addressed by TruecallerSDK and you can handle it as desired.

    ```objectivec
    - (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {
        return [[TCTrueSDK sharedManager] application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
    }
    ```

4. Set the class where you want to receive TruecallerSDK events (the profile or errors) a TCTrueSDKDelegate

    ```objectivec
    #import <UIKit/UIKit.h>
    #import <TrueSDK/TrueSDK.h>

    @interface ViewController : UIViewController <TCTrueSDKDelegate>

    @end
    ```

5. Implement the two TCTrueSDKDelegate methods

    ```objectivec
    - (void)didReceiveTrueProfile:(nonnull TCTrueProfile *)profile {
        //Custom code
    }
    - (void)didFailToReceiveTrueProfileWithError:(nonnull TCError *)error {
        //Custom code
    }
    ```
The profile object is of type TCTrueProfile (written in Objective C) which offers the following user data:

```objectivec
typedef NS_ENUM(NSUInteger, TCTrueSDKGender) {
    TCTrueSDKGenderNotSpecified = 0, //
    TCTrueSDKGenderMale, //
    TCTrueSDKGenderFemale, //
};

/*!
 * @class TCTrueProfile
 * @brief The True Profile info returned.
 */

@interface TCTrueProfile : NSObject <NSCoding>

/*! @property firstName @brief User's first name */
@property (nonatomic, strong, nullable, readonly) NSString *firstName;
/*! @property lastName @brief User's last name */
@property (nonatomic, strong, nullable, readonly) NSString *lastName;
/*! @property phoneNumber @brief User's phone number */
@property (nonatomic, strong, nullable, readonly) NSString *phoneNumber;
/*! @property countryCode @brief User's country code */
@property (nonatomic, strong, nullable, readonly) NSString *countryCode;
/*! @property street @brief User's street address */
@property (nonatomic, strong, nullable, readonly) NSString *street;
/*! @property city @brief User's city */
@property (nonatomic, strong, nullable, readonly) NSString *city;
/*! @property zipCode @brief User's zip code */
@property (nonatomic, strong, nullable, readonly) NSString *zipCode;
/*! @property facebookID @brief User's facebook id */
@property (nonatomic, strong, nullable, readonly) NSString *facebookID;
/*! @property twitterID @brief User's twitter id */
@property (nonatomic, strong, nullable, readonly) NSString *twitterID;
/*! @property email @brief User's email */
@property (nonatomic, strong, nullable, readonly) NSString *email;
/*! @property url @brief User's Truecaller profile url */
@property (nonatomic, strong, nullable, readonly) NSString *url;
/*! @property avatarURL @brief User's avatar url */
@property (nonatomic, strong, nullable, readonly) NSString *avatarURL;
/*! @property jobTitle @brief User's job title */
@property (nonatomic, strong, nullable, readonly) NSString *jobTitle;
/*! @property companyName @brief User's company name */
@property (nonatomic, strong, nullable, readonly) NSString *companyName;
/*! @property gender @brief User's gender */
@property (nonatomic, assign, readonly) TCTrueSDKGender gender;
/*! @property isVerified @brief User's account special verification status */
@property (nonatomic, assign, readonly) BOOL isVerified;
/*! @property isAmbassador @brief Is the user a Truecaller ambasador */
@property (nonatomic, assign, readonly) BOOL isAmbassador;
```

6. Set the delegate property of the [TCTrueSDK sharedManager]. Make sure you do this before you request the True Profile.

    ```objectivec
    [TCTrueSDK sharedManager].delegate = self;
    ```

7. Requesting the True Profile data can be done automatically or manually (either in code or in the Interface Builder):

    a. The TCProfileRequestButton does the True Profile Request automatically. To use the predefined buttons you need to **set the Button Type to Custom** and set auto-layout constraints for the button.
  You can then choose the True button style and corners style of the button in code or in Interface Builder using TCProfileRequestButton property buttonStyle and buttonCornersStyle:

    ```objectivec
    self.button.buttonStyle = TCButtonStyleBlue;
    self.button.buttonCornersStyle = TCButtonCornersStyleRounded;
    ```

	![Profile request button](https://raw.githubusercontent.com/truecaller/ios-sdk/master/documentation/images/profile-request-button.png)

    b. If you prefer to do it yourself, you can use the method requestTrueProfile.

    ```objectivec
    [[TCTrueSDK sharedManager] requestTrueProfile];
    ```

### Errors

In case of error, didFailToReceiveTrueProfileWithError: will return an object of type TCError (a subclass of of NSError). You can get the error code by invoking the method getErrorCode on the TCError object. The list of possible TCTrueSDKErrorCode values can be found in the API documentation.

### Optional verification steps

TruecallerSDK provides two optional delegate methods to check the authenticity of the profile you receive. Note that TruecallerSDK readily offers a simplified way to request and receive a user profile via required delegate methods and verifies the content before forwarding it your app.

#### i. Server side Truecaller Profile authenticity check

The delegate method didReceiveTrueProfileResponse: will return a TCTrueProfileResponse instance. Inside TCTrueProfileResponse class there are 3 important fields, payload, signature and signatureAlgorithm. Payload is a Base64 encoding of the json object containing all profile info of the user. Signature contains the payload's signature. You can forward these fields along with the signing algorithm back to your backend and verify the authenticity of the information by doing the following:

1. Fetch Truecaller public keys using this api: https://api4.truecaller.com/v1/key (we recommend you cache these keys for future use and refresh the cache only if you cannot verify the signature);
2. Loop through the public keys and try to verify the signature and payload;

#### ii. Request-Response correlation check

Every request created with TruecallerSDK has a unique identifier namely 'requestNonce'. This identifier is bundled into the response for assuring a correlation between a request and a response. If you want you can check this correlation yourself by:

1. Get the request nonce at willRequestProfileWithNonce: method
2. In didReceiveTrueProfileResponse: verify that the previously retrieved identifier matches the one in TCTrueProfileResponse.requestNonce.
