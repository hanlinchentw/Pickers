# Uncomment the next line to define a global platform for your project
 platform :ios, '14.1'

target 'FoodPicker' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FoodPicker
  pod 'Alamofire', '~> 5.6.1'
  pod 'AlamofireImage', '~> 4.1'
  pod "ImageSlideshow/Alamofire"
  pod 'ImageSlideshow', '~> 1.9.0'
  pod 'MBProgressHUD'
  pod 'RxSwift', '6.5.0'
  pod 'RxCocoa', '6.5.0'

  post_install do |installer|
   installer.pods_project.targets.each do |target|
     target.build_configurations.each do |config|
       if config.name == 'Debug'
         config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
         config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-O'
       end
     end
   end
  end
end
