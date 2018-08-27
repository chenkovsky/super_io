require "./super_io/*"

# TODO: Write documentation for `SuperIo`
module SuperIO
  # TODO: Put your code here
  extend self

  def to_io(hash : Hash(K, V), io : IO, format : IO::ByteFormat) forall K, V
    hash.size.to_io io, format
    hash.each do |k, v|
      to_io k, io, format
      to_io v, io, format
    end
  end

  def from_io(cls : Hash(K, V).class, io : IO, format : IO::ByteFormat) forall K, V
    size = from_io Int32, io, format
    hash = Hash(K, V).new(initial_capacity: size)
    (0...size).each do |i|
      k = from_io K, io, format
      v = from_io V, io, format
      hash[k] = v
    end
    hash
  end

  def to_io(arr : Array(E) | Slice(E), io : IO, format : IO::ByteFormat) forall E
    to_io arr.size, io, format
    if {{ E < Reference }}
      arr.each do |e|
        to_io e, io, format
      end
    else
      (0...arr.size).each do |idx|
        to_io (arr.to_unsafe + idx), io, format
      end
    end
  end

  def from_io(arr : Array(E).class, io : IO, format : IO::ByteFormat) forall E
    size = from_io Int32, io, format
    ret = Array(E).new(size) { |_| from_io E, io, format }
    ret
  end

  def from_io(arr : Slice(E).class, io : IO, format : IO::ByteFormat) forall E
    size = from_io Int32, io, format
    ret = Slice(E).new(size) { |_| from_io E, io, format }
    ret
  end

  def from_io(arr : Array(String).class, io : IO, format : IO::ByteFormat)
    size = from_io Int32, io, format
    bytes = Array(UInt8).new
    ret = Array(String).new(size) { |_| from_io String, io, format, bytes }
    ret
  end

  def from_io(arr : Slice(String).class, io : IO, format : IO::ByteFormat)
    size = from_io Int32, io, format
    bytes = Array(UInt8).new
    ret = Slice(String).new(size) { |_| from_io String, io, format, bytes }
    ret
  end

  @[AlwaysInline]
  def to_io(i : Pointer(T), io : IO, format : IO::ByteFormat) forall T
    to_io i.value, io, format
  end

  def ptr_from_io(t : Pointer(T).class, io : IO, format : IO::ByteFormat) forall T
    size = from_io Int64, io, format
    capacity = yield size
    ret = t.malloc(capacity)
    (0...size).each { |i| ret[i] = from_io T, io, format }
    return ret, size, capacity
  end

  def ptr_from_io(t : Pointer(T).class, io : IO, format : IO::ByteFormat) forall T
    size = from_io Int64, io, format
    capacity = Math.pw2ceil(size)
    ret = t.malloc(capacity)
    (0...size).each { |i| ret[i] = from_io T, io, format }
    return ret, size, capacity
  end

  def ptr_to_io(ptr : Pointer(T), size : Int, io : IO, format : IO::ByteFormat) forall T
    to_io size.to_i64, io, format
    (0...size).each do |idx|
      to_io (ptr + idx), io, format
    end
  end

  @[AlwaysInline]
  def to_io(v : T, io : IO, format : IO::ByteFormat) forall T
    v.to_io io, format
  end

  @[AlwaysInline]
  def from_io(t, io : IO, format : IO::ByteFormat)
    t.from_io io, format
  end

  @[AlwaysInline]
  def to_io(i : Char, io : IO, format : IO::ByteFormat) forall T
    to_io i.ord, io, format
  end

  @[AlwaysInline]
  def from_io(t : Char.class, io : IO, format : IO::ByteFormat) forall T
    (Char::ZERO + from_io(Int32, io, format))
  end

  @[AlwaysInline]
  def to_io(i : Int, io : IO, format : IO::ByteFormat)
    i.to_io io, format
  end

  @[AlwaysInline]
  def from_io(t : Int.class, io : IO, format : IO::ByteFormat)
    t.from_io io, format
  end

  @[AlwaysInline]
  def to_io(s : String, io : IO, format : IO::ByteFormat)
    io.print s
    io.write_byte 0_u8
  end

  @[AlwaysInline]
  def to_io(r : Regex, io : IO, format : IO::ByteFormat)
    to_io r.to_s, io, format
  end

  @[AlwaysInline]
  def to_io(s : Bool, io : IO, format : IO::ByteFormat)
    (s ? 1_u8 : 0_u8).to_io io, format
  end

  @[AlwaysInline]
  def from_io(t : Bool.class, io : IO, format : IO::ByteFormat)
    b = UInt8.from_io io, format
    b != 0_u8
  end

  @[AlwaysInline]
  def from_io(t : Regex.class, io : IO, format : IO::ByteFormat)
    str = from_io String, io, format
    return Regex.new str
  end

  def from_io(t : String.class, io : IO, format : IO::ByteFormat, bytes = Array(UInt8).new)
    s = io.read_utf8_byte.not_nil!
    while s != 0
      bytes << s
      s = io.read_utf8_byte.not_nil!
    end
    return String.new(bytes.to_unsafe, bytes.size)
  end
end
