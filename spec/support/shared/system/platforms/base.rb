require 'tmpdir'

shared_examples_for 'Slotz::System::Platforms::Base' do
    subject { described_class.new }

    describe '#disk_directory' do
        it "delegates to #{Dir.tmpdir}" do
            expect(subject.disk_directory).to eq Dir.tmpdir
        end
    end

    describe '#cpu_count' do
        it 'returns the amount of CPUs' do
            expect(Concurrent).to receive(:processor_count).and_return(99)
            expect(subject.cpu_count).to eq 99
        end
    end

end
