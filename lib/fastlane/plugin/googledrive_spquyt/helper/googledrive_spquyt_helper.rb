require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class GoogledriveSpquytHelper
      # class methods that you define here become available in your action
      # as `Helper::GoogledriveSpquytHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the googledrive_spquyt plugin helper!")
      end
    end
  end
end
