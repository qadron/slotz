require 'spec_helper'
require 'slotz/system'

describe Slotz do
    subject { system }
    let(:system) { Slotz::System.instance }

    before :each do
        subject.reset
    end

    describe '#available' do
        context 'when OptionGroups::system#max_slots is set' do
            before do
                Slotz::System.max_slots = 5
            end

            it 'uses it to calculate available slots' do
                expect(subject.available).to eq 5
            end

            context 'when some slots have been used' do
                it 'subtracts them' do
                    allow(subject).to receive(:used).and_return( 2 )
                    expect(subject.available).to eq 3
                end
            end
        end

        context 'when OptionGroups::system#max_slots is not set' do
            before do
                Slotz::System.max_slots = nil
            end

            it 'uses #available_auto' do
                pending
                expect(subject).to receive(:available_auto).and_return( 25 )
                expect(subject.available).to eq 25
            end
        end
    end

    describe '#available_auto' do
        before do
            Slotz::System.max_slots = nil
        end

        it 'calculates slots based on previously reserved resources' do
            pending
        end

        context 'when restricted by memory' do
            it 'bases the calculation on memory slots' do
                pending
            end
        end

        context 'when restricted by CPUs' do
            it 'bases the calculation on CPU slots' do
                pending
            end
        end

        context 'when restricted by disk space' do
            it 'bases the calculation on disk space' do
                pending
            end
        end
    end

    describe '#used' do
        it 'returns the amount of active instances' do
            pending
        end

        context 'when a process dies' do
            it 'gets removed from the count'
        end
    end

    describe '#total' do
        it 'sums up free and used slots' do
            expect(subject).to receive(:available).and_return( 3 )
            expect(subject).to receive(:used).and_return( 5 )

            expect(subject.total).to eq 8
        end
    end

    describe '#available_in_memory' do
        it 'returns amount of free memory slots' do
            pending
        end
    end

    describe '#available_in_cpu' do
        it 'returns amount of free CPUs splots' do
            pending
        end
    end

    describe '#unallocated_memory' do
        context 'when there are no scans running' do
            it 'returns the amount of free memory' do
                pending
            end
        end

        context 'when there are scans running' do
            context 'using part of their allocation' do
                it 'removes their allocated slots' do
                    pending
                end
            end
        end
    end

    describe '#remaining_memory_for' do
        it 'returns the amount of allocated memory available to the scan' do
            pending
        end
    end

    describe '#unallocated_disk_space' do
        context 'when there are no scans running' do
            it 'returns the amount of free disk space' do
                pending
            end
        end

        context 'when there are scans running' do
            context 'using part of their allocation' do
                it 'removes their allocated slots' do
                    pending
                end
            end
        end
    end

    describe '#remaining_disk_space_for' do
        it 'returns the amount of allocated disk space available to the scan' do
            pending
        end
    end

    describe '#memory_size' do
        before do
            # Slotz::Options.reset
        end
        let(:memory_size) { subject.memory_size }

        it 'is approx 0.2GB with default options' do
            pending
        end
    end
end
