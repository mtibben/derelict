require "spec_helper"

describe Derelict::Plugin::Manager do
  let(:instance) { double("instance", :description => "test instance") }
  let(:manager) { Derelict::Plugin::Manager.new instance }
  subject { manager }

  it "is autoloaded" do
    should be_a Derelict::Plugin::Manager
  end

  include_context "logged messages"
  let(:expected_logs) {[
    "DEBUG manager: Successfully initialized Derelict::Plugin::Manager for test instance\n"
  ]}

  describe "#list" do
    let(:stdout) { "stdout\n" }
    let(:result) { double("result", :stdout => stdout) }
    let(:parser) { double("parser", :plugins => plugins) }
    let(:plugins) { [:foo, :bar] }

    subject { manager.list }

    before do
      expect(instance).to receive(:execute!).with(:plugin, "list").and_return(result)
      expect(Derelict::Parser::PluginList).to receive(:new).with(stdout).and_return(parser)
    end

    it { should be plugins }

    include_context "logged messages"
    let(:expected_logs) {[
      "DEBUG manager: Successfully initialized Derelict::Plugin::Manager for test instance\n",
      " INFO manager: Retrieving Vagrant plugin list for Derelict::Plugin::Manager for test instance\n",
    ]}
  end

  describe "#installed?" do
    let(:plugin_name) { double("plugin_name") }
    let(:result) { double("result") }
    subject { manager.installed? plugin_name }

    context "with known plugin" do
      before { expect(manager).to receive(:fetch).with(plugin_name).and_return(result) }
      it { should be true }
    end

    context "with unknown plugin" do
      before { expect(manager).to receive(:fetch).with(plugin_name).and_raise(Derelict::Plugin::NotFound.new plugin_name) }
      it { should be false }
    end

    include_context "logged messages"
    let(:expected_logs) {[
      "DEBUG manager: Successfully initialized Derelict::Plugin::Manager for test instance\n",
      " INFO manager: Retrieving Vagrant plugin list for Derelict::Plugin::Manager for test instance\n",
    ]}
  end

  describe "#install" do
    let(:plugin_name) { double("plugin_name", :to_s => "test plugin") }
    let(:version) { double("version") }
    let(:result) { double("result") }
    subject { manager.install plugin_name, version }

    before do
      expect(instance).to receive(:execute!).with(:plugin, "install", plugin_name, '--plugin-version', version).and_return(result)
    end

    it { should be result }

    include_context "logged messages"
    let(:expected_logs) {[
      "DEBUG manager: Successfully initialized Derelict::Plugin::Manager for test instance\n",
      " INFO manager: Installing plugin 'test plugin' using Derelict::Plugin::Manager for test instance\n",
    ]}
  end

  describe "#uninstall" do
    let(:plugin_name) { double("plugin_name", :to_s => "test plugin") }
    let(:result) { double("result") }
    subject { manager.uninstall plugin_name }

    before do
      expect(instance).to receive(:execute!).with(:plugin, "uninstall", plugin_name).and_return(result)
    end

    it { should be result }

    include_context "logged messages"
    let(:expected_logs) {[
      "DEBUG manager: Successfully initialized Derelict::Plugin::Manager for test instance\n",
      " INFO manager: Uninstalling plugin 'test plugin' using Derelict::Plugin::Manager for test instance\n",
    ]}
  end

  describe "#update" do
    let(:plugin_name) { double("plugin_name", :to_s => "test plugin") }
    let(:result) { double("result") }
    subject { manager.update plugin_name }

    before do
      expect(instance).to receive(:execute!).with(:plugin, "update", plugin_name).and_return(result)
    end

    it { should be result }

    include_context "logged messages"
    let(:expected_logs) {[
      "DEBUG manager: Successfully initialized Derelict::Plugin::Manager for test instance\n",
      " INFO manager: Updating plugin 'test plugin' using Derelict::Plugin::Manager for test instance\n",
    ]}
  end


  describe "#fetch" do
    let(:foo) { double("foo", :name => "foo") }
    let(:bar) { double("bar", :name => "bar") }
    let(:plugins) { [foo, bar] }

    let(:plugin_name) { double("plugin_name") }
    subject { manager.fetch plugin_name }
    before { expect(manager).to receive(:list).and_return(plugins) }

    context "with known plugin" do
      let(:plugin_name) { "foo" }
      it { should be foo }
    end

    context "with unknown plugin" do
      let(:plugin_name) { "qux" }
      it "should raise NotFound" do
        expect { subject }.to raise_error Derelict::Plugin::NotFound
      end
    end

    include_context "logged messages"
    let(:expected_logs) {[
      "DEBUG manager: Successfully initialized Derelict::Plugin::Manager for test instance\n",
    ]}
  end

end
