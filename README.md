# iOS SDK

## Getting started

### Prerequisites

You should have:

1. Truecaller app installed
2. App ID in the "Apple development portal". If you do not have App ID yet, then open Project -> Capabilities -> Enable Associated domains. New app id will be automatically created by Xcode.
3. Sign up at https://developer.truecaller.com/sign-up

### Installation

#### Manual Installation

1. Download the framework zip file from [https://developer.truecaller.com](https://developer.truecaller.com/TrueSDK.framework-v0.1.0-.zip) or from the [release section](https://github.com/truecaller/ios-sdk/releases)
2. Unzip the file
3. Drag and drop the TrueSDK framework into your project (ie into the Frameworks folder)
4. Add the TrueSDK framework into the Embedded Binaries section of the General tab of your target

#### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager which automates and simplifies the process of using 3rd-party libraries.

You can install it with the following command:
```bash
$ gem install cocoapods
```

To integrate TrueSDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

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

1. Import the TrueSDK framework in the class where you want to initialize it (for example AppDelegate) and in the class that you want to receive the profile response. Usually, this will be the ViewController responsible for displaying the True Profile info.

	_Swift 2.3:_
	```swift
	import TrueSDK
	```
	
	_Swift 3:_
	```swift
	import TrueSDK
	```

2. Check if the current device supports the use of TrueSDK and (if so) setup TrueSDK. We recommend this to be done in the application:didFinishLaunchingWithOptions:

	_Swift 2.3:_
    ```swift
    //Setup TrueSDK
    if TCTrueSDK.sharedManager().isSupported() {
        TCTrueSDK.sharedManager().setupWithAppKey(<#YOUR_APP_KEY#>, appLink:  <#YOUR_APP_LINK#>)
    }
    ```
	
	_Swift 3:_
	```swift
    //Setup TrueSDK
    if TCTrueSDK.sharedManager().isSupported() {
        TCTrueSDK.sharedManager().setup(withAppKey: <#YOUR_APP_KEY#>, appLink: <#YOUR_APP_LINK#>)
    }
    ```
	
	Use the entire associated domain link provided by Truecaller for YOUR_APP_LINK. For example: `https://si44524554ef8e45b5aa83ced4e96d5xxx.truecallerdevs.com` (including https://).
	
	**Important:** Make sure you type the YOUR_APP_KEY and YOUR_APP_LINK fields correctly. If you mistype the YOUR_APP_LINK field, the permission screen in Truecaller will be shown and immediatelly dismissed. In this case, the SDK will not be able to send a corresponding error back to your app.

3. In AppDelegate implement the method application(application: continue userActivity: restorationHandler:) -> Bool and call the corresponding method of TCTrueSDK.sharedManager(). If the method returns false that means the activity need not be addressed by TrueSDK and you can handle it as desired.

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

4. Set the class where you want to receive TrueSDK events (the profile or errors) a TCTrueSDKDelegate

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

     a. The TCProfileRequestButton does the True Profile Request automatically. To use the predefined buttons you need to set the Button Type to Custom and set auto-layout constraints for the button.
  You can then choose the True button style of the button in code or in Interface Builder using TCProfileRequestButton property buttonStyle:

	_Swift 2.3:_
    ```swift
    self.button.buttonStyle = TCButtonStyleBlue
    ```
	
	_Swift 3:_
	```swift
    self.button.buttonStyle = TCButtonStyle.blue.rawValue
    ```

	![Profile request button](https://raw.githubusercontent.com/truecaller/ios-sdk/master/documentation/images/profile-request-button.png)

    Note: We also provide a custom button style where you can customise the appearance and get the functionality out of the box. Predefined styles available are: white and blue (which is the default one).

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

1. Import the TrueSDK framework in the class where you want to initialize it (for example AppDelegate) and in the class that you want to receive the profile response. Usually, this will be the ViewController responsible for displaying the True Profile info.

    ```objectivec
    #import <TrueSDK/TrueSDK.h>
    ```

2. Check if the current device supports the use of TrueSDK and (if so) setup TrueSDK. We recommend this to be done in the application:didFinishLaunchingWithOptions:

    ```objectivec
    if ([[TCTrueSDK sharedManager] isSupported]) {
        [[TCTrueSDK sharedManager] setupWithAppKey:<#YOUR_APP_KEY#> appLink:<#YOUR_APP_LINK#>];
    }
    ```
	
	Use the entire associated domain link provided by Truecaller for YOUR_APP_LINK. For example: `https://si44524554ef8e45b5aa83ced4e96d5xxx.truecallerdevs.com` (including https://).
	
	**Important:** Make sure you type the YOUR_APP_KEY and YOUR_APP_LINK fields correctly. If you mistype the YOUR_APP_LINK field, the permission screen in Truecaller will be shown and immediatelly dismissed. In this case, the SDK will not be able to send a corresponding error back to your app.

3. In AppDelegate implement the method application:continueUserActivity:restorationHandler: and call the corresponding method of the [TCTrueSDK sharedManager]. If the method returns false that means the activity need not be addressed by TrueSDK and you can handle it as desired.

    ```objectivec
    - (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {
        return [[TCTrueSDK sharedManager] application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
    }
    ```

4. Set the class where you want to receive TrueSDK events (the profile or errors) a TCTrueSDKDelegate

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

6. Set the delegate property of the [TCTrueSDK sharedManager]. Make sure you do this before you request the True Profile.

    ```objectivec
    [TCTrueSDK sharedManager].delegate = self;
    ```

7. Requesting the True Profile data can be done automatically or manually (either in code or in the Interface Builder):

    a. The TCProfileRequestButton does the True Profile Request automatically. To use the predefined buttons you need to set the Button Type to Custom and set auto-layout constraints for the button.
    You can then choose the True button style of the button in code or in Interface Builder using TCProfileRequestButton property buttonStyle:

    ```objectivec
    self.button.buttonStyle = TCButtonStyleBlue;
    ```

	![Profile request button](https://raw.githubusercontent.com/truecaller/ios-sdk/master/documentation/images/profile-request-button.png)

    Note: We also provide a custom button style where you can customise the appearance and get the functionality out of the box. Predefined styles available are: white and blue (which is the default one).

    b. If you prefer to do it yourself, you can use the method requestTrueProfile.

    ```objectivec
    [[TCTrueSDK sharedManager] requestTrueProfile];
    ```

### Errors

In case of error, didFailToReceiveTrueProfileWithError: will return an object of type TCError (a subclass of of NSError). You can get the error code by invoking the method getErrorCode on the TCError object. The list of possible TCTrueSDKErrorCode values can be found in the API documentation.

### Optional verification steps

TrueSDK provides two optional delegate methods to check the authenticity of the profile you receive. Note that TrueSDK readily offers a simplified way to request and receive a user profile via required delegate methods and verifies the content before forwarding it your app.

#### i. Server side Truecaller Profile authenticity check

The delegate method didReceiveTrueProfileResponse: will return a TCTrueProfileResponse instance. Inside TCTrueProfileResponse class there are 3 important fields, payload, signature and signatureAlgorithm. Payload is a Base64 encoding of the json object containing all profile info of the user. Signature contains the payload's signature. You can forward these fields along with the signing algorithm back to your backend and verify the authenticity of the information by doing the following:

1. Fetch Truecaller public keys using this api: http://api4.truecaller.com/v1/key (we recommend you cache these keys for future use and refresh the cache only if you cannot verify the signature);
2. Loop through the public keys and try to verify the signature and payload;

#### ii. Request-Response correlation check

Every request created with TrueSDK has a unique identifier namely 'requestNonce'. This identifier is bundled into the response for assuring a correlation between a request and a response. If you want you can check this correlation yourself by:

1. Get the request nonce at willRequestProfileWithNonce: method
2. In didReceiveTrueProfileResponse: verify that the previously retrieved identifier matches the one in TCTrueProfileResponse.requestNonce.
