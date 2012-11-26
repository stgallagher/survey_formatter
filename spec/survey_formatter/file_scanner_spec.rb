require 'spec_helper'
require 'fileutils'

module SurveyFormatter
  describe FileScanner do
    before(:all) do
      fixtures_source = "/Users/steven/code/ruby/survey_formatter/fixtures/"
      output = "/Users/steven/code/ruby/survey_formatter/output/"
      @fs = FileScanner.new(fixtures_source, output)
      @input_filename = ["spec/fixtures/test_survey.rb"]
    end

    it "should have a source and a destination directory" do
       @fs.source.should == "/Users/steven/code/ruby/survey_formatter/fixtures/"
       @fs.destination.should == "/Users/steven/code/ruby/survey_formatter/output/"
    end

    it "comments out dependency rules" do
      unfiltered1 = "     dependency :rule=>\"A\" "
      filtered1   = "     #dependency :rule=>\"A\" "
      @fs.comment_out_dependency_rules(unfiltered1).should == filtered1

      unfiltered2 = "     dependency :rule => \"A\" "
      filtered2   = "     #dependency :rule => \"A\" "
      @fs.comment_out_dependency_rules(unfiltered2).should == filtered2
    end

    it "doesn't comment out dependencies that are already commented out" do
      already_commented1   = "     #dependency :rule => \"A\" "
      already_commented2   = "     #dependency :rule => \"A\" "
      @fs.comment_out_dependency_rules(already_commented1).should == already_commented2
    end

    it "comments out conditions" do
      unfiltered = "     condition_A :q_BLOOD_INTRO, \"==\", :a_1 "
      filtered   = "     #condition_A :q_BLOOD_INTRO, \"==\", :a_1 "
      @fs.comment_out_conditions(unfiltered).should == filtered
    end

    it "doesn't comment out conditions that are already commented out" do
      already_commented1   = "     #condition_A :q_BLOOD_INTRO, \"==\", :a_1 "
      already_commented2   = "     #condition_A :q_BLOOD_INTRO, \"==\", :a_1 "
      @fs.comment_out_conditions(already_commented1).should == already_commented2
    end

    it "doesn't get confused at text matches that are close"  do
      potentially_confusing       = "q_enter_condition_oth \"Can you please specify the other serious conditions? \", :pick=>:one,"
      potentially_confusing_final = "q_enter_condition_oth \"Can you please specify the other serious conditions? \", :pick=>:one,"
      @fs.comment_out_conditions(potentially_confusing).should == potentially_confusing_final
    end

    it "processes all ruby files" do
      @fs.process_files.should_not == nil
    end
  end
end
