#
#  Be sure to run `pod spec lint CooeeSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

spec.name         = "cooee_plugin"
spec.version      = "0.0.9"
spec.summary      = "Hyper-personalised Mobile App Re-Engagement via Machine Learning"
spec.description  = "Hyper-personalised Mobile App Re-Engagement via Machine Learning"

spec.homepage     = "https://github.com/letscooee/cooee-ios-sdk"
spec.author       = { "Surbhi Lath" => "surbhibagadia.21@gmail.com" }
spec.source       = { :path => '.' }

spec.vendored_frameworks = "Class/**/*"
spec.platform = :ios
spec.swift_version = "5.0"
spec.license = "MIT"
spec.dependency               'Flutter'
spec.dependency               'CooeeSDK','~>1.2.1'
spec.ios.deployment_target  = '13.0'

end
