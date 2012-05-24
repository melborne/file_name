# encoding: UTF-8

require_relative "spec_helper"

describe FileName do
  context "initialize" do
    it "raise an error with a string which end with a separator" do
      ->{ FileName.new('path/to/') }.should raise_error
      ->{ FileName.new('path/to/::', sep:'::') }.should raise_error
    end

    it "make a separator to '::'" do
      fn = FileName.new('path::to::file', sep:'::')
      fn.sep.should eql '::'
    end

    it "can takes a content string to @content" do
      content = <<-EOS
      Hello, world!
      This is a content of this file.
      EOS
      fn = FileName.new('path/to/file.txt', content: content)
      fn.content.should eql content
    end
  end

  context "Instance methods" do
    before(:each) do
      @fn = FileName.new('path/to/the/file.rb')
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
    end

    context "split" do
      it "split filename to directory, base and extension" do
        @fn.split.should eql ['path/to/the', 'file', '.rb']
      end
    end

    context "chop" do
      it "return a FileName object" do
        @fn.chop.class.should eql FileName
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
        fn = FileName.new "hello.rb"
        fn.chop.to_s.should eql "hello"
      end

      it "cuts extension correctly2" do
        fn = FileName.new ".hello/world"
        fn.chop.to_s.should eql ".hello"
      end
    end

    context "exist?" do
      it "return false when an correspond file not exist" do
        @fn.exist?.should be_false
      end

      it "return true when an correspond file exist" do
        fn = FileName.new('spec/spec_helper.rb')
        fn.exist?.should be_true
      end
    end

    context "each" do
      it "return a Enumerator object" do
        @fn.each.class.should eql Enumerator
      end

      it "make 10 FileName objects" do
        @fn.each.take(10).map(&:class).should eql [FileName] * 10
      end

      it "make 5 FileName objects with sequential names" do
        fn = FileName.new('abc/def.rb')
        fn.each.take(5).map(&:to_s).should eql ['abc/def.rb', 'abc/deg.rb', 'abc/deh.rb', 'abc/dei.rb', 'abc/dej.rb']
      end

      it "make 5 FileName objects with sequential numbered names" do
        new_names = 5.times.map { |i| "abc/def0#{i}.rb" }
        fn = FileName.new('abc/def.rb')
        fn.each('00').take(5).map(&:to_s).should eql new_names
      end
    end

    context "content" do
      it "set and get a content" do
        def_content = "hello\nMy friend."
        new_content = "Goodbye!"
        fn = FileName.new('abc/def.rb', content:def_content)
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
        @fn = FileName.new(@path, content:@content)
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

  context "Class methods" do
    context "join" do
      it "return a FileName object" do
        FileName.join(['path', 'to', 'the', 'file.rb']).class.should eql FileName
      end

      it "return a FileName object with 'path/to/the/file.rb'" do
        fn = FileName.join(['path/to', 'the', 'file.rb'])
        fn.to_s.should eql 'path/to/the/file.rb'
      end

      it "return a FileName object when it takes a separator" do
        fn = FileName.join(['path', 'to', 'the', 'file.rb'], '::')
        fn.to_s.should eql 'path::to::the::file.rb'
      end
    end
  end
end
