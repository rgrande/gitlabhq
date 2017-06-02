require 'spec_helper'
require 'rainbow/ext/string'

describe 'seed production settings', lib: true do
  include StubENV
  let(:settings_file) { File.join(__dir__, '../../../db/fixtures/production/010_settings.rb') }
  let(:settings) { ApplicationSetting.current || ApplicationSetting.create_from_defaults }

  context 'GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN is set in the environment' do
    before do
      stub_env('GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN', '013456789')
    end

    it 'writes the token to the database' do
      load(settings_file)

      expect(settings.runners_registration_token).to eq('013456789')
    end
  end

  context 'GITLAB_PROMETHEUS_METRICS_ENABLED is set in the environment' do
    context 'GITLAB_PROMETHEUS_METRICS_ENABLED is true' do
      before do
        stub_env('GITLAB_PROMETHEUS_METRICS_ENABLED', 'true')
      end

      it 'prometheus_metrics_enabled is set to true ' do
        load(settings_file)

        expect(settings.prometheus_metrics_enabled).to eq(true)
      end
    end

    context 'GITLAB_PROMETHEUS_METRICS_ENABLED is false' do
      before do
        stub_env('GITLAB_PROMETHEUS_METRICS_ENABLED', 'false')
      end

      it 'prometheus_metrics_enabled is set to false' do
        load(settings_file)

        expect(settings.prometheus_metrics_enabled).to eq(false)
      end
    end
  end
end
