module Whenever
  module Job
    class CapTask < Whenever::Job::Default
      
      def output
        path_required
        "cd #{@path} && RAILS_ENV=#{@environment} /usr/bin/env cap #{task}"
      end
      
    end
  end
end
