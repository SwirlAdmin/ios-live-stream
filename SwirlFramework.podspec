

Pod::Spec.new do |spec|

  spec.name         = "SwirlFramework"
  spec.version      = "1.0.0"
  spec.summary      = "A short description of SwirlFramework."
  spec.description  = "A short description of SwirlFramework."
  spec.homepage     = "https://github.com/SwirlAdmin/ios-live-stream"
  spec.license      = "MIT"
  spec.author       = { "Pinkesh Gajjar" => "pinkesh.gajjar@goswirl.live" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/SwirlAdmin/ios-live-stream.git", :tag => spec.version.to_s }
  spec.source_files  = "SwirlFramework/**/*"
  spec.swift_version = "5.0"

end
