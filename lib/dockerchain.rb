require 'dockerchain/version'
require 'dockerchain/runner'

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

  def self.logger
    @@logger ||= Logger.new(STDOUT)
  end
end
