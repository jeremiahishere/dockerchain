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

image_name = ""

images.each do |repo|
  previous_image_name = image_name 
  image_name = repo['image_name'] ? "dockerchain/#{repo['image_name']}" : ""
  repo_url = repo['repo_url'] || ""

  $logger.info "git clone '#{repo_url}' '#{File.join(SRC_PATH, image_name)}'"
  `git clone '#{repo_url}' '#{File.join(SRC_PATH, image_name)}'`

  if $? != 0
    $logger.error "Command returned #{$?}. Exiting..."
    Kernel.exit
  end

  $logger.info "Rewriting the dockerfile for #{image_name} to point at #{previous_image_name}"
  `ruby replace_dockerfile_from.rb #{File.join(SRC_PATH, image_name, 'Dockerfile')} #{previous_image_name}`

  $logger.info "docker build -t '#{File.join(BUILD_PATH, image_name)}' '#{File.join(SRC_PATH, image_name, 'Dockerfile')}'"
  #`docker build -t '#{File.join(BUILD_PATH, image_name)}' '#{File.join(SRC_PATH, image_name, 'Dockerfile')}`
end
