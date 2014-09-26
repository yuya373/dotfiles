#!/usr/bin/env ruby

require 'uri'

if ARGV.size != 1
  fail ArgumentError, "Set directory path like $HOME/.rbenv/versions/2.1.1/"
end

methods = []
Dir.glob(File.expand_path(ARGV[0]) + "/**/*.ri").each do |file|
  method = URI.decode(File.basename(file))

  if /\A(.*)-\w*\.ri\Z/ =~ method
    methods << $1
  end
end

methods.uniq.sort.each do |method|
  puts method unless method.size == 1
end
