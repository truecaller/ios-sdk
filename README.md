# iOS SDK

## Getting started

### Prerequisites

You should have:

1. Truecaller app installed
2. App ID in the "Apple development portal". If you do not have App ID yet, then open you Project -> Capabilities -> Enable Associated domains. New app id will be automatically created by Xcode.
3. Sign up at https://developer.truecaller.com/sign-up

### Installation

1. Download the framework zip file from [https://developer.truecaller.com](https://developer.truecaller.com/TrueSDK.framework-v0.1.0-.zip)
2. Unzip the file
3. Drag and drop the TrueSDK framework into your project (maybe in a dedicated Frameworks folder)
4. Add the TrueSDK framework into the Embedded Binaries section of the General tab of your target

### Usage

Add the entry truesdk under LSApplicationQueriesSchemes in into your Info.plist file

```
<key>LSApplicationQueriesSchemes</key>
<array>
<string>truesdk</string>
</array>
```

![Associated domains](https://raw.githubusercontent.com/truecaller/ios-sdk/master/documentation/images/associated-domains.png)

Add the associated domain provided by Truecaller (for example applinks:si44524554ef8e45b5aa83ced4e96d5xxx.truecallerdevs.com) in Your project -> Capabilities > Associated Domains. The prefix 'applinks:' is needed for universal links to function properly, hence replace the 'https://' part from the provided app link with "applinks:". ie https://si44524554ef8e45b5aa83ced4e96d5xxx.truecallerdevs.com should become applinks:si44524554ef8e45b5aa83ced4e96d5xxx.truecallerdevs.com while adding to entitlements.

#### Swift

1. Import the TrueSDK framework in the class where you want to initialize it (for example AppDelegate) and in the class that you want to receive the profile response. Usually, this will be the ViewController responsible for displaying the True Profile info.

	```swift
	import TrueSDK
	```

2. Check if the current device supports the use of TrueSDK and (if so) setup TrueSDK. We recommend this to be done in the application:didFinishLaunchingWithOptions:

    ```swift
    //Setup TrueSDK
    if TCTrueSDK.sharedManager().isSupported() {
        TCTrueSDK.sharedManager().setup(withAppKey: <#YOUR_APP_KEY#>, appLink: <#YOUR_APP_LINK#>)
    }
    ```

3. In AppDelegate implement the method application(application: continue userActivity: restorationHandler:) -> Bool and call the corresponding method of TCTrueSDK.sharedManager(). If this method call returns false, that means that some application other than Truecaller is opening your application and TrueSDK will not respond.

    ```swift
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Swift.Void) -> Bool {
        return TCTrueSDK.sharedManager().application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
    ```

4. Set the class where you want to receive TrueSDK events (the profile or errors) a TCTrueSDKDelegate

    ```swift
    class HostViewController: UIViewController, TCTrueSDKDelegate {
    ```

5. Implement the two TCTrueSDKDelegate methods

    ```swift
    func didFailToReceiveTrueProfileWithError(_ error: TCError) {
        //Custom code here
    }
    func didReceive(_ profile: TCTrueProfile) {
        //Custom code here
    }
    ```

6. Set the delegate property of the TCTrueSDK.sharedManager(). Make sure you do this before you request the True Profile.

    ```swift
    TCTrueSDK.sharedManager().delegate = self
    ```

7. Requesting the True Profile data can be done automatically or manually (either in code or in the Interface Builder):

     a. The TCProfileRequestButton does the True Profile Request automatically. To use the predefined buttons you need to set the Button Type to Custom and set auto-layout constraints for the button.
  You can then choose the True button style of the button in code or in Interface Builder using TCProfileRequestButton property buttonStyle:

    ```swift
    self.button.buttonStyle = TCButtonStyle.blue.rawValue
    ```

	![Profile request button](https://raw.githubusercontent.com/truecaller/ios-sdk/master/documentation/images/profile-request-button.png)

    b. If you prefer to do it yourself, you can use the method requestTrueProfile.

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

3. In AppDelegate implement the method application:continueUserActivity:restorationHandler: and call the corresponding method of the [TCTrueSDK sharedManager]. If this method call returns false, that means that some application other than Truecaller is opening your application and TrueSDK will not respond.

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

    Note: We also provide a custom button style which is the default one where you can customise the appearance and get the functionality out of the box. Predefined styles available are: white and blue.

    We also provide a custom button style which is the default one where you can customise the appearance and get the functionality out of the box.

    b. If you prefer to do it yourself, you can use the method requestTrueProfile.

    ```objectivec
    [[TCTrueSDK sharedManager] requestTrueProfile];
    ```

### Errors

In case of error, didFailToReceiveTrueProfileWithError: will return an object of type TCError (a subclass of of NSError). You can get the error code by invoking the method getErrorCode on the TCError object. The list of possible TCTrueSDKErrorCode values can be found in the API documentation.

### Optional verification steps

TrueSDK provides two optional delegate methods to check the authenticity of the profile you receive. Note that TrueSDK verifies the content before forwarding it your app and readily offer a simplified way to request and receive a user profile via required delegate methods.

#### i. Server side Truecaller Profile authenticity check

The delegate method didReceiveTrueProfileResponse: will return a TCTrueProfileResponse instance. Inside TCTrueProfileResponse class there are 3 important fields, payload, signature and signatureAlgorithm. Payload is a Base64 encoding of the json object containing all profile info of the user. Signature contains the payload's signature. You can forward these fields along with the signing algorithm back to your backend and verify the authenticity of the information by doing the following:

1. Fetch Truecaller public keys using this api: http://api4.truecaller.com/v1/key (we recommend you cache these keys for future use and refresh the cache only if you cannot verify the signature);
2. Loop through the public keys and try to verify the signature and payload;

#### ii. Request-Response correlation check

Every request created with TrueSDK has a unique identifier namely 'requestNonce'. This identifier is bundled into the response for assuring a correlation between a request and a response. If you want you can check this correlation yourself by:

1. Get the request nonce at willRequestProfileWithNonce: method
2. In didReceiveTrueProfileResponse: verify that the previously retrieved identifier matches the one in TCTrueProfileResponse.requestNonce.