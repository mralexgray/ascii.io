require 'spec_helper'

describe Terminal do

  let(:terminal) { Terminal.new(20, 10) }
  let(:tsm_screen) { double('tsm_screen', :draw => nil) }
  let(:tsm_vte) { double('tsm_vte', :input => nil) }
  let(:snapshot) { double('snapshot') }

  before do
    allow(TSM::Screen).to receive(:new).with(20, 10) { tsm_screen }
    allow(TSM::Vte).to receive(:new).with(tsm_screen) { tsm_vte }
    allow(Snapshot).to receive(:build).with([:array]) { snapshot }
  end

  describe '#feed' do
    subject { terminal.feed('foo') }

    it 'feeds the vte with the data' do
      subject

      expect(tsm_vte).to have_received(:input).with('foo')
    end
  end

  describe '#snapshot' do
    subject { terminal.snapshot }

    def make_attr(attrs = {})
      TSM::ScreenAttribute.new.tap do |screen_attribute|
        attrs.each { |name, value| screen_attribute[name] = value }
      end
    end

    it "returns each screen cell with its character attributes" do
      expect(tsm_screen).to receive(:draw).
        and_yield(0, 0, 'f', make_attr(fg: 1)).
        and_yield(1, 0, 'o', make_attr(bg: 2)).
        and_yield(0, 1, 'o', make_attr(bold?: true)).
        and_yield(1, 1, 'b', make_attr(fg: 2, bg: 3,
                                       bold?: true, underline?: true,
                                       inverse?: true, blink?: true))

      expect(subject).to eq([
        [
          ['f', fg: 1],
          ['o', bg: 2]
        ],
        [
          ['o', bold: true],
          ['b', fg: 2, bg: 3, bold: true, underline: true, inverse: true,
                                                           blink: true]
        ]
      ])
    end
  end

end
