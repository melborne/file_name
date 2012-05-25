require_relative "filename/version"

module FileName
  class NameError < StandardError; end
  
  attr_reader :filename, :sep
  attr_accessor :content
  alias :to_s :filename
  def fdir
    File.dirname(to_s)
  end

  def fbasex
    File.basename(to_s, '')
  end

  def fbase(suffix='.*')
    File.basename(to_s, suffix)
  end

  def fext
    File.extname(to_s).to_nil #return nil when extname is empty
  end

  def fexto
    ext.sub(/^\./, '')
  end

  def fsplit
    [fdir, fbase, fext]
  end

  def fchop(n=1)
    sep = File::SEPARATOR
    name = fchop_ext.split(sep).push(fext).compact[0..-(n+1)].join(sep)
    self.class.new name
  end

  def fchop_ext
    return self.to_s unless fext
    self.to_s.sub(/#{fext}$/, '')
  end

  def fexist?
    File.exist?(to_s)
  end

  def fexpand(base='.')
    File.expand_path(to_s, base)
  end

  def to_file
    File.new(to_s)
  rescue Errno::ENOENT
    require "fileutils"
    Dir.exists?(dir) || FileUtils.mkdir_p(dir)
    File.open(to_s, 'w') do |f|
      f.write content
    end
    retry
  end

  class FileName
    include ::FileName
    alias :dir :fdir
    alias :base :fbase
    alias :basex :fbasex
    alias :ext :fext
    alias :exto :fexto
    alias :split :fsplit
    alias :chop :fchop
    alias :exist? :fexist?
    alias :chop_ext :fchop_ext
    alias :expand :fexpand
    def initialize(str, opt={})
      opt = {sep: File::SEPARATOR, content: ''}.merge(opt)
      @sep = opt[:sep]
      raise NameError if str.end_with?(sep)
      @content = opt[:content]
      @filename = str
    end

    def sequence(suffix=nil)
      Enumerator.new do |y|
        name = "#{chop_ext}#{suffix}"
        loop {
          y << self.class.new([name, ext].join, sep:@sep, content:@content)
          name = name.next
        }
      end
    end
  end
end

class String
  def to_nil
    empty? ? nil : self
  end

  def to_filename
    FileName::FileName.new self
  end

  def to_file
    to_filename.to_file
  end
end

class Array
  def fjoin
    File.join(*self)
  end
end