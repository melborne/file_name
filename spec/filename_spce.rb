# encoding: UTF-8

require_relative "spec_helper"

describe FileName do
  context "initialize" do
    it "raise an error with a string which end with a separator" do
      ->{ FileName::FileName.new('path/to/') }.should raise_error
      ->{ FileName::FileName.new('path/to/::', sep:'::') }.should raise_error
    end

    it "make a separator to '::'" do
      fn = FileName::FileName.new('path::to::file', sep:'::')
      fn.sep.should eql '::'
    end

    it "can takes a content string to @content" do
      content = <<-EOS
      Hello, world!
      This is a content of this file.
      EOS
      fn = FileName::FileName.new('path/to/file.txt', content: content)
      fn.content.should eql content
    end
  end

  context "Instance methods" do
    before(:each) do
      @fn = FileName::FileName.new('path/to/the/file.rb')
    end

    context "dir" do
      it "return directory name" do
        @fn.dir.should eql 'path/to/the'
      end
    end

    context "base" do
      it "return base name" do
        @fn.base.should eql 'file'
      end

      it "return base name with extension" do
        @fn.basex.should eql 'file.rb'
      end
    end

    context "ext" do
      it "return extension name" do
        @fn.ext.should eql '.rb'
      end

      it "return nil name without extension" do
        fn = FileName::FileName.new '.hello'
        fn.ext.should be_nil
      end
    end

    context "split" do
      it "split filename to directory, base and extension" do
        @fn.split.should eql ['path/to/the', 'file', '.rb']
      end
    end

    context "chop" do
      it "return a FileName object" do
        @fn.chop.class.should eql FileName::FileName
      end

      it "return a object with a shortened name" do
        @fn.chop.to_s.should eql 'path/to/the/file'
      end

      it "cuts filename end by each path" do
        @fn.chop.to_s.should eql 'path/to/the/file'
        @fn.chop(2).to_s.should eql 'path/to/the'
        @fn.chop(3).to_s.should eql 'path/to'
      end

      it "cuts extension correctly1" do
        fn = FileName::FileName.new "hello.rb"
        fn.chop.to_s.should eql "hello"
      end

      it "cuts extension correctly2" do
        fn = FileName::FileName.new ".hello/world"
        fn.chop.to_s.should eql ".hello"
      end

      it "cuts extension if it exist" do
        fn1 = FileName::FileName.new 'hello.rb'
        fn2 = FileName::FileName.new 'hello'
        fn1.chop_ext.should eql 'hello'
        fn2.chop_ext.should eql 'hello'
      end
    end

    context "exist?" do
      it "return false when an correspond file not exist" do
        @fn.exist?.should be_false
      end

      it "return true when an correspond file exist" do
        fn = FileName::FileName.new('spec/spec_helper.rb')
        fn.exist?.should be_true
      end
    end

    context "expand" do
      it "return expand path" do
        path = "spec/spec_helper.rb" 
        expand = File.expand_path(path)
        path.fexpand.should eql expand
      end
    end

    context "sequence" do
      it "return a Enumerator object" do
        @fn.sequence.class.should eql Enumerator
      end

      it "make 10 FileName objects" do
        @fn.sequence.take(10).map(&:class).should eql [FileName::FileName] * 10
      end

      it "make 5 FileName objects with sequential names" do
        fn = FileName::FileName.new('abc/def/ghi.rb')
        fn.sequence.take(5).map(&:to_s).should eql ['abc/def/ghi.rb', 'abc/def/ghj.rb', 'abc/def/ghk.rb', 'abc/def/ghl.rb', 'abc/def/ghm.rb']
      end

      it "make 5 FileName objects with sequential no-extension names" do
        fn = FileName::FileName.new('abc/def/ghi')
        fn.sequence.take(5).map(&:to_s).should eql ['abc/def/ghi', 'abc/def/ghj', 'abc/def/ghk', 'abc/def/ghl', 'abc/def/ghm']
      end

      it "make 5 FileName objects with sequential numbered names" do
        new_names = 5.times.map { |i| "abc/def0#{i}.rb" }
        fn = FileName::FileName.new('abc/def.rb')
        fn.sequence('00').take(5).map(&:to_s).should eql new_names
      end
    end

    context "content" do
      it "set and get a content" do
        def_content = "hello\nMy friend."
        new_content = "Goodbye!"
        fn = FileName::FileName.new('abc/def.rb', content:def_content)
        fn.content.should eql def_content
        fn.content = new_content
        fn.content.should eql new_content
      end
    end

    context "to_file" do
      before(:each) do
        require "fakefs/safe"
        @path = "abc/ruby.rb"
        @content = "hello, world!"
        @fn = FileName::FileName.new(@path, content:@content)
      end

      it "create a file object with name of 'ruby.rb'" do
        FakeFS do
          f = @fn.to_file
          f.class.should eql File
          File.basename(f).should eql 'ruby.rb'
        end
      end

      it "save content of 'hello, world!'" do
        FakeFS do
          @fn.to_file.read.should eql "hello, world!"
        end
      end
    end
  end
end

describe String do
  String.send(:include, FileName)
  
  before(:each) do
    @str = "path/to/the/file.rb"
  end

  context "fdir" do
    it "return dir name" do
      @str.fdir.should eql 'path/to/the'
    end
  end

  context "fbase" do
    it "return base name" do
      @str.fbase.should eql 'file'
    end
  end

  context "fbasex" do
    it "return base name with extension" do
      @str.fbasex.should eql 'file.rb'
    end
  end

  context "fext" do
    it "return extension name" do
      @str.fext.should eql '.rb'
    end

    it "return nil name without extension" do
      '.hello'.fext.should be_nil
    end
  end

  context "split" do
    it "split filename to directory, base and extension" do
      @str.fsplit.should eql ['path/to/the', 'file', '.rb']
    end
  end

  context "fchop" do
    it "return a FileName object" do
      @str.fchop.class.should eql String
    end

    it "return a object with a shortened name" do
      @str.fchop.should eql 'path/to/the/file'
    end

    it "cuts filename end by each path" do
      @str.fchop.should eql 'path/to/the/file'
      @str.fchop(2).should eql 'path/to/the'
      @str.fchop(3).should eql 'path/to'
    end

    it "cuts extension correctly1" do
      "hello.rb".fchop.should eql "hello"
    end

    it "cuts extension correctly2" do
      ".hello/world".fchop.should eql ".hello"
    end

    it "cuts extension if it exist" do
      "hello.rb".fchop_ext.should eql 'hello'
      "hello".fchop_ext.should eql 'hello'
    end      
  end

  context "fexist?" do
    it "return false when an correspond file not exist" do
      @str.fexist?.should be_false
    end

    it "return true when an correspond file exist" do
      "spec/spec_helper.rb".fexist?.should be_true
    end
  end
  
  context "fexpand" do
    before(:each) do
      @path = "spec/spec_helper.rb" 
    end

    it "return expanded path" do
      expand = File.expand_path(@path)
      @path.fexpand.should eql expand
    end

    it "return expanded path with base dir" do
      expand = File.expand_path(@path, __FILE__)
      @path.fexpand(__FILE__).should eql expand
    end
  end
end
