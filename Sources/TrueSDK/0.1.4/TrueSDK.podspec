Pod::Spec.new do |s|

  s.name         = "TrueSDK"
  s.version      = "0.1.4"
  s.summary      = "Official Truecaller SDK for iOS for one tap verified phone number based sign up/login."

  s.description  = <<-DESC
                  TrueSDK framework provides:
                  * Truecaller login to easily sign in users.
                  * Truecaller autofill to easily fill form data.
                   DESC

  s.homepage     = "https://developer.truecaller.com"
  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.author             = { "Truecaller" => "truecallerdevelopers@truecaller.com" }
  s.social_media_url   = "http://twitter.com/Truecaller"

  s.platform     = :ios
  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/truecaller/ios-sdk.git", :tag => "v#{s.version}" }
  s.ios.weak_frameworks = "UIKit", "Foundation"
  s.requires_arc = true

  s.source_files  = "TrueSDK/*.{h,m}", "TrueSDK/**/*.{h,m}"
  s.public_header_files = "TrueSDK/*.{h}", "TrueSDK/**/*.{h}"

  s.resources = [ "TrueSDK/**/Assets.xcassets"]

  #TODO: Move to resource bundles
  s.resource_bundles = { "TrueSDK" => [ "TrueSDK/External/Languages/*" ] }

end
