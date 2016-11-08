require "ansible_qa/version"
require "ansible_qa/checks/base_check"
require "ansible_qa/checks/Gemfile"
require "ansible_qa/checks/Ackrc"
require "ansible_qa/checks/Gitignore"
require "ansible_qa/checks/Jenkinsfile"
require "ansible_qa/checks/Hier"
require "ansible_qa/checks/travis"
require "ansible_qa/checks/meta_main_yml"

module AnsibleQA
  class Base

    def self.new
    end

    def self.check
      gemfile = AnsibleQA::Checks::Gemfile.new('Gemfile')
      gemfile.check
    end

    def self.root_dir(path = nil)
      @root_dir = path if path
      @root_dir
    end

    def self.tmp_root_dir(path = nil)
      @tmp_root_dir = path if path
      @tmp_root_dir
    end

  end

end
