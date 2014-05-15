module Dockerchain
  class Runner
    def initialize(options)
      @logger = Logger.new(options.log_file) unless options.log_file.blank?
      @src_path = Logger.new(options.src_path) unless options.src_path.blank?
      @build_path = Logger.new(options.build_path) unless options.build_path.blank?
    end

    def run(config_file = 'dockerchain.yml')
      logger.info "Removing repos from previous run"
      runcmd "rm -rf '#{src_path}'"

      logger.info "Creating #{src_path}..."
      FileUtils.mkpath(src_path)

      images = parse(config_file)

      image_name = ''

      images.each do |repo|
        previous_image_name = image_name 
        image_name = repo['image_name'] ? File.join(build_path, repo['image_name']) : ""
        repo_url = repo['repo_url'] || ""

        command = "git clone '#{repo_url}' '#{File.join(src_path, image_name)}'"
        logger.info command
        runcmd command

        logger.info "Rewriting the dockerfile for #{image_name} to point at #{previous_image_name}"
        replace_dockerfile_from(File.join(src_path, image_name, 'Dockerfile'), previous_image_name)

        command = "docker build -t #{image_name} #{File.join(src_path, image_name)}"
        logger.info command
        runcmd command
      end
    end

    private

    def logger
      @logger ||= Dockerchain.logger
    end

    def src_path
      @src_path ||= Dockerchain.src_path
    end

    def build_path
      @build_path ||= Dockerchain.build_path
    end

    def parse(config_file)
      YAML.load(File.read(config_file))
    end

    def runcmd(command = '')
      `#{command}`

      if $? != 0
        logger.error "Command returned #{$?}. Exiting..."
        Kernel.exit
      end
    end

    def update_from_node!(tree, previous_build)
      if tree.elements.nil?
        return
      else
        tree.elements.each do |element|
          if element.respond_to?(:title) && element.title == :from
            logger.info "Found the FROM instruction, updating #{element.inspect} to #{previous_build}"
            # Not the right way to do this
            string_literal = element.elements[0]
            string_literal.instance_variable_set(:@input, previous_build)
            string_literal.instance_variable_set(:@interval, 0..previous_build.size)
          else
            update_from_node!(element, previous_build)
          end
        end
      end
    end

    def replace_dockerfile_from(filename, previous_build = '')
      dockerfile = File.read(filename)

      if !previous_build.blank?
        parser = DockerfileAst::Parser.new
        ast = parser.parse(dockerfile)
        update_from_node!(ast, previous_build)
        writer = DockerfileAst::Writer.new(ast)

        File.open(filename, 'w') do |file|
          logger.info "Rewriting the dockerfile"
          file.write writer.write
        end
      else
        logger.info "Not changing the Dockerfile because no previous build was found"
      end
    end
  end
end
