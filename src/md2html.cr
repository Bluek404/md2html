require "./md2html/*"

module Md2html
  def self.parse(markdown)
    Parser.new(markdown).parse
  end
end
