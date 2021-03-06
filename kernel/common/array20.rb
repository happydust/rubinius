# -*- encoding: us-ascii -*-

class Array
  def sample(count=undefined, options=undefined)
    return at Kernel.rand(size) if count.equal? undefined

    if options.equal? undefined
      if o = Rubinius::Type.check_convert_type(count, Hash, :to_hash)
        options = o
        count = nil
      else
        options = nil
        count = Rubinius::Type.coerce_to count, Fixnum, :to_int
      end
    else
      count = Rubinius::Type.coerce_to count, Fixnum, :to_int
      options = Rubinius::Type.coerce_to options, Hash, :to_hash
    end

    if count and count < 0
      raise ArgumentError, "count must be greater than 0"
    end

    rng = options[:random] if options
    rng = Kernel unless rng and rng.respond_to? :rand

    unless count
      random = Rubinius::Type.coerce_to rng.rand, Fixnum, :to_int
      raise RangeError, "random value must be >= 0" if random < 0
      raise RangeError, "random value must be less than Array size" unless random < size

      return at random
    end

    count = size if count > size
    result = Array.new self

    count.times do |i|
      random = Rubinius::Type.coerce_to rng.rand, Fixnum, :to_int
      raise RangeError, "random value must be >= 0" if random < 0
      raise RangeError, "random value must be less than Array size" unless random < size

      result.tuple.swap i, random
    end

    return count == size ? result : result[0, count]
  end
end
