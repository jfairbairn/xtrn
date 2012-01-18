require File.dirname(__FILE__) + '/lib/xtrn/version'
Gem::Specification.new do |s|
  s.name = 'xtrn'
  s.summary = 'Manage your externals without locking yourself into a single source control system.'
  s.authors = ['James Fairbairn', 'Gavin Sandie']
  s.email = %w(james@mediamolecule.com gavin@mediamolecule.com)
  s.version = Xtrn::VERSION

  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files bin`.split("\n").map{|i|i.sub(/^bin\//, '')}

  s.add_development_dependency 'rspec', '~> 2.8'
  s.add_development_dependency 'autotest', '~> 4.4'

end

