require "./spec_helper"

describe Md2html do
  it "h1 works" do
    result = Md2html.parse("h1\n==")
    result.should eq("<h1>h1</h1>")
  end
  it "h2 works" do
    result = Md2html.parse("h2\n--")
    result.should eq("<h2>h2</h2>")
  end
  it "empty line" do
    result = Md2html.parse("      ")
    result.should eq("")
  end
  it "text line" do
    result = Md2html.parse("text")
    result.should eq("<p>text</p>")
  end
  it "multi text line" do
    result = Md2html.parse("text  \ntext\n\ntext")
    result.should eq("<p>text</br>text</p><p>text</p>")
  end
  it "italics" do
    result = Md2html.parse("*text*")
    result.should eq("<p><em>text</em></p>")
  end
  it "code" do
    result = Md2html.parse("`code`")
    result.should eq("<p><code>code</code></p>")
  end
end
