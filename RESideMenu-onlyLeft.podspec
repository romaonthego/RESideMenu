Pod::Spec.new do |s|
  s.name        = 'RESideMenu-onlyLeft'
  s.version     = '4.0.8'
  s.authors     = { 'Jongsu Park' => 'pjs7678@gmail.com' }
  s.homepage    = 'https://github.com/pjs7678/RESideMenu'
  s.summary     = 'RESideMenu with right panning option.'
  s.source      = { :git => 'https://github.com/pjs7678/RESideMenu.git',
                    :tag => s.version.to_s }
  s.license     = { :type => "MIT", :file => "LICENSE" }

  s.platform = :ios, '6.0'
  s.requires_arc = true
  s.source_files = 'RESideMenu'
  s.public_header_files = 'RESideMenu/*.h'

  s.ios.deployment_target = '6.0'
  s.ios.frameworks = 'QuartzCore'
end
