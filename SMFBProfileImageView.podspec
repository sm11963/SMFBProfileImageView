#
# Be sure to run `pod lib lint SMFBProfileImageView.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SMFBProfileImageView"
  s.version          = "0.1.0"
  s.summary          = "A replacement class for FBProfilePictureView part of the Facebook iOS SDK."
  s.description      = <<-DESC
                       Provides a simple and convient way to display profile
		       
		       **Added features to FBProfilePictureView**
                       * Uses AFNetworking to download images and provide caching
                       DESC
  s.homepage         = "https://github.com/sm11963/SMFBProfileImageView"
  s.license          = { :type => "Apache 2.0", :file => "LICENSE" }
  s.author           = { "Sam Miller" => "sm11963@gmail.com" }
  s.source           = { :git => "https://github.com/sm11963/SMFBProfileImageView.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.1'
  s.requires_arc = true

  s.source_files = "Pod/Classes","Pod/Classes/*.{h,m}"
  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Facebook-iOS-SDK', '~> 3.22'
end
