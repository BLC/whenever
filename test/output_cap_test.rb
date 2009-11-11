require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class OutputCapTest < Test::Unit::TestCase
  
  # Rake are generated in an almost identical way to runners so we
  # only need some basic tests to ensure they are output correctly
  
  context "A rake command with path set" do
    setup do
      @output = Whenever.cron \
      <<-file
        set :path, '/my/path'
        every 2.hours do
          cap "blahblah"
        end
      file
    end
    
    should "output the rake command using that path" do
      assert_match two_hours + ' cd /my/path && RAILS_ENV=production /usr/bin/env cap blahblah', @output
    end
  end
end