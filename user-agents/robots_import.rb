#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require 'json'
require 'yaml'
require 'fileutils'

$stdout.sync = true

# function to get a 'm', 'r' or 'u' character and not accepting others
def mru_char
  while c = STDIN.getch
    return c if ['m', 'r', 'u', "\cC"].include?(c) # "\cC" is CTRL-C
  end
end

this_dir = File.expand_path(File.dirname(__FILE__))

# get the mixed lists of robots and machine user-agents and random crap from external
response = RestClient.get('https://raw.githubusercontent.com/atmire/COUNTER-Robots/master/COUNTER_Robots_list.json')
external_items = JSON.parse(response)

# create directory and parse in the existing yaml file if it exists (or set default hash)
FileUtils.mkdir_p(File.join(this_dir, 'lists'))
all_yaml = File.join(this_dir, 'lists/classified-list.yaml')
if File.exist?(all_yaml)
  existing = YAML.load_file(all_yaml)
else
  existing = {'machine' => [], 'robot' => [], 'unclassified' => []}
end

# a lookup array of just the patterns to match against
flat_patterns = (existing['machine'] + existing['robot'] + existing['unclassified']).map{|i| i['pattern'] }

# add any new patterns from external JSON file into the hash and classify them
char_to_key = {'m' => 'machine', 'r' => 'robot', 'u' => 'unclassified'}
external_items.each do |item|
  unless flat_patterns.include?(item['pattern'])
    print "#{item['pattern']}\r\n   ^ Pattern is (m)achine, (r)obot or (u)nknown (or CTRL-C)? "
    c = mru_char
    break if c == "\cC" # CTRL-C
    puts "#{char_to_key[c]}\r\n\r\n"
    existing[char_to_key[c]].push(item)
  end
end

puts 'Writing updated list of patterns'
File.open(all_yaml, 'w') {|f| f.write(YAML.dump(existing)) }
