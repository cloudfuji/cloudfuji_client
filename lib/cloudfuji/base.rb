module Cloudfuji
  class Base
    class << self
      url_pairs = {
                    :unity=>[:valid, :exists, :invite, :pending_invites, :remove, :notify],
                    :email=>[:send, :allowed]
                  }

      def notify_user_url
        "#{Cloudfuji::Platform.host}/notifications.json"
      end

      # NOTE Cannot use define_singleton_method since ruby 1.8 compatibility is a must
      url_pairs.each_pair do |prefix, method_names|
        method_names.each do |method_name|
          define_method "#{method_name}_#{prefix}_url".to_sym do
            "#{Cloudfuji::Platform.host}/#{prefix}/#{Cloudfuji::Config.api_version}/#{method_name}"
          end
        end
      end
    end
  end
end
