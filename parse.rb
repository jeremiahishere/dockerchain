require 'yaml'
require 'logger'
require 'fileutils'
require 'debugger'

$logger = Logger.new(STDOUT)

SRC_PATH='repos'
BUILD_PATH='dockerchain'

$logger.info "Creating #{SRC_PATH}..."
FileUtils.mkpath(SRC_PATH)

images = YAML.load(File.read(ARGV[0]))
images.each do |image_name, repo_url|
  $logger.info "git clone '#{repo_url}' '#{File.join(SRC_PATH, image_name)}'"
  `git clone '#{repo_url}' '#{File.join(SRC_PATH, image_name)}'`

  if $? != 0
    $logger.error "Command returned #{$?}. Exiting..."
    Kernel.exit
  end

  $logger.info "docker build -t '#{File.join(BUILD_PATH, image_name)}' '#{File.join(SRC_PATH, image_name, 'Dockerfile')}"
  #`docker build -t '#{File.join(BUILD_PATH, image_name)}' '#{File.join(SRC_PATH, image_name, 'Dockerfile')}`
end
