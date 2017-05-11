Pod::Spec.new do |s|
  s.name = 'GraphHopperGeocoder'
  s.version = '1.0.1'
  s.license = 'MIT'
  s.homepage = 'https://github.com/rmnblm/GraphHopperGeocoder'
  s.summary = '🔍 The GraphHopper Geocoder API wrapped in an easy-to-use Swift framework. '
  s.authors = {
    'rmnblm' => 'rmnblm@gmail.com',
    'iphilgood' => 'phil.schilter@gmail.com'
  }
  s.source = {
    git: 'https://github.com/rmnblm/GraphHopperGeocoder.git',
    tag: "v#{s.version}"
  }
  s.ios.deployment_target = '8.0'
  s.source_files = 'GraphHopperGeocoder/*.swift'
end
