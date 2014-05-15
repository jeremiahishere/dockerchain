require 'dockerchain/version'
require 'dockerchain/runner'

require 'yaml'
require 'logger'
require 'fileutils'
require 'dockerfile_ast'

# This is a global. Deal with it.
def blank?(var)
  var.nil? || var.empty?
end

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
