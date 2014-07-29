Pod::Spec.new do |s|
  s.name         = "SSuggestText"
  s.version      = "0.1"
  s.summary      = "Suggest text field with tag support."

  s.description     = <<-DESC
                        SSuggestText
                      DESC
  s.homepage     = "https://github.com/saulogt/SSuggestText"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Saulo Tauil" => "saulo@tauil.com" }
  s.source       = { 
    :git => "https://github.com/saulogt/SSuggestText.git", 
    :tag => "0.1"
  }

  s.platform     = :ios, '7.0'
  s.source_files = 'SSuggestText/*.{h,m}'
  s.requires_arc = true
end

