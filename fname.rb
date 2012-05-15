class FileName
  attr_reader :filename
  alias :to_s :filename
  def initialize(str)
    @filename = str
  end

  def dir
    File.dirname(to_s)
  end

  def basex(suffix="")
    File.basename(to_s, suffix)
  end

  def base
    File.basename(to_s, '.*')
  end

  def ext
    File.extname(to_s)
  end

  def split
    [dir, base, ext]
  end

  def chop(n=1)
    to_s.split('/')[0..-(n+1)].join('/')
  end
end

class String
  def to_filename
    FileName.new self
  end
end

fn = 'abc/hello/abc.rb'.to_filename

fn.dir # => "abc/hello"
fn.basex # => "abc.rb"
fn.base # => "abc"
fn.ext # => ".rb"
fn.split # => ["abc/hello", "abc", ".rb"]
fn.chop # => "abc/hello"
puts fn

# >> abc/hello/abc.rb
