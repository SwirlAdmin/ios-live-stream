
Pod::Spec.new do |spec|

  spec.name         = "PinkeshMGajjar"
  spec.version      = "1.0.3"
  spec.summary      = "A short description of PinkeshMGajjar."
  spec.description  = "A short description of PinkeshMGajjar."

  spec.homepage     = "https://github.com/SwirlAdmin/ios-live-stream"
  spec.license      = "MIT"
  spec.author       = { "Pinkesh Gajjar" => "pinkesh.gajjar@goswirl.live" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/SwirlAdmin/ios-live-stream.git", :branch => "main", :tag => spec.version.to_s }

  spec.source_files  = "PinkeshMGajjar/**/*.{swift}"
  spec.swift_versions = "5.0"
  
end
