class LifeLine
  def initialize(name)
    @name = name
  end
  def get_name()
    @name
  end
end

class Message

  def initialize(text, src, dest)
    @text = text
    @src = src
    @dest = dest
  end

  def get_text()
    @text
  end
  
  def get_src()
    @src
  end
  
  def get_dest()
    @dest
  end
end



