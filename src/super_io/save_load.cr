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

  macro reflect_save_load
    def to_disk(path : String, format = IO::ByteFormat::LittleEndian) : Void
      File.open(path, "wb") do |f|
        rto_io f, format
      end
    end

    def save(path : String, format = IO::ByteFormat::LittleEndian) : Void
      to_disk(path, format)
    end
    def self.from_disk(path : String, format = IO::ByteFormat::LittleEndian) : self
      File.open(path, "rb") do |f|
        self.rfrom_io f, format
      end
    end

    def self.load(path : String, format = IO::ByteFormat::LittleEndian) : self
      from_disk(path, format)
    end
  end

  macro reflect_io
    alias SuperIOReflectBase =  self
    SuperIOLoader = {} of String => ((IO, IO::ByteFormat) -> self)

    def rto_io(io : IO, format : IO::ByteFormat)
      SuperIO.to_io(self.class.name, io, format)
      self.to_io(io, format)
    end

    def self.rfrom_io(io : IO, format : IO::ByteFormat) : self
      cls_name = SuperIO.from_io(String, io, format)
      SuperIOLoader[cls_name].call(io, format)
    end
    # 用于反射
    macro inherited
      SuperIOLoader["\{{@type.name}}"] = ->(io : IO, format : IO::ByteFormat){
        self.from_io(io, format).as(SuperIOReflectBase)
      }
    end
  end
end
