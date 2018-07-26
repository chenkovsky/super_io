module SuperIO
  module Save
    def to_disk(path : String, format = IO::ByteFormat::LittleEndian) : Void
      File.open(path, "wb") do |f|
        to_io f, format
      end
    end
  end

  module Load
    def from_disk(path : String, format = IO::ByteFormat::LittleEndian) : self
      File.open(path, "rb") do |f|
        self.from_io f, format
      end
    end
  end
end
