#!/usr/bin/env ruby

BASE_REPO_ROOT = "git@github.com:joaotorres"
BASE_REPO_NAME = "time-manager"

def repo_address(name, root = BASE_REPO_ROOT)
  root + '/' + name + '.git'
end

new_repo_name = "new_repo_#{ARGV.first}"

puts "** Cloning github repository"
`git clone #{repo_address(BASE_REPO_NAME)} #{new_repo_name}`

Dir.chdir(new_repo_name)

puts "** Creating new github reposity"
`hub create`

puts "** Point new repo to proper remote"
`git remote set-url origin #{repo_address(new_repo_name)}`

puts "** Push code to github"
`git push`