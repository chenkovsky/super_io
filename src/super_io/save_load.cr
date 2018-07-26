module SuperIO
  macro save_load
    def to_disk(path : String, format = IO::ByteFormat::LittleEndian) : Void
      File.open(path, "wb") do |f|
        to_io f, format
      end
    end

    def save(path : String, format = IO::ByteFormat::LittleEndian) : Void
      to_disk(path, format)
    end
    def self.from_disk(path : String, format = IO::ByteFormat::LittleEndian) : self
      File.open(path, "rb") do |f|
        self.from_io f, format
      end
    end

    def self.load(path : String, format = IO::ByteFormat::LittleEndian) : self
      from_disk(path, format)
    end
  end
end
