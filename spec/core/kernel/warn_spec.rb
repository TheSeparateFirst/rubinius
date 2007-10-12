require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "Kernel.warn" do
  class FakeErr
    def initialize; @written = ''; end
    def written; @written; end
    def write(warning); @written << warning; end;
   end

  it "should call #write on $stderr" do
    begin
      v = $VERBOSE
      s = $stderr
      $VERBOSE = true
      $stderr = FakeErr.new
      warn("Ph'nglui mglw'nafh Cthulhu R'lyeh wgah'nagl fhtagn")
      $stderr.written.should == "Ph'nglui mglw'nafh Cthulhu R'lyeh wgah'nagl fhtagn\n"
    ensure
      $VERBOSE = v
      $stderr = s
    end
  end

  it "should write the default record seperator (\\n) and NOT $/ to $stderr after the warning message" do
    begin
      v = $VERBOSE
      s = $stderr
      rs = $/
      $VERBOSE = true
      $/ = 'rs'
      $stderr = FakeErr.new
      warn("")
      $stderr.written.should == "\n"
    ensure
      $VERBOSE = v
      $stderr = s
      $/ = rs
    end
  end

  it "should not call #write on $stderr if $VERBOSE is nil" do
    begin
      v = $VERBOSE
      s = $stderr
      $VERBOSE = nil
      $stderr = FakeErr.new
      warn("Ph'nglui mglw'nafh Cthulhu R'lyeh wgah'nagl fhtagn")
      $stderr.written.should == ""
    ensure
      $stderr = s
      $VERBOSE = v
    end
  end
end
