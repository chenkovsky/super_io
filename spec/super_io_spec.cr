require "./spec_helper"

describe SuperIO do
  # TODO: Write tests

  it "string hash" do
    hs = {"a" => "b", "c" => "d"}
    File.open("tmp.bin", "wb") do |io|
      SuperIO.to_io hs, io, IO::ByteFormat::LittleEndian
    end
    hs2 = File.open("tmp.bin", "rb") do |io|
      SuperIO.from_io Hash(String, String), io, IO::ByteFormat::LittleEndian
    end
    hs2.should eq(hs)
  end

  it "char array" do
    arr = ['a', 'b', 'c']
    File.open("tmp.bin", "wb") do |io|
      SuperIO.to_io arr, io, IO::ByteFormat::LittleEndian
    end
    arr2 = File.open("tmp.bin", "rb") do |io|
      SuperIO.from_io Array(Char), io, IO::ByteFormat::LittleEndian
    end
    arr2.should eq(arr)
  end

  it "string array" do
    arr = ["a", "b", "c"]
    File.open("tmp.bin", "wb") do |io|
      SuperIO.to_io arr, io, IO::ByteFormat::LittleEndian
    end
    arr2 = File.open("tmp.bin", "rb") do |io|
      SuperIO.from_io Array(String), io, IO::ByteFormat::LittleEndian
    end
    arr2.should eq(arr)
  end

  it "two string array" do
    arr = ["a", "b", "c"]
    arr_ = ["e", "f", "g"]
    File.open("tmp.bin", "wb") do |io|
      SuperIO.to_io arr, io, IO::ByteFormat::LittleEndian
      SuperIO.to_io arr_, io, IO::ByteFormat::LittleEndian
    end
    arr2, arr_2 = File.open("tmp.bin", "rb") do |io|
      a1 = SuperIO.from_io Array(String), io, IO::ByteFormat::LittleEndian
      a2 = SuperIO.from_io Array(String), io, IO::ByteFormat::LittleEndian
      {a1, a2}
    end
    arr2.should eq(arr)
    arr_2.should eq(arr_)
  end
end
