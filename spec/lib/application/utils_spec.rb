require 'rails_helper'

describe Application::Utils do
  describe '#decode_path' do
    it 'decodes path with correct encode data' do
      expect(described_class.decode_path('%27Stop%21%27+said+Fred')).to eq("'Stop!' said Fred")
    end
  end

  describe '#check_path_traversal!' do
    it 'raises error when path contains path traversal attack' do
      expect do
        described_class.check_path_traversal!('../')
      end.to raise_error(StandardError)
    end

    it 'returns decoded path if path is valid' do
      expect(described_class.check_path_traversal!('%27Stop%21%27+said+Fred')).to eq("'Stop!' said Fred")
    end
  end
end
