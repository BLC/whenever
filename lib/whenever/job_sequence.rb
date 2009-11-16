module Whenever
  class JobSequence < Array
    attr_writer :dependent
    
    def initialize(options={}, size=0, obj=nil)
      super(size, obj)
      
      @options = options
      @dependent = options.fetch(:dependent, true)
    end
    
    def to_single_job
      concatenation = @dependent ? " && " : "; "
      task = map(&:output).join(concatenation)

      Job::Default.new(@options.merge(:task => task))
    end
  end
end