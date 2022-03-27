require 'rails_helper'

describe DbCsvLoader do
  describe '.export_table' do
    let(:table) { 'roles' }
    let(:filename) { Rails.root.join('db/fixtures/roles.csv') }
    let(:data) { Role.all }

    before do
      allow(CSV).to receive(:open).with(filename, 'w')
    end

    it 'imports data to model' do
      described_class.export_table(table)
      expect(CSV).to have_received(:open).with(filename, 'w')
    end
  end

  describe '.import_table' do
    let(:filename) { Rails.root.join('db/fixtures/roles.csv') }
    let(:table) do
      table = []
      CSV.foreach(filename, headers: true) do |row|
        table << row.to_h
      end
      table
    end

    before do
      allow(Role).to receive(:import)
    end

    it 'imports data to model' do
      described_class.import_table(filename)
      expect(Role).to have_received(:import).with(table)
    end
  end
end
