Pod::Spec.new do |spec|

  spec.name         = "SwirlFramework"
  spec.version      = "1.3.1"
  spec.summary      = "This is the best framework."
  spec.description  = "This is the SwirlFramework framework."
  
  spec.homepage     = "https://github.com/SwirlAdmin/ios-live-stream/SwirlFramework"
  spec.license      = "MIT"
  spec.author       = { "Pinkesh Gajjar" => "pinkesh.gajjar@goswirl.live" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/SwirlAdmin/ios-live-stream.git", :tag => spec.version.to_s }
  spec.source_files  = "SwirlFramework/**/*.{swift}"
  spec.resources = "SwirlFramework/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,plist}"
  spec.swift_version = "5.0"
  spec.static_framework = true
  spec.dependency 'FirebaseCore', '10.11.0'
  spec.dependency 'Firebase/Firestore', '10.11.0'
end
