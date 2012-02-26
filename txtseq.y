class SrcParser
  rule
    target: command
    command: OBJECT '->' OBJECT {
      src  = @diagram.add_lifeline(val[0])
      dest = @diagram.add_lifeline(val[2])
      message1 = GMessage.new("", src, dest)
      @diagram.add_message(message1)
    }
           | OBJECT '->' OBJECT ':' MESSAGE {
      src  = @diagram.add_lifeline(val[0])
      dest = @diagram.add_lifeline(val[2])
      message1 = GMessage.new(val[4], src, dest)
      @diagram.add_message(message1)
    }
    OBJECT : IDENT
    MESSAGE: IDENT
           | IDENT '(' ')'
end

---- header
require 'sequence'
require 'sequence_cairo'
---- inner

  def initialize(diagram)
    @diagram = diagram
  end

  def parse(str)
    @q = []
    until str.empty?
      case str
      when /\A[A-Za-z]\w*/ # 識別子
        @q.push [:IDENT, $&]
      when /\-\>/ # ->
        s = $&
        @q.push [s, s]
      when /\:/
        s = $&
        @q.push [s, s]
      when /\n/
        s = $&
        @q.push [s, s]
      end
      str = $'
    end
    @q.push [false, '$end']
    do_parse
  end

  def next_token
    @q.shift
  end
  
  def save_diagram(filename)
    write_diagram @diagram, filename
  end

---- footer
parser = SrcParser.new Diagram.new(600, 600)

begin
  parser.parse("a->bb")
  parser.parse("bb->c")
  parser.parse("c->bb:text")
rescue ParseError
  puts "エラー #{$!}"
end
parser.save_diagram "diagram.png"
