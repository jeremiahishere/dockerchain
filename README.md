# Dockerchain

Run a series of dockerfiles, chaining the output of one into the next

## Installation

    git clone git@github.com:jeremiahishere/dockerchain.git
    cd dockerchain
    bundle install

If necessary, clone git@github.com:jeremiahishere/dockerfile_ast.git and
manually install it.

## Usage

write a yml file similar to sshable.yml.  The script will automatically prepend the image_name field with 'dockerchain/'.  The repos should have a Dockerfile in their root directory and must be available to the current user.

run `bundle exec dockerchain path/to/my_config_file.yml`

## How it works

1. Write a yaml file if records that look like this

         - image_name: sshable
           repo_url: https://github.com/imightbeinatree/docker-sshable.git

2. Install the `dockerfile_ast` gem located at http://github.com/jeremiahishere/dockerfile_ast

3. Parse the yaml file and loop through the repos

    1. clone the first repo into the repos directory
    2. run `docker build -t dockerchain/<image_name>` on the dockerfile in the directory
    3. go to the next directory
    4. run `ruby replace_dockerfile_from.rb /path/to_dockerfile previous_build_name` on the Dockerfile in the repo
    5. run `docker build -e dockerchain/<second_image_name>` on the new dockerfile
    6. repeat 3.1 through 3.5 on all of the repos in the yaml file, changing the image name for each one

## Contributing

1. Fork it ( http://github.com/<my-github-username>/dockerchain/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
