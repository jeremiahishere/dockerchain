require 'dockerchain/version'

require 'yaml'
require 'logger'
require 'fileutils'
require 'dockerfile_ast'

module Dockerchain
  def self.src_path
    'repos'
  end

  def self.build_path
    'dockerchain'
  end

  def logger
    @@logger ||= Logger.new(STDOUT)
  end
end
