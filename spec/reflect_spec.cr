require "./spec_helper"

class Base
  SuperIO.reflect_io
end

class Sub1 < Base
  def to_io(io, format)
  end

  def self.from_io(io, format)
    Sub1.new
  end
end

class Sub2 < Base
  def to_io(io, format)
  end

  def self.from_io(io, format)
    Sub2.new
  end
end

describe SuperIO do
  it "reflect io" do
    s1 = Sub1.new
    s2 = Sub2.new
    File.open("tmp.bin", "wb") do |fo|
      s1.rto_io(fo, IO::ByteFormat::LittleEndian)
      s2.rto_io(fo, IO::ByteFormat::LittleEndian)
    end

    File.open("tmp.bin", "rb") do |fi|
      Base.rfrom_io(fi, IO::ByteFormat::LittleEndian).is_a?(Sub1)
      Base.rfrom_io(fi, IO::ByteFormat::LittleEndian).is_a?(Sub2)
    end
  end
end
