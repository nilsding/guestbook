class BBCode
  TAGS = {
    /\[b\](.*?)\[\/b\]/mi             => "<b>\\1</b>",
    /\[i\](.*?)\[\/i\]/mi             => "<i>\\1</i>",
    /\[u\](.*?)\[\/u\]/mi             => "<u>\\1</u>",
    /\[s\](.*?)\[\/s\]/mi             => "<s>\\1</s>",
    /\[sup\](.*?)\[\/sup\]/mi         => "<sup>\\1</sup>",
    /\[sub\](.*?)\[\/sub\]/mi         => "<sub>\\1</sub>",
    /\[tt\](.*?)\[\/tt\]/mi           => "<tt>\\1</tt>",
    /\[code\](.*?)\[\/code\]/mi       => "<pre>\\1</pre>",
    /\[left\](.*?)\[\/left\]/mi       => "<p align=\"left\">\\1</p>",
    /\[center\](.*?)\[\/center\]/mi   => "<center>\\1</center>",
    /\[right\](.*?)\[\/right\]/mi     => "<p align=\"right\">\\1</p>",
    /\[marquee\](.*?)\[\/marquee\]/mi => "<marquee>\\1</marquee>",
  }

  def self.parse(text)
    new(text).parse
  end

  def initialize(@text : String)
  end

  def parse
    text = HTML.escape(@text)

    TAGS.each do |pattern, replacement|
      until text == (text = text.gsub(pattern, replacement)); end
    end

    text
      .gsub(/(<\/(?:p|pre|marquee|center)>)(?:\r?\n)+/mi, "\\1") # remove newline after </p>, </pre>, ... to avoid extra <br>
      .gsub(/(\r?\n)+/, "<br>")
  end
end
