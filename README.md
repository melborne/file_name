# FileName

FileName is a utility for handling filename strings which can be alternative of some File class methods.

## Installation

Add this line to your application's Gemfile:

    gem 'filename'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install filename

## Usage
You can create FileName object with `FileName.new`.

    require 'filename'
    
    path = 'path/to/hello.rb'
    
    fn = FileName::FileName.new(path)
    
    fn # => path/to/hello.rb

    # get directory name
    fn.dir # => "path/to"

    # get file base name
    fn.base # => "hello"

    # get file base name with extension
    fn.basex # => "hello.rb"
    
    # get file extension
    fn.ext # => ".rb"
    
    # get file extension without dot(.)
    fn.exto # => "rb"

    # split file directory, basename and extension
    fn.split # => ["path/to", "hello", ".rb"]

    # get file expand path
    fn.expand # => "/Users/melborne/filename/example/path/to/hello.rb"
    
    # chop portion of path name recursively
    fn.chop # => path/to/hello
    fn.chop(2).chop # => path
    
    # set file content
    fn.content = "hello, world!"
    
    # check file existance correnspond to a filename
    fn.exist? # => true

    # create a file object from filename object
    fn.to_file # => #<File:path/to/hello.rb>

    # check file existance after file creation with to_file method
    fn.exist? # => true
    File.open(path) do |f|
      f.read # => "hello, world!"
    end

You can produce sequencial file names with `FileName#sequence`.

    # without argument, end character of the base name is incremented
    fn.sequence.take(10) # => [path/to/hello.rb, path/to/hellp.rb, path/to/hellq.rb, path/to/hellr.rb, path/to/hells.rb, path/to/hellt.rb, path/to/hellu.rb, path/to/hellv.rb, path/to/hellw.rb, path/to/hellx.rb]
    
    # with argument, it attach to the end of base name, then incremented
    fn.sequence('00').take(10) # => [path/to/hello00.rb, path/to/hello01.rb, path/to/hello02.rb, path/to/hello03.rb, path/to/hello04.rb, path/to/hello05.rb, path/to/hello06.rb, path/to/hello07.rb, path/to/hello08.rb, path/to/hello09.rb]

After include FileName Module to String class, you can use above instance methods to string object with prefix of `f`.

    String.send(:include, FileName)
    
    path = 'path/to/goodbye.rb'
    
    path.fdir # => "path/to"
    path.fbase # => "goodbye"
    path.fbasex # => "goodbye.rb"
    path.fext # => ".rb"
    path.fexto # => "rb"
    path.fsplit # => ["path/to", "goodbye", ".rb"]
    path.fexpand # => "/Users/melborne/filename/example/path/to/goodbye.rb"

    path.fchop # => "path/to/goodbye"
    path.fchop(2).fchop # => "path"
    
    path.fexist? # => false
    path.to_file('Goodbye!') # => #<File:path/to/goodbye.rb>
    path.fexist? # => true
    File.open(path) do |f|
      f.read # => "Goodbye!"
    end

Also, `Array#fjoin` is provided.

    File.expand_path(File.join(*%w(.. lib)), File.dirname(__FILE__)) # => "/Users/melborne/filename/lib"

    # same as above
    %w(.. lib).fjoin.fexpand(__FILE__.fdir) # => "/Users/melborne/filename/lib"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
