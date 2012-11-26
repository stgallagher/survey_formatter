require 'fileutils'
require 'pathname'

module SurveyFormatter
  class FileScanner

    attr_accessor :destination
    def initialize(source, destination)
      @source = source
      @destination = destination
      @ruby_files = Dir[File.join("**", "spec", "**", "fixtures", "*.rb")]
    end

    def source
      @source
    end

    def source=(source)
      @source = source
      @file_changer.filename= source
      @ruby_files = Dir["#{@source}/**/*.rb"]
    end

    def pass_file_to_changer(filename)
      @file_changer.filename= filename
    end

    def ruby_files
      @ruby_files
    end

    def comment_out_dependency_rules(line)
      unless line =~ /#dependency :rule=>/ || line =~ /#dependency :rule =>/
        line.gsub!("dep", "#dep") if line =~ /dependency :rule=>/
        line.gsub!("dep", "#dep") if line =~ /dependency :rule =>/
      end
      line
    end

    def comment_out_conditions(line)
      unless line =~ /#condition_[A-Z]/
        line.gsub!("con", "#con") if line =~ /condition_[A-Z]/
      end
      line
    end

    def comment_out_stuff(line)
      line = comment_out_dependency_rules(line)
      line = comment_out_conditions(line)
      line
    end

    def finalize_output(file)
      file.join(",").gsub("\n,", "\n")
    end

    def change_files(files)
      output = []
      filtered = []

      files.each do |filename|

        fn = Pathname.new(filename)
        File.open("#{File.expand_path(fn)}", "r+") do |file|
          output = file.readlines
          output.each do |line|
            filtered << comment_out_stuff(line)
          end
        end

        File.open("#{File.expand_path("output/#{fn.basename}")}", "w+") do |file|
          file.write(finalize_output(filtered))
        end
      filtered = []
      output = []
      end
    end

    def process_files
      change_files(@ruby_files)
    end

  end
end
