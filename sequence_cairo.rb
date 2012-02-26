# -*- encoding: utf-8 -*-
require 'cairo'

# cairo依存部

class GLifeLine < LifeLine
  def initialize(name)
    super
  end
  
  def set_bounds(x, y, width, height)
    @x = x
    @y = y
    @width = width
    @height = height
  end
  
  def draw(context)
    context.rectangle(@x, @y, @width, @height)
    context.stroke
    context.move_to(@x, @y)
    context.show_text(get_name)
    draw_line(context, @x + @width / 2, @y + @height, @x + @width / 2, @y + @height + 400)
  end
  
  def get_x()
    @x
  end
  
  def get_width()
    @width
  end
end

class GMessage < Message
  def initialize(text, src, dest)
    super
  end
  
  def draw()
    draw_line()
    draw_arrow_head()
    draw_message()
  end
end

class Diagram
  def initialize(width, height)
    @width = width
    @height = height
    @lifelines = []
    @messages = []
  end
  
  def add_lifeline(name)
    # 新規追加の場合は新しく生成して返す
    # すでに含まれている場合はそれを返す
    new_lifeline = nil
    @lifelines.each{|lifeline|
      if lifeline.get_name == name then
        new_lifeline = lifeline
      end
    }
    if new_lifeline == nil then
      new_lifeline = GLifeLine.new(name)
      @lifelines.push new_lifeline
    end
    new_lifeline
  end
  
  def add_message(message)
    @messages.push message
    add_lifeline message.get_src.get_name
    add_lifeline message.get_dest.get_name
  end
  
  def get_width()
    @width
  end
  
  def get_height()
    @height
  end
  
  def draw(context)
    x = 10
    y = 10
    width = 80
    height = 40
    @lifelines.each{|lifeline|
      lifeline.set_bounds x, y, width, height
      lifeline.draw context
      
      x = x + 100
    }
    
    y = 10 + 40 + 20
    @messages.each{|message|
      src_x = get_center message.get_src
      dest_x = get_center message.get_dest
      draw_line context, src_x, y, dest_x, y
      context.move_to(src_x, y)
      context.show_text(message.get_text)
      y = y + 40
    }
  end
  
  def get_center(lifeline)
    lifeline.get_x + lifeline.get_width / 2
  end
end

def write_diagram(diagram, filename)
  format = Cairo::FORMAT_ARGB32
  
  surface = Cairo::ImageSurface.new(format, diagram.get_width, diagram.get_height)
  context = Cairo::Context.new(surface)
  
  diagram.draw context
  
  surface.write_to_png(filename)
end

def draw_line(context, start_x, start_y, end_x, end_y)
  context.move_to(start_x, start_y)
  context.line_to(end_x, end_y)
  context.stroke
end
