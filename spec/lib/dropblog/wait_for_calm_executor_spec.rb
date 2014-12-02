require 'spec_helper'

RSpec.describe Dropblog::WaitForCalmExecutor do
  let(:executable) { spy('executable', :execute => true) }

  subject(:executor) do
    Dropblog::WaitForCalmExecutor.new(executable)
  end

  it 'should be initialized with an executable' do
    expect do
      executable = spy('executable', :execute => true)
      executor = Dropblog::WaitForCalmExecutor.new(executable)
    end.not_to raise_error
  end

  it 'should throw an error if a non executable is passed' do
    expect do
      Dropblog::WaitForCalmExecutor.new('bad')
    end.to raise_error ArgumentError
  end

  it { is_expected.to respond_to(:ask_to_execute) }

  it 'will execute by default' do
    expect(executor.ask_to_execute).to be true
  end

  it { is_expected.to respond_to(:disable_execution!) }

  it 'will never call execute if it is disabled' do
    executor.disable_execution!
    expect(executor.ask_to_execute).to be false
  end

  it 'will execute as many times as asked by default' do
    10.times do
      executor.ask_to_execute
    end
    expect(executable).to have_received(:execute).exactly(10).times
  end

  it 'will execute only once given rapid requests and a long waiting period' do
    executor.wait_seconds_for_calm!(2)
    5.times do
      executor.ask_to_execute
    end
    expect(executable).to have_received(:execute).once
  end

end
