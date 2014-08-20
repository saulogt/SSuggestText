#
# Be sure to run `pod lib lint SSuggestText.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SSuggestText"
  s.version          = "0.1.02"
  s.summary          = "SSuggestText shows suggest on typing and creates tag based on configuraton."
  s.description      = <<-DESC
                       SSuggestText full description TBD...
                       DESC
  s.homepage         = "https://github.com/saulogt/SSuggestText"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "saulogt" => "saulogt@hotmail.com" }
  s.source           = { :git => "https://github.com/saulogt/SSuggestText.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/saulogt'

  s.platform     = :ios, '7.0'
  s.requires_arc = true		

  s.source_files = 'Pod/Classes'
  s.resources = 'Pod/Assets/SSuggestText.xcassets/*/*.{png,json}'

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
