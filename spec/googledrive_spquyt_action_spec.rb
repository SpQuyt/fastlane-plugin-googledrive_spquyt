describe Fastlane::Actions::GoogledriveSpquytAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The googledrive_spquyt plugin is working!")

      Fastlane::Actions::GoogledriveSpquytAction.run(nil)
    end
  end
end
