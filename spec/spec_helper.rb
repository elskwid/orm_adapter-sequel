require 'rubygems'
$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'rspec'
require 'sequel'
require 'orm_adapter' # should be installed by our rake tasks
require 'orm_adapter-sequel'