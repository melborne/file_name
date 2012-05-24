require_relative "filename/version"

class FileName
  class NameError < StandardError; end
  
  attr_reader :filename, :sep
  attr_accessor :content
  alias :to_s :filename
  def initialize(str, opt={})
    opt = {sep: File::SEPARATOR, content: ''}.merge(opt)
    @sep = opt[:sep]
    raise NameError if str.end_with?(sep)
    @content = opt[:content]
    @filename = str
  end

  def dir
    File.dirname(to_s)
  end

  def basex
    File.basename(to_s, '')
  end

  def base(suffix='.*')
    File.basename(to_s, suffix)
  end

  def ext
    File.extname(to_s)
  end

  def exto
    ext.sub(/^\./, '')
  end

  def split
    [dir, base, ext]
  end

  def chop(n=1)
    ext = self.ext
    name = self.to_s.sub(/#{ext}$/, '')
    name = name.split('/').push(ext.to_nil).compact[0..-(n+1)].join(@sep)
    self.class.new name, sep:@sep, content:@content
  end

  def exist?
    File.exist?(to_s)
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

  def each(suffix=nil)
    Enumerator.new do |y|
      name = "#{chop}#{suffix}"
      loop {
        y << self.class.new([name, ext].join, sep:@sep, content:@content)
        name = name.next
      }
    end
  end

  def self.join(items, sep=File::SEPARATOR)
    new items.join(sep), sep:sep
  end
end

class String
  def to_nil
    empty? ? nil : self
  end

  def to_filename(sep=nil)
    FileName.new self, sep:sep
  end

  def to_file(sep=nil)
    self.to_filename(sep).to_file
  end
end
