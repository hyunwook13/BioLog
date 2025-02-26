platform :ios, '16.0'

inhibit_all_warnings!

target 'BioLog' do
  use_frameworks!

  pod 'RxSwift'
  pod 'RxCocoa'

  pod 'SnapKit'

  pod 'SwiftLint'

  pod 'XMLCoder'

  target 'BioLogTests' do
    inherit! :search_paths
    pod 'RxBlocking'
    pod 'RxTest'
  end

  target 'BioLogUITests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts "Installing: #{target.name}"
  end
end
