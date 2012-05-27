# FileName

FileName is a module which can add functionality to string for handling filenames.

## Installation

Add this line to your application's Gemfile:

    gem 'filename'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install filename

## Usage
To include FileName module to String class, you can get several instance methods to manipulate filename strings.

    String.send(:include, FileName)
    
    path = 'path/to/hello.rb'
    
    # get directory name
    path.fdir # => "path/to"

    # get file base name
    path.fbase # => "hello"

    # get file base name with extension
    path.fbasex # => "hello.rb"

    # get file extension
    path.fext # => ".rb"

    # get file extension without dot(.)
    path.fexto # => "rb"

    # split file directory, basename and extension
    path.fsplit # => ["path/to", "hello", ".rb"]

    # get file expand path
    path.fexpand # => "/Users/melborne/filename/example/path/to/hello.rb"

    # chop portion of path name recursively
    path.fchop # => "path/to/hello"
    path.fchop(2).fchop # => "path"
    
    # check file existance correnspond to a filename
    path.fexist? # => false

    # create a file object from filename object
    path.to_file("puts 'Hello, Ruby!'") # => #<File:path/to/hello.rb>

    # check file existance after file creation
    path.fexist? # => true
    File.open(path) do |f|
      f.read # => "puts 'Hello, Ruby!'"
    end

You can also create FileName object with `FileName.new`, in which you can use above methods with omission of first 'f' from the name.

    require 'filename'
    
    path = 'path/to/hello.rb'
    
    # create FileName object
    fn = FileName::FileName.new(path)

    # to include FileName module to String, you can do it with string
    fn = path.to_filename
    
    fn # => path/to/hello.rb

    fn.dir # => "path/to"
    fn.base # => "hello"
    fn.basex # => "hello.rb"
    fn.ext # => ".rb"
    fn.exto # => "rb"
    fn.split # => ["path/to", "hello", ".rb"]
    fn.expand # => "/Users/melborne/filename/example/path/to/hello.rb"
    
    # set file content
    fn.content = "hello, world!"

FileName has `sequence` method which produce sequencial names. This makes it easy to create sequencial dummy files or to rename disordered files to be ordered.

    base = "path/to/hello.rb".to_filename
    
    # without argument, the end character of the base name is incremented
    base.sequence.take(5) # => [path/to/hello.rb, path/to/hellp.rb, path/to/hellq.rb, path/to/hellr.rb, path/to/hells.rb]
    
    # with argument, it will be attached to the end of the base name, then incremented
    base.sequence('01').take(5) # => [path/to/hello01.rb, path/to/hello02.rb, path/to/hello03.rb, path/to/hello04.rb, path/to/hello05.rb]

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
