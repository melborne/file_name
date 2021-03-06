require_relative "file_name/version"
autoload :FileUtils, "fileutils"

module FileName
  class NameError < StandardError; end
  
  SEP = File::SEPARATOR
  def fdir
    File.dirname(to_s)
  end

  def fbasex
    fbase('')
  end

  def fbase(suffix='.*')
    File.basename(to_s, suffix)
  end

  def fext
    ext = File.extname(to_s)
    ext.empty? ? nil : ext
  end

  def fexto
    fext.sub(/^\./, '')
  end

  def fsplit
    [fdir, fbase, fext]
  end

  def fchop(n=1)
    name = fchop_ext.split(SEP).push(fext).compact[0..-(n+1)].join(SEP)
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

  def to_filename(content='')
    return self if is_a?(FileName)
    FileName.new to_s, content:content
  end

  def to_file(text=nil, mode='w', perm=0666, &blk)
    File.open(to_s, &blk)
  rescue Errno::ENOENT
    Dir.exists?(fdir) || FileUtils.mkdir_p(fdir)
    File.open(to_s, mode) do |f|
      f.puts content if respond_to?(:content) && !content.empty?
      f.puts text if text
    end
    retry
  end

  def to_dir(flags=0, &blk)
    Dir.glob(to_s, flags, &blk)
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
    attr_accessor :content
    attr_reader :filename, :sep
    alias :to_s :filename
    def initialize(str, opt={})
      opt = {sep: SEP, content: ''}.merge(opt)
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

class Array
  def fjoin
    File.join(*self)
  end
end
