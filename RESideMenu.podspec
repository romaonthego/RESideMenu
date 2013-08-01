Pod::Spec.new do |s|
  s.name        = 'RESideMenu'
  s.version     = '2.0'
  s.authors     = { 'Roman Efimov' => 'romefimov@gmail.com' }
  s.homepage    = 'https://github.com/romaonthego/RESideMenu'
  s.summary     = 'iOS 7 style side menu.'
  s.source      = { :git => 'https://github.com/romaonthego/RESideMenu.git',
                    :tag => '2.0' }
  s.license     = { :type => "MIT", :file => "LICENSE" }

  s.platform = :ios, '6.0'
  s.requires_arc = true
  s.source_files = 'RESideMenu'
  s.public_header_files = 'RESideMenu/*.h'

  s.ios.deployment_target = '6.0'
  s.ios.frameworks = 'QuartzCore'
end
