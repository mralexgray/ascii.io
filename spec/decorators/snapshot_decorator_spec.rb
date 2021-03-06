require 'spec_helper'

describe SnapshotDecorator do

  let(:decorator) { described_class.new(snapshot) }
  let(:snapshot) { double('snapshot', :width => 2, :height => 2) }
  let(:cells) { [
    [:a, :b],
    [:c, :d]
  ] }

  describe '#lines' do
    subject { decorator.lines }

    before do
      allow(snapshot).to receive(:cell) { |x, y| cells[y][x] }

      allow(LineOptimizer).to receive(:new).with([:a, :b]) {
        double('optimizer', :optimize => [:ab])
      }

      allow(LineOptimizer).to receive(:new).with([:c, :d]) {
        double('optimizer', :optimize => [:c, :d])
      }
    end

    it { should eq([ [:ab], [:c, :d] ]) }
  end

end
