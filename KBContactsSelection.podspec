Pod::Spec.new do |s|

  s.name         = "KBContactsSelection"
  s.version      = "1.2.3"
  s.summary      = "Standalone UI component to search and select contacts."

  s.description  = <<-DESC
				   KBContactsSelection is a standalone UI and logic component that allows you to easily search 
				   and select contacts in your Address Book and redirect to Mail or Messages with results.
                   DESC

  s.homepage     = "https://github.com/burczyk/KBContactsSelection"
  s.screenshots  = "https://raw.githubusercontent.com/burczyk/KBContactsSelection/master/assets/KBContactsSelection.png"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Kamil Burczyk" => "kamil.burczyk@gmail.com" }
  s.social_media_url   = "http://twitter.com/KamilBurczyk"

  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/burczyk/KBContactsSelection.git", :tag => "1.2.3" }

  s.source_files  = "KBContactsSelection", "KBContactsSelection/**/*.{h,m}"
  s.resources = "KBContactsSelection/*.xib"
  s.framework  = "MessageUI"
  s.requires_arc = true
  s.dependency "APAddressBook", "~> 0.1"

end
