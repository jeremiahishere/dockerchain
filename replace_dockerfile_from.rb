require 'dockerfile_ast'

def update_from_node!(tree, previous_build)
  if tree.elements.nil?
    return
  else
    tree.elements.each do |element|
      if element.respond_to?(:title) && element.title == :from
        puts "Found the FROM instruction, updating #{element.inspect} to #{previous_build}"
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

if ARGV.empty?
  puts "This should be called with this syntax: ruby replace_dockerfile_from.rb /path/to/Dockerfile"
  exit
end

filename = ARGV[0]
dockerfile = File.read(filename)
previous_build = ARGV[1] || nil

if previous_build
  parser = DockerfileAst::Parser.new
  ast = parser.parse(dockerfile)
  update_from_node!(ast, previous_build)
  writer = DockerfileAst::Writer.new(ast)


  File.open(filename, 'w') do |file|
    puts "Rewriting the dockerfile"
    file.write writer.write
  end
else
  puts "Not changing the Dockerfile because no previous build was found"
end

