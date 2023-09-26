Pod::Spec.new do |spec|

  spec.name         = "GoSwirlLiveStream"
  spec.version      = "1.5.6"
  spec.summary      = "This is the best framework."
  spec.description  = "This is the GoSwirlLiveStream framework."
  
  spec.homepage     = "https://github.com/SwirlAdmin/ios-live-stream/GoSwirlLiveStream"
  spec.license      = "MIT"
  spec.author       = { "Pinkesh Gajjar" => "pinkesh.gajjar@goswirl.live" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/SwirlAdmin/ios-live-stream.git", :tag => spec.version.to_s }
  spec.source_files  = "GoSwirlLiveStream/**/*.{swift}"
  spec.resources = "GoSwirlLiveStream/**/*.{png,jpeg,jpg,storyboard,xib,plist}"
  spec.resource_bundles = {'GoSwirlLiveStream' => ['GoSwirlLiveStream/**/*.{xcassets}']}
  spec.swift_version = "5.0"
  spec.static_framework = true
  spec.dependency 'FirebaseCore', '10.12.0'
  spec.dependency 'Firebase/Firestore', '10.12.0'
  spec.dependency 'IQKeyboardManagerSwift'
  spec.dependency 'TTGSnackbar'
  spec.dependency 'SDWebImage'
  
end
