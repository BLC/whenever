require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class JobSequenceTest < Test::Unit::TestCase
  context "creating sequential jobs" do
    setup do
      @path = "/my/path"
    end
  
    should "produce a single job with task unchanged" do
      sequence = Whenever::JobSequence.new
      sequence << Whenever::Job::Default.new(:task => "my_task", :path => @path)
      assert_equal sequence.to_single_job.output, "my_task"
    end
  
    context "with dependent sequences" do
      should "concatenate multiple jobs with && operator" do
        sequence = Whenever::JobSequence.new
        sequence << Whenever::Job::Default.new(:task => "first_task", :path => @path)
        sequence << Whenever::Job::Default.new(:task => "second_task", :path => @path)
    
        assert_equal sequence.to_single_job.output, "first_task && second_task"
      end
    end
    
    context "with independent sequences" do
      should "concatenate multiple jobs with ;" do
        sequence = Whenever::JobSequence.new(:dependent => false)
        sequence << Whenever::Job::Default.new(:task => "first_task", :path => @path)
        sequence << Whenever::Job::Default.new(:task => "second_task", :path => @path)
    
        assert_equal sequence.to_single_job.output, "first_task; second_task"
      end
    end
  end
end