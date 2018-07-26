module SuperIO
  module Save
    def to_disk(path : String, format = IO::ByteFormat::LittleEndian) : Void
      File.open(path, "wb") do |f|
        to_io f, format
      end
    end

    def save(path : String, format = IO::ByteFormat::LittleEndian) : Void
      to_disk(path, format)
    end
  end

  module Load
    def from_disk(path : String, format = IO::ByteFormat::LittleEndian) : self
      File.open(path, "rb") do |f|
        self.from_io f, format
      end
    end

    def load(path : String, format = IO::ByteFormat::LittleEndian) : self
      from_disk(path, format)
    end
  end
end
