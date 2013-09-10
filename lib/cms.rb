require 'sinatra/base'
require 'mongoid'
require 'pathname'

module Cms
  def self.root
    @root ||= Pathname.new(File.expand_path('../../', __FILE__))
  end

  def self.mongoid_config_file
    @mongoid_config ||= root.join('config', 'mongoid.yml')
  end
end

Mongoid.load! Cms.mongoid_config_file

require 'cms/content'
require 'cms/user'
