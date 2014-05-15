require 'optparse'
require 'optparse/time'
require 'ostruct'

module Dockerchain
  module CLI
    class OptionParser
      attr_accessor :options, :opt_parser

      def initialize
        # The options specified on the command line will be collected in *options*.
        # We set default values here.
        @options = ::OpenStruct.new
        options.chain_file = ''
        options.log_file = ''
        options.src_path = ''
        options.build_path = ''

        @opt_parser = ::OptionParser.new do |opts|
          opts.banner = 'Usage: dockerchain CHAINFILE [options]'

          opts.separator ''
          opts.separator 'Specific options:'

          opts.on('-l', '--logfile LOGFILE',
                  'Specify the LOGFILE to log output to') do |log_file|
            options.log_file = log_file
          end

          opts.on('-s', '--srcpath SRCPATH',
                  'Specify the SRCPATH for where to download repositories') do |src_path|
            options.src_path = src_path
          end

          opts.on('-b', '--buildpath BUILDPATH',
                  'Specify the BUILDPATH for where to do work') do |build_path|
            options.build_path = build_path
          end

          opts.separator ''
          opts.separator 'Common options:'

          # No argument, shows at tail.  This will print an options summary.
          # Try it and see!
          opts.on_tail('-h', '--help', 'Show this message') do
            puts opts
            exit
          end

          # Another typical switch to print the version.
          opts.on_tail('-v', '--version', 'Show version') do
            puts Dockerchain::VERSION
            exit
          end
        end

      end

      def help
        opt_parser.help
      end

      #
      # Return a structure describing the options.
      #
      def parse(args)
        begin      
          opt_parser.parse!(args)
        rescue ::OptionParser::InvalidOption => e
          puts help
          exit(1)
        end
        options
      end
    end
  end
end
