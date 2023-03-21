
Pod::Spec.new do |spec|

  spec.name         = "MyTestLib"
  spec.version      = "1.0.2"
  spec.summary      = "A short description of MyTestLib."
  spec.description  = "A short description of MyTestLib."

  spec.homepage     = "https://github.com/SwirlAdmin/ios-live-stream"
  spec.license      = "MIT"
  spec.author       = { "Pinkesh Gajjar" => "pinkesh.gajjar@goswirl.live" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/SwirlAdmin/ios-live-stream.git", :commit => "0d6761feefccff1f7d8b7c7788ceb8e9cd1314ea" }

  spec.source_files  = "MyTestLib/**/*.{swift}"
  spec.swift_versions = "5.0"
  
end
