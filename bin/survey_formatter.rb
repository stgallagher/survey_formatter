#!/usr/bin/env ruby
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
p "#{File.expand_path('../../lib', __FILE__)}"
require 'survey_formatter'

fs = FileScanner.new("/Users/steven/code/ncs-instruments/templates/surveys/", "/Users/steven/code/ncs-instruments/output/")

fs.process_files
