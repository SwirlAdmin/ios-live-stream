Pod::Spec.new do |spec|

  spec.name         = "WriteMyName"
  spec.version      = "1.2.3"
  spec.summary      = "This is the best framework."
  spec.description  = "This is the WriteMyName framework."
  
  spec.homepage     = "https://github.com/SwirlAdmin/ios-live-stream/WriteMyName"
  spec.license      = "MIT"
  spec.author       = { "Pinkesh Gajjar" => "pinkesh.gajjar@goswirl.live" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/SwirlAdmin/ios-live-stream.git", :tag => spec.version.to_s }
  spec.source_files  = "WriteMyName/**/*.{swift}"
  spec.resources = "WriteMyName/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,plist}"
  spec.swift_version = "5.0"
  spec.static_framework = true
  spec.dependency 'FirebaseCore', '10.11.0'
  spec.dependency 'Firebase/Firestore', '10.11.0'
end
