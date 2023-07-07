Pod::Spec.new do |spec|

  spec.name         = "WriteMyName"
  spec.version      = "1.0.5"
  spec.summary      = "This is the best framework."
  spec.description  = "This is the best framework."
  
  spec.homepage     = "https://github.com/SwirlAdmin/ios-live-stream/WriteMyName"
  spec.license      = "MIT"
  spec.author       = { "Pinkesh Gajjar" => "pinkesh.gajjar@goswirl.live" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/SwirlAdmin/ios-live-stream.git", :tag => spec.version.to_s }
  spec.source_files  = "WriteMyName/**/*.{swift}"
  spec.swift_version = "5.0"
end
