platform :ios, '16.0'

inhibit_all_warnings!

project 'BioLog.xcodeproj' 

target 'BioLog' do
  use_frameworks!

  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxViewController'
  pod 'RxDataSources'  
  pod 'SnapKit'

  pod 'SwiftLint'

  target 'BioLogTests' do
    inherit! :search_paths
    pod 'RxBlocking'
    pod 'RxTest'
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts "Installing: #{target.name}"
  end
end
