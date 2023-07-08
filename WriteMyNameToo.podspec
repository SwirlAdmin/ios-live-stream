Pod::Spec.new do |spec|

  spec.name         = "WriteMyNameToo"
  spec.version      = "1.0.7"
  spec.summary      = "This is the best framework."
  spec.description  = "This is the WriteMyNameToo framework."
  
  spec.homepage     = "https://github.com/SwirlAdmin/ios-live-stream/WriteMyNameToo"
  spec.license      = "MIT"
  spec.author       = { "Pinkesh Gajjar" => "pinkesh.gajjar@goswirl.live" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/SwirlAdmin/ios-live-stream.git", :tag => spec.version.to_s }
  spec.source_files  = "WriteMyNameToo/**/*.{swift}"
  spec.swift_version = "5.0"
end
