

Pod::Spec.new do |spec|

  spec.name         = "MaccoValidator"
  spec.version      = "1.0.1"
  spec.summary      = "A short description of MaccoValidator."
  spec.description  = "A short description of MaccoValidator."

  spec.homepage     = "https://github.com/SwirlAdmin/ios-live-stream"
  spec.license      = "MIT"
  spec.author       = { "Pinkesh Gajjar" => "pinkesh.gajjar@goswirl.live" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/SwirlAdmin/ios-live-stream.git", :tag => spec.version.to_s }

  spec.source_files  = "MaccoValidator/**/*.{swift}"
  spec.swift_versions = "5.0"
  
end
