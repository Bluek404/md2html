class Md2html::Element
  property :content
  property :parent

  def initialize()
    @parent = nil
    @content = Array(Element).new
  end

  def to_html(io)
    @content.each(&.to_html(io))
  end
end

class Header < Md2html::Element
  def initialize(@parent, @level)
    @content = Array(Md2html::Element).new
  end

  def to_html(io)
    io << "<h#{ @level }>"
    @content.each(&.to_html(io))
    io << "</h#{ @level }>"
  end
end

class Text < Md2html::Element
  property :text

  def initialize(@parent, @text)
    @content = Array(Md2html::Element).new
  end

  def to_html(io)
    io << @text
  end
end

class P < Md2html::Element
  def initialize(@parent)
    @content = Array(Md2html::Element).new
  end

  def to_html(io)
    io << "<p>"
    @content.each do |e|
      if e.is_a?(Text)
        l = e.text.length
        if l > 1 && e.text[l-2...l] == "  "
          e.text = e.text[0...l-2] + "</br>"
        end
      end
      e.to_html(io)
    end
    io << "</p>"
  end
end

class Italics < Md2html::Element
  def initialize(@parent)
    @content = Array(Md2html::Element).new
  end

  def to_html(io)
    io << "<em>"
    @content.each(&.to_html(io))
    io << "</em>"
  end
end

class Code < Md2html::Element
  def initialize(@parent)
    @content = Array(Md2html::Element).new
  end

  def to_html(io)
    io << "<code>"
    @content.each(&.to_html(io))
    io << "</code>"
  end
end
