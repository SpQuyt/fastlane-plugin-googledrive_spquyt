require 'fastlane/action'
require_relative '../helper/googledrive_spquyt_helper'

module Fastlane
  module Actions
    module SharedValues
      GDRIVE_FOLDER_FILES = :GDRIVE_FOLDER_FILES
      GDRIVE_FOLDER_FILES_TITLE = :GDRIVE_FOLDER_FILES_TITLE
    end
    class ListFilesGoogleDriveAction < Action
      def self.run(params)

        session = Helper::GoogledriveSpquytHelper.setup(
          keyfile: params[:drive_keyfile],
          service_account: params[:service_account]
        )

        folder = Helper::GoogledriveSpquytHelper.file_by_id(
          session: session, fid: params[:folder_id]
        )

        folder_files = params[:keyword] ? folder.files.select{|file| file.title.include? params[:keyword]} : folder.files
        folder_files_title = params[:keyword] ? folder.files.select{|file| file.title.include? params[:keyword]}.map{|file| file.title} : folder.files.map{|file| file.title}
        Actions.lane_context[SharedValues::GDRIVE_FOLDER_FILES] = folder_files
        Actions.lane_context[SharedValues::GDRIVE_FOLDER_FILES_TITLE] = folder_files_title
        UI.important("List files: #{folder_files_title}")
      end

      def self.description
        'List files on Google Drive'
      end

      def self.details
        [
          'List files on Google Drive',
          'See https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md to get a keyfile'
        ].join("\n")
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :drive_keyfile,
                                      env_name: 'GDRIVE_KEY_FILE',
                                      description: 'Json config file',
                                      type: String,
                                      default_value: 'drive_key.json',
                                      verify_block: proc do |value|
                                        UI.user_error!("Couldn't find config keyfile at path '#{value}'") unless File.exist?(value)
                                      end),
          FastlaneCore::ConfigItem.new(key: :service_account,
                                      env_name: 'GDRIVE_SERVICE_ACCOUNT',
                                      description: 'Credential is service account',
                                      optional: true,
                                      is_string: false,
                                      default_value: false),
          FastlaneCore::ConfigItem.new(key: :folder_id,
                                      env_name: "GDRIVE_UPLOAD_FOLDER_ID",
                                      description: "Upload target folder id",
                                      optional: false,
                                      type: String,
                                      verify_block: proc do |value|
                                        UI.user_error!("No target folder id given, pass using `folder_id: 'some_id'`") unless value and !value.empty?
                                      end),
          FastlaneCore::ConfigItem.new(key: :keyword,
                                      env_name: "GDRIVE_KEYWORD_LIST_FILES",
                                      description: "Keyword for filter list files",
                                      optional: false,
                                      type: String),
        ]
      end

      def self.output
        [
          ['GDRIVE_FOLDER_FILES', 'Full collection of files in folder'],
          ['GDRIVE_FOLDER_FILES_TITLE', 'Title of files in folder']
        ]
      end

      def self.return_value
        # nothing
      end

      def self.authors
        ['SpQuyt (@spquyt)']
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
