# rubocop:disable Metrics/ClassLength
class Bihash
  include Enumerable
  extend Forwardable

  attr_reader :forward, :reverse

  def_delegator :@forward, :compare_by_identity?
  def_delegator :@forward, :flatten
  def_delegator :@forward, :size
  def_delegator :@forward, :length
  def_delegator :@forward, :empty?

  def self.[](*args)
    new_from_hash(Hash[*args])
  end

  def self.try_convert(arg)
    h = Hash.try_convert(arg)
    h && new_from_hash(h)
  end

  %w[< <= == >= >].each do |operator|
    define_method(operator) do |rhs|
      raise_error_unless_bihash(rhs)
      # rubocop:disable Security/Eval, Style/DocumentDynamicEvalDefinition, Style/EvalWithLocation
      eval "#{merged_hash_attrs} #{operator} #{rhs.send(:merged_hash_attrs)}"
      # rubocop:enable Security/Eval, Style/DocumentDynamicEvalDefinition, Style/EvalWithLocation
    end
  end

  def [](key)
    if @forward.key?(key)
      @forward[key]
    elsif @reverse.key?(key)
      @reverse[key]
    else
      default_value(key)
    end
  end

  def []=(key1, key2)
    raise_error_if_frozen
    delete(key1)
    delete(key2)
    @reverse[key2] = key1
    @forward[key1] = key2
  end

  def assoc(key)
    @forward.assoc(key) || @reverse.assoc(key)
  end

  def clear
    raise_error_if_frozen
    @forward.clear
    @reverse.clear
    self
  end

  def compare_by_identity
    raise_error_if_frozen
    @forward.compare_by_identity
    @reverse.compare_by_identity
    self
  end

  def default(*args)
    case args.count
    when 0
      @default
    when 1
      default_value(args[0])
    else
      raise ArgumentError, "wrong number of arguments (#{args.size} for 0..1)"
    end
  end

  def default=(default)
    raise_error_if_frozen
    @default_proc = nil
    @default = default
  end

  def delete(key)
    raise_error_if_frozen
    if @forward.key?(key)
      @reverse.delete(@forward[key])
      @forward.delete(key)
    else
      @forward.delete(@reverse[key])
      @reverse.delete(key)
    end
  end

  def dig(*keys)
    (@forward.key?(keys[0]) ? @forward : @reverse).dig(*keys)
  end

  def each(&block)
    if block
      @forward.each(&block)
      self
    else
      to_enum(:each)
    end
  end

  def fetch(key, *default, &block)
    (@forward.key?(key) ? @forward : @reverse).fetch(key, *default, &block)
  end

  def fetch_values(*keys)
    keys.map { |key| fetch(key) }
  end

  def filter(&block)
    if block
      dup.tap { |d| d.filter(&block) }
    else
      to_enum(:filter)
    end
  end

  def key?(arg)
    @forward.key?(arg) || @reverse.key?(arg)
  end

  alias include? key?
  alias member? key?

  def hash
    self.class.hash ^ merged_hash_attrs.hash
  end

  def inspect
    "Bihash[#{@forward.to_s[1..-2]}]"
  end

  alias to_s inspect

  def merge(other_bh)
    dup.merge!(other_bh)
  end

  def merge!(other_bh)
    raise_error_if_frozen
    raise_error_unless_bihash(other_bh)
    other_bh.each { |k, v| store(k, v) }
    self
  end

  def rehash
    raise_error_if_frozen
    raise 'Cannot rehash while a key is duplicated outside its own pair' if illegal_state?

    @forward.rehash
    @reverse.rehash
    self
  end

  def to_h
    @forward.dup
  end

  alias to_hash to_h

  def values_at(*keys)
    keys.map { |key| self[key] }
  end

  private

  def self.new_from_hash(hash)
    bihash = new
    bihash.instance_variable_set(:@reverse, hash.invert)
    bihash.instance_variable_set(:@forward, hash)
    raise ArgumentError, 'A key would be duplicated outside its own pair' if bihash.send(:illegal_state?)

    bihash
  end
  private_class_method :new_from_hash

  def default_value(key)
    @default_proc ? @default_proc.call(self, key) : @default
  end

  def illegal_state?
    fw = @forward
    (fw.keys | fw.values).size + fw.count { |k, v| k == v } < fw.size * 2
  end

  def initialize(*args, &block)
    raise_error_if_frozen
    raise ArgumentError, "wrong number of arguments (#{args.size} for 0)" if block && !args.empty?
    raise ArgumentError, "wrong number of arguments (#{args.size} for 0..1)" if args.size > 1

    super()
    @forward = {}
    @reverse = {}
    @default = args[0]
    @default_proc = block
  end

  def merged_hash_attrs
    @reverse.merge(@forward)
  end

  def raise_error_if_frozen
    raise "can't modify frozen Bihash" if frozen?
  end

  def raise_error_unless_bihash(obj)
    raise TypeError, "wrong argument type #{obj.class} (expected Bihash)" unless obj.is_a?(Bihash)
  end
end
# rubocop:enable Metrics/ClassLength
