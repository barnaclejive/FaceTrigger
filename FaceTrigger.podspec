Pod::Spec.new do |s|
  s.name             = 'FaceTrigger'
  s.version          = '1.0.1'
  s.summary          = 'Easily use ARKit to detect facial gestures'
 
  s.description      = <<-DESC
FaceTrigger is a simple to use class that hides the details of using ARKit's ARSCNView to recognize facial gestures via ARFaceAnchor.BlendShapeLocations 
                       DESC
 
  s.homepage         = 'https://github.com/rsrbk/SmileToUnlock.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author           = { 'Michael Peterson' => 'barnaclejive@gmail.com' }
  s.source           = { :git => 'https://github.com/barnaclejive/FaceTrigger.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '11.0'
  s.source_files = 'FaceTrigger/**/*.swift'
end
