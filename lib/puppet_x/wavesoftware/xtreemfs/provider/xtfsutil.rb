module Puppet_X
module Wavesoftware
module Xtreemfs
module Provider

  class Xtfsutil < Puppet::Provider

    # Puppet instances method, that fetches instances for CLI
    #
    # @return [Array] a list of +Puppet_X::Wavesoftware::Xtreemfs::Provider::Xtfsutil+
    def self.instances
      []
    end

    # A constructor
    #
    # @param value [Hash] values for the provider, prefeched
    # @return [Puppet_X::Wavesoftware::Xtreemfs::Provider::Xtfsutil]
    def initialize value = {}
      super value
      @property_flush = {}
      @rawprops = nil
      self
    end

    # A rawprops setter
    #
    # @param props [Hash] a raw properties
    # @return [Hash] raw properties
    def rawprops= props
      @rawprops = props
    end

    # Corrects a policy that is outputed by xtfsutil commandline tool
    #
    # @param value [String] an input form
    # @return [String] an corrected form
    def self.correct_policy value
      if /^none\s+.*$/.match(value)
        'none'
      else
        value
      end
    end

    # A puppet prefetch method, that prefetches instances for management runs
    #
    # @param resources [Hash] a hash of resources in form of :name => resource
    # @return [Hash] a filled up hash
    def self.prefetch resources
      resources.keys.each do |name|
        if (provider = load_provider name)
          resources[name].provider = provider
        end
      end
    end

    # Puppet flush method
    #
    # Used for flushing all operations in one place. In this case it is used to 
    # maintain order of operations.
    #
    # @return [nil]
    def flush
      validate
      flush_policy
      flush_factor
      return nil
    end

    # Flushes a factor property
    #
    # @return [nil]
    def flush_factor
      if @property_flush[:factor] and @property_flush[:factor] < @property_hash[:factor]
        unreplicate
      end
      if @property_flush[:factor]
        replicate
      end
      return nil
    end

    # Flushes a policy property
    #
    # @return [nil]
    def flush_policy
      if @property_flush[:policy]
        if factor > 1
          unreplicate
        end
        xtfsutil ['--set-replication-policy', @property_flush[:policy], resource[:file]]
        @property_hash[:policy] = @property_flush[:policy]
      end
      return nil
    end

    # A policy getter
    #
    # @return [String] a policy
    def policy
      @property_hash[:policy] || nil
    end

    # A factor getter
    #
    # @return [String] a factor
    def factor
      @property_hash[:factor] || nil
    end

    # A policy setter
    #
    # @param value [String] a policy
    # @return [String] a policy
    def policy= value
      validate
      @property_flush[:policy] = value
    end

    # A factor setter
    #
    # @param value [String] a factor
    # @return [String] a factor
    def factor= value
      validate
      @property_flush[:factor] = value
    end

  end

end
end
end
end