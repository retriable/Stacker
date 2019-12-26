Pod::Spec.new do |spec|
    spec.name     = 'Stacker'
    spec.version  = '1.0.0'
    spec.license  = 'MIT'
    spec.summary  = 'custom navigation controller'
    spec.homepage = 'https://github.com/retriable/Stacker'
    spec.author   = { 'retriable' => 'retriable@retriable.com' }
    spec.source   = { :git => 'https://github.com/retriable/Stacker.git',:tag => "#{spec.version}" }
    spec.description = 'Custom navigation controller.'
    spec.requires_arc = true
    spec.source_files = 'Stacker/*.{h,m}'
    spec.ios.frameworks = 'UIKit'
    spec.ios.deployment_target = '8.0'
end
