class FileName
  class NameError < StandardError; end
  
  attr_reader :filename
  alias :to_s :filename
  def initialize(str, sep=nil)
    @sep = sep || File::SEPARATOR
    raise NameError if str.end_with?(@sep)
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

  def split
    [dir, base, ext]
  end

  def chop(n=1)
    to_s.split(@sep)[0..-(n+1)].join(@sep).to_filename(@sep)
  end

  def exist?
    File.exist?(to_s)
  end

  def to_file
    File.new(to_s)
  rescue Errno::ENOENT
    require "fileutils"
    Dir.exist?(dir) || FileUtils.mkdir_p(dir)
    system("touch #{to_s}")
    retry
  end

  def each(suffix=nil)
    Enumerator.new do |y|
      name = "#{chop}#{suffix}"
      loop {
        y << [name, ext].join
        name = name.next
      }
    end
  end

  def self.join(items, sep=nil)
    sep = sep || File::SEPARATOR
    items.join(sep).to_filename
  end
end

class String
  def to_filename(sep=nil)
    FileName.new self, sep
  end

  def to_file(sep=nil)
    self.to_filename(sep).to_file
  end
end

if __FILE__ == $0
  fn = 'abc/hello/abc.rb'.to_filename

  puts fn.each('00').take(10)

  fn.dir # => "abc/hello"
  fn.basex # => "abc.rb"
  fn.base # => "abc"
  fn.ext # => ".rb"
  fn.split # => ["abc/hello", "abc", ".rb"]
  fn2 = fn.chop # => abc/hello
  fn2.chop # => abc
  fn.chop(2) # => abc
  fn.exist? # => true
  fn.to_file # => #<File:abc/hello/abc.rb>
  fn.exist? # => true
  puts fn
  p FileName.join(%w(a b c.rb))
end
