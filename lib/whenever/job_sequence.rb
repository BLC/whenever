module Whenever
  class JobSequence < Array
    attr_writer :dependent
    
    def initialize(options={}, size=0, obj=nil)
      super(size, obj)
      
      @dependent = options.fetch(:dependent, true)
    end
    
    def to_single_job
      concatenation = @dependent ? " && " : "; "
      Job::Default.new(:task => map(&:output).join(concatenation))
    end
  end
end