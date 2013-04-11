require 'rubygems'
require 'bundler'

Bundler.require

require './main'

use Rack::Deflater

run MemeTubeApp
