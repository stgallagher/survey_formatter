require 'spec_helper'
require 'fileutils'

module SurveyFormatter
  describe FileScanner do
    before(:all) do
      fixtures_source = "/Users/steven/code/ruby/survey_formatter/fixtures/"
      output = "/Users/steven/code/ruby/survey_formatter/output/"
      @fs = FileScanner.new(fixtures_source, output)
      @input_filename = ["spec/fixtures/test_survey.rb"]
      File.open("/Users/steven/code/ruby/survey_formatter/output/correct_test_survey.rb", "r") { |file| @output_file = file.readlines }
      File.open("/Users/steven/code/ruby/survey_formatter/output/correct_test_survey.rb", "r") { |file| @final_output = file.read }
    end

    it "should have a source and a destination directory" do
       @fs.source.should == "/Users/steven/code/ruby/survey_formatter/fixtures/"
       @fs.destination.should == "/Users/steven/code/ruby/survey_formatter/output/"
    end

    it "should get files" do
      @fs.ruby_files.should include("spec/fixtures/INS_BIO_AdultBlood_DCI_EHPBHI_P2_V10.rb")
    end

    it "comments out dependency rules" do
      unfiltered = "     dependency :rule=>\"A\" "
      filtered   = "     #dependency :rule=>\"A\" "
      @fs.comment_out_dependency_rules(unfiltered).should == filtered
    end

    it "comments out conditions" do
      unfiltered = "     condition_A :q_BLOOD_INTRO, \"==\", :a_1 "
      filtered   = "     #condition_A :q_BLOOD_INTRO, \"==\", :a_1 "
      @fs.comment_out_conditions(unfiltered).should == filtered
    end

    it "doesn't get confused at text matches that are close"  do
      potentially_confusing       = "q_enter_condition_oth \"Can you please specify the other serious conditions? \", :pick=>:one,"
      potentially_confusing_final = "q_enter_condition_oth \"Can you please specify the other serious conditions? \", :pick=>:one,"
      @fs.comment_out_conditions(potentially_confusing).should == potentially_confusing_final
    end

    it "changes files" do
      @fs.change_files(@input_filename).should ==["spec/fixtures/test_survey.rb"]
    end

    it "produces a document that looks exactly the same as the original, just with the proper things commented out" do
      @fs.finalize_output(@output_file).should == @final_output
    end

    it "processes all ruby files" do
      @fs.process_files.should_not == nil
    end
  end
end
