module Bushido
  class Utils #:nodoc:
    class << self
      # TODO: Make this update all the available ENV variables 
      def refresh_env!
      end

      def array_helper(array, proc)
        array.collect do |value|
          if value.kind_of?( Hash  )
            deep_process_hash_keys(value, proc)
          elsif value.kind_of?( Array )
            array_helper(array)
          else
            value
          end
        end
      end

      def deep_process_hash_keys(input_hash, proc)
        hash = {}
        input_hash.keys.each do |key|
          _key = proc.call(key)
          if input_hash[key].kind_of?(Hash)
            hash[_key] = deep_process_hash_keys(input_hash[key], proc)
          elsif input_hash[key].kind_of?(Array)
            hash[_key] = array_helper(input_hash[key], proc)
          else
            hash[_key] = input_hash[key]
          end
        end

        hash
      end

      def deep_underscore_hash_keys(input_hash)
        deep_process_hash_keys(input_hash, Proc.new { |key| key.to_s.underscore })
      end

      def deep_symbolize_hash_keys(input_hash)
        deep_process_hash_keys(input_hash, Proc.new { |key| key.to_sym })
      end

      def deep_stringify_hash_keys(input_hash)
        deep_process_hash_keys(input_hash, Proc.new { |key| key.to_s })
      end

      def normalize_keys(input_hash)
        deep_symbolize_hash_keys(deep_underscore_hash_keys(input_hash))
      end
    end
  end
end
