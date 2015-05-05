Pod::Spec.new do |s|
  s.name         = "SilverbackFramework"
  s.version      = "0.1.0"
  s.summary      = "Silverback Swift extensions and modules."
  s.homepage     = "https://github.com/cotkjaer/SilverbackFramework"
  s.license      = 'MIT'
  s.author       = { "christian otkjær" => "christian.otkjaer@gmail.com" }
  s.source       = { :git => "https://github.com/cotkjaer/SilverbackFramework.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'SilverbackFramework/*.{h,swift}'
  s.frameworks   = 'UIKit', 'Foundation', 'CoreGraphics', 'CoreData'
end