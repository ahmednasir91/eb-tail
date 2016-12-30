Gem::Specification.new do |s|
  s.name        = 'eb-tail'
  s.version     = '0.0.2'
  s.date        = '2016-12-30'
  s.summary     = "Tail Elasticbeanstalk Logs easily!"
  s.description = "Makes it easy to tail Elasticbeanstalk logs"
  s.authors     = ["Ahmed Nasir"]
  s.email       = 'ahmednasir91@gmail.com'
  s.executables << 'eb-tail'
  s.files       = ["lib/eb-tail.rb", "lib/eb-tail/environment.rb", "lib/eb-tail/server.rb", "config/sample.config.yml"]
  s.homepage    =
    'http://rubygems.org/gems/eb-tail'
  s.license       = 'MIT'
end
