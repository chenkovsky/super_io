# Super IO

make object serializable via to_io from_io.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  super_io:
    github: chenkovsky/super_io
```

## Usage

```crystal
require "super_io"
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
```


## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/chenkovsky/super_io/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [chenkovsky](https://github.com/chenkovsky) chenkovsky - creator, maintainer
