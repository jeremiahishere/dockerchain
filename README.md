# Dockerchain

Run a series of dockerfiles, chaining the output of one into the next

## Installation

## Usage

## How it works

1. Write a yaml file if records that look like this

- image_name: sshable
  repo_url: https://github.com/imightbeinatree/docker-sshable.git

2. install the dockerfile_ast gem located at git@github.com:jeremiahishere/dockerfile_ast.git

3. Parse the yaml file and loop through the repos

3a. clone the first repo into the repos directory
3b. run `docker build -e dockerchain/1` on the dockerfile in the directory
3c. go to the next directory
3d. run the dockerfile ast parser
3e. change the from node to point at dockerchain/1
3f. output the updated dockerfile
3g. run `docker build -e dockerchain/2` on the new dockerfile
3h. repeat e through g on all of the repos in the yaml file, incrementing the build number on each one

## Contributing

1. Fork it ( http://github.com/<my-github-username>/dockerfile_ast/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
