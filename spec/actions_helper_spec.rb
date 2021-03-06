describe Fastlane do
  describe Fastlane::FastFile do
    describe "#execute_action" do
      let (:step_name) { "My Step" }
      
      it "stores the action properly" do
        Fastlane::Actions.execute_action(step_name) {} 
        result = Fastlane::Actions.executed_actions.last
        expect(result[:name]).to eq(step_name)
        expect(result[:error]).to eq(nil)
      end

      it "stores the action properly when an exeception occured" do
        expect {
          Fastlane::Actions.execute_action(step_name) do
            raise "Some error"
          end
        }.to raise_error "Some error"

        result = Fastlane::Actions.executed_actions.last
        expect(result[:name]).to eq(step_name)
        expect(result[:error]).to include"Some error"
        expect(result[:error]).to include"actions_helper.rb"
      end
    end

    it "#load_default_actions" do
      expect(Fastlane::Actions.load_default_actions.count).to be > 6
    end

    describe "#load_external_actions" do
      it "can load custom paths" do
        Fastlane::Actions.load_external_actions("spec/fixtures/actions")
        Fastlane::Actions::ExampleActionAction.run(nil)
        Fastlane::Actions::ExampleActionSecondAction.run(nil)
        Fastlane::Actions::ArchiveAction.run(nil)
      end

      it "can throws an error if plugin is damaged" do
        expect {
          Fastlane::Actions.load_external_actions("spec/fixtures/broken_actions")
        }.to raise_error "Plugin 'broken_action' is damaged!"
      end
    end
  end
end
