require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class InSequenceTest < Test::Unit::TestCase
  context "A pair of tasks in the same time block that should be executed in a dependent sequence" do
    setup do
      @output = Whenever.cron \
      <<-file
        set :path, '/my/path'
        every 2.hours do
          in_sequence do
            cap "first_task"
            rake "second_task"
          end
        end
      file
    end
    
    should "output the pair of tasks using &&" do
      assert_match 'cd /my/path && RAILS_ENV=production /usr/bin/env cap first_task && cd /my/path && RAILS_ENV=production /usr/bin/env rake second_task', @output
    end
  end
  
  context "A pair of tasks in the same time block that should be executed in a independent sequence" do
    setup do
      @output = Whenever.cron \
      <<-file
        set :path, '/my/path'
        every 2.hours do
          in_sequence(:dependent => false) do
            cap "first_task"
            rake "second_task"
          end
        end
      file
    end
    
    should "output the pair of tasks using ;" do
      assert_match 'cd /my/path && RAILS_ENV=production /usr/bin/env cap first_task; cd /my/path && RAILS_ENV=production /usr/bin/env rake second_task', @output
    end
  end
  
  context "A set of tasks in the same time block that should be grouped and by their sequence" do
    setup do
      @output = Whenever.cron \
      <<-file
        set :path, '/my/path'
        every 2.hours do
          in_sequence do
            cap "first_task"
            rake "second_task"
          end
          
          in_sequence do
            runner "third_task"
            command "fourth_task"
          end
        end
      file
    end
    
    should "output each sequence as its own sequential task" do
      assert_match two_hours + ' cd /my/path && RAILS_ENV=production /usr/bin/env cap first_task && cd /my/path && RAILS_ENV=production /usr/bin/env rake second_task', @output
      assert_match two_hours + ' /my/path/script/runner -e production "third_task" && fourth_task', @output
    end
  end
  
  
  context "A set of tasks in different time blocks that should each be grouped and by their sequence and time" do
    setup do
      @output = Whenever.cron \
      <<-file
        set :path, '/my/path'
        every 1.hour do
          in_sequence do
            cap "first_task"
            rake "second_task"
          end
        end
        
        every 2.hours do
          in_sequence do
            runner "third_task"
            command "fourth_task"
          end
        end
      file
    end
    
    should "output each sequence as its own sequential task at the correct time" do
      assert_match '0 * * * * cd /my/path && RAILS_ENV=production /usr/bin/env cap first_task && cd /my/path && RAILS_ENV=production /usr/bin/env rake second_task', @output
      assert_match two_hours + ' /my/path/script/runner -e production "third_task" && fourth_task', @output
    end
  end
end