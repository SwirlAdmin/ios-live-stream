
Pod::Spec.new do |spec|

  spec.name         = "MyTestingLib"
  spec.version      = "1.0.2"
  spec.summary      = "A short description of MyTestingLib."
  spec.description  = "A short description of MyTestingLib."

  spec.homepage     = "https://github.com/SwirlAdmin/ios-live-stream"
  spec.license      = "MIT"
  spec.author       = { "Pinkesh Gajjar" => "pinkesh.gajjar@goswirl.live" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/SwirlAdmin/ios-live-stream.git", :tag => spec.version.to_s }

  spec.source_files  = "MyTestingLib/**/*.{swift}"
  spec.swift_versions = "5.0"
  
end

