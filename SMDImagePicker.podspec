Pod::Spec.new do |s|

  s.name = "SMDImagePicker"
  s.version = "1"
  s.summary = "A UIImagePickerController wrapper."

  s.description = <<-DESC
                   UIImagePickerController Block-based wrapper.
                   DESC

  s.homepage = "https://github.com/gajjartejas/SMDImagePicker"
  s.screenshots = "https://github.com/gajjartejas/SMDImagePicker/blob/master/Screenshots/logo.png?raw=true"

  s.license = { :type => "MIT", :file => "LICENSE" }

  s.author = { "gajjartejas" => "gajjartejas26@gmail.com" }
  s.social_media_url = "https://www.linkedin.com/in/gajjartejas/"

  s.platform = :ios, '8.0'
  s.source = {
    :git => "https://github.com/gajjartejas/SMDImagePicker.git",
    :tag => "v#{s.version.to_s}"
  }

  s.source_files = "SMDImagePicker", "SMDImagePicker/**/*.swift"
  s.requires_arc = true

end
