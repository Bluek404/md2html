class Md2html::Parser
  def initialize(text)
    @lines = text.lines.map(&.chomp)
    @line = 0
    @elements = Element.new
    @elements.parent = @elements
    @node = @elements
  end

  def parse
    while @line < @lines.length
      process_paragraph()
    end
    String.build do |io|
      @elements.to_html(io)
    end
  end

  def process_paragraph
    line = @lines[@line]

    if line.length == 0 || line =~ /^\s*$/
      @node = (@node as Element).parent
      @line += 1
      return
    end

    if @lines.length > 1 && @line+1 < @lines.length
      next_line = @lines[@line+1]
      if next_line =~ /^\=+$/
        header = Header.new(@node, 1)
        process_text(header, line)
        (@node as Element).content << header
        @line += 2
        return
      elsif
        next_line =~ /^-+$/
        header = Header.new(@node, 2)
        process_text(header, line)
        (@node as Element).content << header
        @line += 2
        return
      end
    end

    unless @node.is_a?(P)
      p = P.new(@node)
      (@node as Element).content << p
      @node = p
    end
    process_text(@node, line)
    @line += 1
  end

  def process_text(parent, text)
    node = parent
    buf = ""
    i = 0
    while i < text.length
      char = text[i]
      case char
      when '`'
        if e = text.index('`', i+1); e != -1
          if buf != ""
            (node as Element).content << Text.new(node, buf)
            buf = ""
          end
          buf = text[i+1..e-1]
          code = Code.new(node)
          code.content << Text.new(code, buf)
          (node as Element).content << code
          i += buf.length + 2
          buf = ""
        else
          buf += '`'
          i += 1
        end
      when '*'
        if node.is_a?(Italics)
          if buf != ""
            (node as Element).content << Text.new(node, buf)
            buf = ""
          end
          node = node.parent
        else
          # 确保还有一个 *
          if text.index('*', i+1) != -1
            italics = Italics.new(node)
            (node as Element).content << italics
            node = italics
          else
            buf += '*'
          end
        end
        i += 1
      else
        buf += char
        i += 1
      end
    end
    if buf != ""
      (node as Element).content << Text.new(node, buf)
      buf = ""
    end
  end
end
