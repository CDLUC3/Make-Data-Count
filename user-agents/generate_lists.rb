#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require 'yaml'


list_dir = File.join(File.expand_path(File.dirname(__FILE__)), 'lists')

all_items = YAML.load_file(File.join(list_dir, 'classified-list.yaml'))

all_items.each do |k, v|
  File.open(File.join(list_dir, "#{k}.txt"), "w:UTF-8") do |file|
    file.puts('# this file is generated from a master file, please modify that list and regenerate the text files with the generate_lists.rb script')
    v.each do |i|
      file.puts(i['pattern'])
    end
  end
end
