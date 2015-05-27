# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

require 'rubygems'
require 'motion-yaml'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'CoolFace'
  app.icon = 'face.icns'
  app.frameworks << 'Carbon'
  app.vendor_project 'vendor/DDHotKey', :static, :cflags => '-fobjc-arc'
  app.vendor_project 'vendor/NSAttributedString+Hyperlink', :static, :cflags => '-fobjc-arc'
  app.info_plist['LSUIElement'] = true
  app.version = '0.0.8'
end
