# rubocop:disable Metrics/BlockLength
# rubocop:disable Lint/BinaryOperatorWithIdenticalOperands
describe Bihash do
  it 'is enumerable' do
    expect(described_class).to include(Enumerable)
  end

  describe '::[]' do
    it 'is able to create an empty bihash' do
      bh = described_class[]
      expect(bh).to be_a_kind_of(described_class)
      expect(bh).to be_empty
    end

    it 'converts a hash to a bihash' do
      bh = described_class[key: 'value']
      expect(bh).to be_a_kind_of(described_class)
      expect(bh[:key]).to eq('value')
      expect(bh['value']).to eq(:key)
    end

    it 'does not accept a hash with duplicate values' do
      expect { described_class[k1: 'val', k2: 'val'] }.to raise_error(ArgumentError)
    end

    it 'does not accept a hash that would result in ambiguous mappings' do
      expect { described_class[1, 2, 2, 3] }.to raise_error(ArgumentError)
    end

    it 'accepts a hash where a key equals its value' do
      bh = described_class[key: :key]
      expect(bh).to be_a_kind_of(described_class)
      expect(bh[:key]).to eq(:key)
    end

    it 'alwayses return the value object if key-value pairs are equal' do
      key = []
      value = []
      bh = described_class[key => value]
      expect(bh).to be_a_kind_of(described_class)
      expect(bh[key].object_id).to eq(value.object_id)
      expect(bh[value].object_id).to eq(value.object_id)
    end

    it 'accepts an even number of arguments' do
      bh = described_class[:k1, 1, :k2, 2]
      expect(bh).to be_a_kind_of(described_class)
      expect(bh[:k1]).to eq(1)
      expect(bh[:k2]).to eq(2)
      expect(bh[1]).to eq(:k1)
      expect(bh[2]).to eq(:k2)
    end

    it 'accepts an array of key-value pairs packaged in arrays' do
      array = [[:k1, 1], [:k2, 2]]
      bh = described_class[array]
      expect(bh).to be_a_kind_of(described_class)
      expect(bh[:k1]).to eq(1)
      expect(bh[:k2]).to eq(2)
      expect(bh[1]).to eq(:k1)
      expect(bh[2]).to eq(:k2)
    end
  end

  describe '::new' do
    it 'creates an empty bihash with a default of nil if no args' do
      bh = described_class.new
      expect(bh).to be_a_kind_of(described_class)
      expect(bh).to be_empty
      expect(bh[:not_a_key]).to be_nil
    end

    it 'creates an empty bihash with a default if given an object arg' do
      bh = described_class.new('default')
      expect(bh).to be_a_kind_of(described_class)
      expect(bh).to be_empty
      expect(bh[:not_a_key]).to eq('default')
      bh[:not_a_key].tr!('ealt', '3417')
      expect(bh[:still_not_a_key]).to eq('d3f4u17')
    end

    it 'creates an empty bihash with a default if given a block arg' do
      bh = described_class.new { 'd3f4u17' }
      expect(bh).to be_a_kind_of(described_class)
      expect(bh).to be_empty
      expect(bh[:not_a_key]).to eq('d3f4u17')
      bh[:not_a_key].tr!('3417', 'ealt')
      expect(bh[:not_a_key]).to eq('d3f4u17')
    end

    it 'allows assignment of new pairs if given a block arg' do
      bh = described_class.new { |bihash, key| bihash[key] = key.to_s }
      expect(bh[404]).to eq('404')
      expect(bh.size).to eq(1)
      expect(bh).to include(404)
      expect(bh).to include('404')
    end

    it 'does not accept both an object and a block' do
      expect { described_class.new('default 1') { 'default 2' } }.to raise_error(ArgumentError)
    end
  end

  describe '::try_convert' do
    it 'converts an object to a bihash if it responds to #to_hash' do
      hash = { k1: 1, k2: 2 }
      bh = described_class.try_convert(hash)
      expect(bh).to be_a_kind_of(described_class)
      expect(bh[:k1]).to eq(1)
      expect(bh[:k2]).to eq(2)
      expect(bh[1]).to eq(:k1)
      expect(bh[2]).to eq(:k2)
    end

    it 'converts a bihash to a bihash' do
      bh = described_class[key: 'value']
      expect(described_class.try_convert(bh)).to eq(bh)
    end

    it 'returns nil if the object does not respond to #to_hash' do
      expect(described_class.try_convert(Object.new)).to be_nil
    end

    it 'does not accept a hash with duplicate values' do
      expect { described_class.try_convert(k1: 1, k2: 1) }.to raise_error(ArgumentError)
    end
  end

  describe '#<' do
    it 'raises an error if the right hand side is not a bihash' do
      expect { described_class[a: 1, b: 2] < { a: 1, b: 2, c: 3 } }.to raise_error(TypeError)
    end

    it 'returns true when the argument is a strict subset of self' do
      expect(described_class[a: 1, b: 2] < described_class[a: 1, b: 2, c: 3]).to be(true)
    end

    it 'returns false when the argument is equal to self' do
      expect(described_class[a: 1, b: 2] < described_class[a: 1, b: 2]).to be(false)
    end

    it 'returns false when the argument is not a subset of self' do
      expect(described_class[a: 1, b: 2, c: 3] < described_class[a: 1, b: 2]).to be(false)
    end
  end

  describe '#<=' do
    it 'raises an error if the right hand side is not a bihash' do
      expect { described_class[a: 1, b: 2] <= { a: 1, b: 2, c: 3 } }.to raise_error(TypeError)
    end

    it 'returns true when the argument is a strict subset of self' do
      expect(described_class[a: 1, b: 2] <= described_class[a: 1, b: 2, c: 3]).to be(true)
    end

    it 'returns true when the argument is equal to self' do
      expect(described_class[a: 1, b: 2] <= described_class[a: 1, b: 2]).to be(true)
    end

    it 'returns false when the argument is not a subset of self' do
      expect(described_class[a: 1, b: 2, c: 3] <= described_class[a: 1, b: 2]).to be(false)
    end
  end

  describe '#==' do
    it 'returns true when two bihashes have the same pairs' do
      bh1 = described_class[k1: 1, k2: 2]
      bh2 = described_class[2 => :k2, 1 => :k1]
      expect(bh1 == bh2).to be(true)
    end

    it 'returns false when two bihashes do not have the same pairs' do
      bh1 = described_class[k1: 1, k2: 2]
      bh2 = described_class[k1: 1, k2: 99]
      expect(bh1 == bh2).to be(false)
    end

    it 'is aliased to #eql?' do
      bh = described_class.new
      expect(bh.method(:eql?)).to eq(bh.method(:==))
    end
  end

  describe '#>' do
    it 'raises an error if the right hand side is not a bihash' do
      expect { described_class[a: 1, b: 2] > { a: 1, b: 2, c: 3 } }.to raise_error(TypeError)
    end

    it 'returns true when the argument is a strict superset of self' do
      expect(described_class[a: 1, b: 2, c: 3] > described_class[a: 1, b: 2]).to be(true)
    end

    it 'returns false when the argument is equal to self' do
      expect(described_class[a: 1, b: 2] > described_class[a: 1, b: 2]).to be(false)
    end

    it 'returns false when the argument is not a superset of self' do
      expect(described_class[a: 1, b: 2] > described_class[a: 1, b: 2, c: 3]).to be(false)
    end
  end

  describe '#>=' do
    it 'raises an error if the right hand side is not a bihash' do
      expect { described_class[a: 1, b: 2] >= { a: 1, b: 2, c: 3 } }.to raise_error(TypeError)
    end

    it 'returns true when the argument is a strict superset of self' do
      expect(described_class[a: 1, b: 2, c: 3] >= described_class[a: 1, b: 2]).to be(true)
    end

    it 'returns true when the argument is equal to self' do
      expect(described_class[a: 1, b: 2] >= described_class[a: 1, b: 2]).to be(true)
    end

    it 'returns false when the argument is not a superset of self' do
      expect(described_class[a: 1, b: 2] >= described_class[a: 1, b: 2, c: 3]).to be(false)
    end
  end

  describe '#[]' do
    it 'returns the other pair' do
      bh = described_class[key: 'value']
      expect(bh[:key]).to eq('value')
      expect(bh['value']).to eq(:key)
    end

    it 'returns falsey values correctly' do
      bh1 = described_class[nil => false]
      expect(bh1[nil]).to be(false)
      expect(bh1[false]).to be_nil

      bh2 = described_class[false => nil]
      expect(bh2[false]).to be_nil
      expect(bh2[nil]).to be(false)
    end
  end

  describe '#[]=' do
    it 'allows assignment of new pairs' do
      bh = described_class.new
      bh[:key] = 'value'
      expect(bh[:key]).to eq('value')
      expect(bh['value']).to eq(:key)
    end

    it 'removes old pairs if old keys are re-assigned' do
      bh = described_class[1 => 'one', 2 => 'two']
      bh[1] = 'uno'
      expect(bh[1]).to eq('uno')
      expect(bh['uno']).to eq(1)
      expect(bh).not_to include('one')
    end

    it 'alwayses return the value object if key-value pairs are equal' do
      key = []
      value = []
      bh = described_class.new
      bh[key] = value
      expect(bh[key].object_id).to eq(value.object_id)
      expect(bh[value].object_id).to eq(value.object_id)
    end

    it 'is aliased to #store' do
      bh = described_class.new
      expect(bh.method(:store)).to eq(bh.method(:[]=))
      bh.store(:key, 'value')
      expect(bh[:key]).to eq('value')
      expect(bh['value']).to eq(:key)
    end

    it 'raises RuntimeError if called on a frozen bihash' do
      expect { described_class.new.freeze[:key] = 'value' }.to raise_error(RuntimeError)
    end
  end

  describe '#assoc' do
    it 'returns the pair if the argument is a key' do
      bh = described_class[k1: 'v1', k2: 'v2']
      expect(bh.assoc(:k1)).to eq([:k1, 'v1'])
      expect(bh.assoc('v2')).to eq(['v2', :k2])
    end

    it 'returns nil if the argument is not a key' do
      bh = described_class.new(404)
      expect(bh.assoc(:not_a_key)).to be_nil
    end

    it 'finds the key using #==' do
      bh = described_class[[] => 'array']
      bh['array'] << 'modified'
      expect(bh.assoc(['modified'])).to eq([['modified'], 'array'])
      expect(bh.assoc([])).to be_nil
    end
  end

  describe '#clear' do
    it 'removes all pairs and return the bihash' do
      bh = described_class[key: 'value']
      expect(bh.clear.object_id).to eq(bh.object_id)
      expect(bh).to be_empty
    end

    it 'raises RuntimeError if called on a frozen bihash' do
      expect { described_class.new.freeze.clear }.to raise_error(RuntimeError)
    end
  end

  describe '#compare_by_identity' do
    it 'sets bihash to compare by identity instead of equality' do
      bh = described_class.new.compare_by_identity
      key1 = 'key'
      key2 = 'value'
      bh[key1] = key2
      expect(bh['key']).to be_nil
      expect(bh['value']).to be_nil
      expect(bh[key1]).to eq('value')
      expect(bh[key2]).to eq('key')
    end

    it 'raises RuntimeError if called on a frozen bihash' do
      expect { described_class.new.freeze.compare_by_identity }.to raise_error(RuntimeError)
    end
  end

  describe '#compare_by_identity?' do
    it 'indicates whether bihash is comparing by identity' do
      expect(described_class.new.compare_by_identity.compare_by_identity?).to be(true)
      expect(described_class.new.compare_by_identity?).to be(false)
    end
  end

  describe '#default' do
    it 'does not accept more than one argument' do
      expect { described_class.new.default(1, 2) }.to raise_error(ArgumentError)
    end

    context 'when there is not a default proc' do
      context 'with .new' do
        it 'returns the default' do
          bh = described_class.new(404)
          bh[:key] = 'value'
          expect(bh.default).to eq(404)
          expect(bh.default(:not_a_key)).to eq(404)
          expect(bh.default(:key)).to eq(404)
        end
      end

      context 'with hash initializing' do
        it 'returns the default' do
          bh = described_class[key: 'value']
          expect(bh.default).to be_nil
          expect(bh.default(:not_a_key)).to be_nil
          expect(bh.default(:key)).to be_nil
        end
      end
    end

    context 'when there is a default proc' do
      it 'returns the default if called with no argument' do
        expect(described_class.new { 'proc called' }.default).to be_nil
      end

      it 'calls the default proc when called with an argument' do
        bh = described_class.new { |bihash, key| bihash[key] = key.to_s }
        bh[:key] = 'value'

        expect(bh.default(:key)).to eq('key')
        expect(bh[:key]).to eq('key')

        expect(bh.default(404)).to eq('404')
        expect(bh[404]).to eq('404')
      end
    end
  end

  describe '#default=' do
    it 'sets the default object' do
      bh = described_class.new { 'proc called' }
      expect(bh[:not_a_key]).to eq('proc called')
      expect((bh.default = 404)).to eq(404)
      expect(bh[:not_a_key]).to eq(404)
    end

    it 'raises RuntimeError if called on a frozen bihash' do
      expect { described_class.new.freeze.default = 404 }.to raise_error(RuntimeError)
    end
  end

  describe '#default_proc' do
    it 'returns the default proc if it exists' do
      bh = described_class.new { |bihash, key| bihash[key] = key }
      prc = bh.default_proc
      array = []
      prc.call(array, 2)
      expect(array).to eq([nil, nil, 2])
    end

    it 'returns nil if there is no default proc' do
      expect(described_class.new.default_proc).to be_nil
      expect(described_class.new(404).default_proc).to be_nil
    end
  end

  describe '#default_proc=' do
    it 'sets the default proc' do
      bh = described_class.new(:default_object)
      expect(bh[:not_a_key]).to eq(:default_object)
      expect(bh.default_proc = ->(_bihash, _key) { '404' }).to be_a_kind_of(Proc)
      expect(bh[:not_a_key]).to eq('404')
    end

    it 'sets the default value to nil if argument is nil' do
      bh = described_class.new(:default_object)
      expect(bh[:not_a_key]).to eq(:default_object)
      expect(bh.default_proc = nil).to be_nil
      expect(bh[:not_a_key]).to be_nil
    end

    it 'raises TypeError if not given a non-proc (except nil)' do
      expect { described_class.new.default_proc = :not_a_proc }.to raise_error(TypeError)
    end

    it 'raises TypeError given a lambda without 2 args' do
      expect { described_class.new.default_proc = -> { '404' } }.to raise_error(TypeError)
    end

    it 'raises RuntimeError if called on a frozen bihash' do
      expect { described_class[].freeze.default_proc = proc { '' } }.to raise_error(RuntimeError)
    end
  end

  describe '#delete' do
    it 'returns the other key if the given key is found' do
      expect(described_class[key: 'value'].delete(:key)).to eq('value')
      expect(described_class[key: 'value'].delete('value')).to eq(:key)
    end

    it 'removes both keys' do
      bh1 = described_class[key: 'value']
      bh1.delete(:key)
      expect(bh1).not_to include(:key)
      expect(bh1).not_to include('value')

      bh2 = described_class[key: 'value']
      bh2.delete('value')
      expect(bh2).not_to include(:key)
      expect(bh2).not_to include('value')
    end

    it 'calls the block (if given) when the key is not found' do
      out = described_class[key: 'value'].delete(404) { |key| "#{key} not found" }
      expect(out).to eq('404 not found')
    end

    it 'raises RuntimeError if called on a frozen bihash' do
      expect { described_class.new.freeze.delete(:key) }.to raise_error(RuntimeError)
    end
  end

  describe '#delete_if' do
    it 'deletes any pairs for which the block evaluates to true' do
      bh = described_class[1 => :one, 2 => :two, 3 => :three, 4 => :four]
      bh_id = bh.object_id
      expect(bh.delete_if { |key1, _key2| key1.even? }.object_id).to eq(bh_id)
      expect(bh).to eq(described_class[1 => :one, 3 => :three])
    end

    it 'raises RuntimeError if called on a frozen bihash with a block' do
      expect { described_class.new.freeze.delete_if { false } }.to raise_error(RuntimeError)
    end

    it 'returns an enumerator if not given a block' do
      enum = described_class[1 => :one, 2 => :two, 3 => :three, 4 => :four].delete_if
      expect(enum).to be_a_kind_of(Enumerator)
      expect(enum.each { |k1, _k2| k1.even? }).to eq(described_class[1 => :one, 3 => :three])
    end
  end

  describe '#dig' do
    it 'traverses nested hashes' do
      bh = described_class[foo: { bar: { baz: 4 } }]
      expect(bh.dig(:foo, :bar, :baz)).to eq(4)
    end

    it 'traverses nested arrays' do
      bh = described_class[foo: [[4]]]
      expect(bh.dig(:foo, 0, 0)).to eq(4)
    end
  end

  describe '#each' do
    it 'iterates over each pair in the bihash' do
      array = []
      described_class[k1: 'v1', k2: 'v2'].each { |pair| array << pair }
      expect(array).to eq([[:k1, 'v1'], [:k2, 'v2']])
    end

    # rubocop:disable Lint/EmptyBlock
    it 'returns the bihash if given a block' do
      bh = described_class.new
      expect(bh.each { |p| }).to be_a_kind_of(described_class)
      expect(bh.each { |p| }.object_id).to eq(bh.object_id)
    end
    # rubocop:enable Lint/EmptyBlock

    # rubocop:disable Lint/Void
    it 'returns an enumerator if not given a block' do
      enum = described_class[k1: 'v1', k2: 'v2'].each
      expect(enum).to be_a_kind_of(Enumerator)
      expect(enum.each { |pair| pair }).to eq(described_class[k1: 'v1', k2: 'v2'])
    end
    # rubocop:enable Lint/Void

    it 'is aliased to #each_pair' do
      bh = described_class.new
      expect(bh.method(:each_pair)).to eq(bh.method(:each))
    end
  end

  describe '#empty?' do
    it 'indicates if the bihash is empty' do
      expect(described_class.new.empty?).to be(true)
      expect(described_class[key: 'value'].empty?).to be(false)
    end
  end

  describe '#fetch' do
    it 'returns the other pair' do
      bh = described_class[key: 'value']
      expect(bh.fetch(:key)).to eq('value')
      expect(bh.fetch('value')).to eq(:key)
    end

    it 'returns falsey values correctly' do
      bh1 = described_class[nil => false]
      expect(bh1.fetch(nil)).to be(false)
      expect(bh1.fetch(false)).to be_nil

      bh2 = described_class[false => nil]
      expect(bh2.fetch(false)).to be_nil
      expect(bh2.fetch(nil)).to be(false)
    end

    context 'when the key is not found' do
      it 'raises KeyError when not supplied any default' do
        expect { described_class[].fetch(:not_a_key) }.to raise_error(KeyError)
      end

      it 'returns the second arg when supplied with one' do
        expect(described_class[].fetch(:not_a_key, :second_arg)).to eq(:second_arg)
      end

      it 'calls the block if supplied with one' do
        expect(described_class[].fetch(404) { |k| "#{k} not found" }).to eq('404 not found')
      end
    end
  end

  describe '#fetch_values' do
    it 'returns an array of values corresponding to the given keys' do
      expect(described_class[1 => :one, 2 => :two].fetch_values(1, 2)).to eq(%i[one two])
      expect(described_class[1 => :one, 2 => :two].fetch_values(:one, :two)).to eq([1, 2])
      expect(described_class[1 => :one, 2 => :two].fetch_values(1, :two)).to eq([:one, 2])
    end

    it 'raises a KeyError if any key is not found' do
      expect { described_class.new.fetch_values(404) }.to raise_error(KeyError)
    end

    it 'does not duplicate entries if a key equals its value' do
      expect(described_class[key: :key].fetch_values(:key)).to eq([:key])
    end

    it 'returns an empty array with no args' do
      expect(described_class[key: 'value'].fetch_values).to eq([])
    end
  end

  describe '#flatten' do
    it 'extracts the pairs into an array' do
      expect(described_class[k1: 'v1', k2: 'v2'].flatten).to eq([:k1, 'v1', :k2, 'v2'])
    end

    it 'does not flatten array keys if no argument is given' do
      expect(described_class[key: %w[v1 v2]].flatten).to eq([:key, %w[v1 v2]])
    end

    it 'flattens to the level given as an argument' do
      expect(described_class[key: %w[v1 v2]].flatten(2)).to eq([:key, 'v1', 'v2'])
    end
  end

  describe '#hash' do
    it 'returns the same hash code if two bihashes have the same pairs' do
      bh1 = described_class[k1: 1, k2: 2]
      bh2 = described_class[2 => :k2, 1 => :k1]
      expect(bh1.hash).to eq(bh2.hash)
    end
  end

  describe '#include?' do
    it 'indicates if the bihash contains the argument' do
      bh = described_class[key: 'value']
      expect(bh.include?(:key)).to be(true)
      expect(bh.include?('value')).to be(true)
      expect(bh.include?(:not_a_key)).to be(false)
    end

    it 'is aliased to #has_key?, #key?, and #member?' do
      bh = described_class.new
      expect(bh.method(:has_key?)).to eq(bh.method(:include?))
      expect(bh.method(:key?)).to eq(bh.method(:include?))
      expect(bh.method(:member?)).to eq(bh.method(:include?))
    end
  end

  describe '#keep_if' do
    it 'retains any pairs for which the block evaluates to true' do
      bh = described_class[1 => :one, 2 => :two, 3 => :three, 4 => :four]
      bh_id = bh.object_id
      expect(bh.keep_if { |key1, _key2| key1.even? }.object_id).to eq(bh_id)
      expect(bh).to eq(described_class[2 => :two, 4 => :four])
    end

    it 'raises RuntimeError if called on a frozen bihash with a block' do
      expect { described_class.new.freeze.keep_if { true } }.to raise_error(RuntimeError)
    end

    it 'returns an enumerator if not given a block' do
      enum = described_class[1 => :one, 2 => :two, 3 => :three, 4 => :four].keep_if
      expect(enum).to be_a_kind_of(Enumerator)
      expect(enum.each { |k1, _k2| k1.even? }).to eq(described_class[2 => :two, 4 => :four])
    end
  end

  describe '#length' do
    it 'returns the number of pairs in the bihash' do
      expect(described_class[1 => :one, 2 => :two].length).to eq(2)
    end
  end

  describe '#merge' do
    it 'merges bihashes, assigning each arg pair to a copy of reciever' do
      receiver = described_class[chips: :salsa, milk: :cookies, fish: :rice]
      original_receiver = receiver.dup
      argument = described_class[fish: :chips, soup: :salad]
      return_value = described_class[milk: :cookies, fish: :chips, soup: :salad]
      expect(receiver.merge(argument)).to eq(return_value)
      expect(receiver).to eq(original_receiver)
    end

    it 'raises TypeError if arg is not a bihash' do
      expect { described_class.new.merge({ key: 'value' }) }.to raise_error(TypeError)
    end
  end

  describe '#merge!' do
    it 'merges bihashes, assigning each arg pair to the receiver' do
      receiver = described_class[chips: :salsa, milk: :cookies, fish: :rice]
      argument = described_class[fish: :chips, soup: :salad]
      return_value = described_class[milk: :cookies, fish: :chips, soup: :salad]
      expect(receiver.merge!(argument)).to eq(return_value)
      expect(receiver).to eq(return_value)
    end

    it 'raises RuntimeError if called on a frozen bihash' do
      expect { described_class.new.freeze.merge!(described_class.new) }.to raise_error(RuntimeError)
    end

    it 'raises TypeError if arg is not a bihash' do
      expect { described_class.new.merge!({ key: 'value' }) }.to raise_error(TypeError)
    end

    it 'is aliased to #update' do
      bh = described_class.new
      expect(bh.method(:update)).to eq(bh.method(:merge!))
    end
  end

  describe '#rehash' do
    it 'recomputes all key hash values and return the bihash' do
      bh = described_class[[] => :array]
      bh[:array] << 1
      expect(bh[[1]]).to be_nil
      expect(bh.rehash[[1]]).to eq(:array)
      expect(bh[[1]]).to eq(:array)
    end

    it 'raises RuntimeError if called on a frozen bihash' do
      expect { described_class.new.freeze.rehash }.to raise_error(RuntimeError)
    end

    it 'raises RuntimeError if called when key duplicated outside pair' do
      bh = described_class[[1], [2], [3], [4]]
      (bh[[4]] << 1).shift
      expect { bh.rehash }.to raise_error(RuntimeError)
    end
  end

  describe '#reject' do
    context 'when some items are rejected' do
      it 'returns a bihash with items not rejected by the block' do
        bh = described_class[1 => :one, 2 => :two, 3 => :three, 4 => :four]
        expect(bh.reject { |k1, _k2| k1.even? }).to eq described_class[1 => :one, 3 => :three]
      end
    end

    context 'when no items are rejected' do
      it 'returns a bihash with items not rejected by the block' do
        bh = described_class[1 => :one, 3 => :three, 5 => :five, 7 => :seven]
        expect(bh.reject { |k1, _k2| k1.even? }).to eq(bh)
      end
    end

    it 'returns an enumerator if not given a block' do
      enum = described_class[1 => :one, 2 => :two, 3 => :three, 4 => :four].reject
      expect(enum).to be_a_kind_of(Enumerator)
      expect(enum.each { |k1, _k2| k1.even? }).to eq(described_class[1 => :one, 3 => :three])
    end
  end

  describe '#reject!' do
    it 'deletes any pairs for which the block evaluates to true' do
      bh = described_class[1 => :one, 2 => :two, 3 => :three, 4 => :four]
      bh_id = bh.object_id
      expect(bh.reject! { |key1, _key2| key1.even? }.object_id).to eq(bh_id)
      expect(bh).to eq(described_class[1 => :one, 3 => :three])
    end

    it 'returns nil if no changes were made to the bihash' do
      bh = described_class[1 => :one, 2 => :two, 3 => :three, 4 => :four]
      expect(bh.reject! { |key1, _key2| key1 > 5 }).to be_nil
      expect(bh).to eq(described_class[1 => :one, 2 => :two, 3 => :three, 4 => :four])
    end

    it 'raises RuntimeError if called on a frozen bihash with a block' do
      expect { described_class.new.freeze.reject! { false } }.to raise_error(RuntimeError)
    end

    it 'returns an enumerator if not given a block' do
      enum = described_class[1 => :one, 2 => :two, 3 => :three, 4 => :four].reject!
      expect(enum).to be_a_kind_of(Enumerator)
      expect(enum.each { |k1, _k2| k1.even? }).to eq(described_class[1 => :one, 3 => :three])
    end
  end

  describe '#replace' do
    it 'replaces the contents of receiver with the contents of the arg' do
      receiver = described_class[]
      original_id = receiver.object_id
      arg = described_class[key: 'value']
      expect(receiver.replace(arg)).to eq(described_class[key: 'value'])
      arg[:another_key] = 'another_value'
      expect(receiver.object_id).to eq(original_id)
      expect(receiver).to eq(described_class[key: 'value'])
    end

    it 'raises TypeError if arg is not a bihash' do
      expect { described_class.new.replace({ key: 'value' }) }.to raise_error(TypeError)
    end

    it 'raises RuntimeError if called on a frozen bihash' do
      expect { described_class.new.freeze.replace(described_class[:k, 'v']) }.to raise_error(RuntimeError)
    end
  end

  describe '#select' do
    context 'when all items are selected' do
      it 'returns a bihash with items selected by the block' do
        bh = described_class[2 => :two, 4 => :four, 6 => :six, 8 => :eight]
        expect(bh.select { |k1, _k2| k1.even? }).to eq(bh)
      end
    end

    it 'returns an enumerator if not given a block' do
      enum = described_class[1 => :one, 2 => :two, 3 => :three, 4 => :four].select
      expect(enum).to be_a_kind_of(Enumerator)
      expect(enum.each { |k1, _k2| k1.even? }).to eq(described_class[2 => :two, 4 => :four])
    end

    it 'is aliased to #filter' do
      bh = described_class.new
      expect(bh.method(:filter)).to eq(bh.method(:select))
    end
  end

  describe '#select!' do
    it 'retains any pairs for which the block evaluates to true' do
      bh = described_class[1 => :one, 2 => :two, 3 => :three, 4 => :four]
      bh_id = bh.object_id
      expect(bh.select! { |key1, _key2| key1.even? }.object_id).to eq(bh_id)
      expect(bh).to eq(described_class[2 => :two, 4 => :four])
    end

    it 'returns nil if no changes were made to the bihash' do
      bh = described_class[1 => :one, 2 => :two, 3 => :three, 4 => :four]
      expect(bh.select! { |key1, _key2| key1 < 5 }).to be_nil
      expect(bh).to eq(described_class[1 => :one, 2 => :two, 3 => :three, 4 => :four])
    end

    it 'raises RuntimeError if called on a frozen bihash with a block' do
      expect { described_class.new.freeze.select! { true } }.to raise_error(RuntimeError)
    end

    it 'returns an enumerator if not given a block' do
      enum = described_class[1 => :one, 2 => :two, 3 => :three, 4 => :four].select!
      expect(enum).to be_a_kind_of(Enumerator)
      expect(enum.each { |k1, _k2| k1.even? }).to eq(described_class[2 => :two, 4 => :four])
    end

    it 'is aliased to #filter!' do
      bh = described_class.new
      expect(bh.method(:filter!)).to eq(bh.method(:select!))
    end
  end

  describe '#shift' do
    it 'removes the oldest pair from the bihash and return it' do
      bh = described_class[1 => :one, 2 => :two, 3 => :three]
      expect(bh.shift).to eq([1, :one])
      expect(bh).to eq(described_class[2 => :two, 3 => :three])
    end

    it 'returns the default value if bihash is empty' do
      expect(described_class.new.shift).to be_nil
      expect(described_class.new(404).shift).to eq(404)
      expect(described_class.new { 'd3f4u17' }.shift).to eq('d3f4u17')
    end

    it 'raises RuntimeError if called on a frozen bihash' do
      expect { described_class.new.freeze.shift }.to raise_error(RuntimeError)
    end
  end

  describe '#size' do
    it 'returns the number of pairs in the bihash' do
      expect(described_class[1 => :one, 2 => :two].size).to eq(2)
    end
  end

  describe '#slice' do
    it 'returns a new bihash with only the pairs that are in the args' do
      bh = described_class[1 => :one, 2 => :two, 3 => :three]
      expect(bh.slice(1, :one, :two, 'nope')).to eq(described_class[1 => :one, 2 => :two])
      expect(bh).to eq(described_class[1 => :one, 2 => :two, 3 => :three])
    end

    it 'returns a vanilla bihash without default values, etc.' do
      sliced_bh = described_class.new(404).slice
      expect(sliced_bh.default).to be_nil
    end
  end

  describe '#to_h' do
    it 'returns a copy of the forward hash' do
      bh = described_class[key1: 'val1', key2: 'val2']
      h = bh.to_h
      expect(h).to eq({ key1: 'val1', key2: 'val2' })
      h.delete(:key1)
      expect(bh).to include(:key1)
    end

    it 'is aliased to #to_hash' do
      bh = described_class.new
      expect(bh.method(:to_hash)).to eq(bh.method(:to_h))
    end
  end

  describe '#to_proc' do
    it 'converts the bihash to a proc' do
      expect(described_class[].to_proc).to be_a_kind_of(Proc)
    end

    it 'calls #[] on the bihash when the proc is called' do
      expect(described_class[key: 'value'].to_proc.call(:key)).to eq('value')
    end
  end

  describe '#to_s' do
    it 'returns a nice string representing the bihash' do
      bh = described_class[k1: 'v1', k2: [:v2], k3: { k4: 'v4' }]
      expect(bh.to_s).to eq('Bihash[:k1=>"v1", :k2=>[:v2], :k3=>{:k4=>"v4"}]')
    end

    it 'is aliased to #inspect' do
      bh = described_class.new
      expect(bh.method(:inspect)).to eq(bh.method(:to_s))
    end
  end

  describe '#values_at' do
    it 'returns an array of values corresponding to the given keys' do
      expect(described_class[1 => :one, 2 => :two].values_at(1, 2)).to eq(%i[one two])
      expect(described_class[1 => :one, 2 => :two].values_at(:one, :two)).to eq([1, 2])
      expect(described_class[1 => :one, 2 => :two].values_at(1, :two)).to eq([:one, 2])
    end

    it 'uses the default if a given key is not found' do
      bh = described_class.new(404)
      bh[1] = :one
      bh[2] = :two
      expect(bh.values_at(1, 2, 3)).to eq([:one, :two, 404])
      expect(bh.values_at(:one, :two, :three)).to eq([1, 2, 404])
    end

    it 'does not duplicate entries if a key equals its value' do
      expect(described_class[key: :key].values_at(:key)).to eq([:key])
    end

    it 'returns an empty array with no args' do
      expect(described_class[key: 'value'].values_at).to eq([])
    end
  end

  describe '#initialize' do
    it 'raises RuntimeError if called on a frozen bihash' do
      expect { described_class.new.freeze.send(:initialize) }.to raise_error(RuntimeError)
    end
  end
end
# rubocop:enable Metrics/BlockLength
# rubocop:enable Lint/BinaryOperatorWithIdenticalOperands
