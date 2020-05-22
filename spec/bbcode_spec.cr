require "./spec_helper"

require "../src/bbcode"

describe BBCode do
  {
    "No BBCode here"                                                                                        => "No BBCode here",
    "<b>HTML tags</b>"                                                                                      => "&lt;b&gt;HTML tags&lt;/b&gt;",
    "[b]Simple test[/b]"                                                                                    => "<b>Simple test</b>",
    "[bb]Another test[/bb]"                                                                                 => "[bb]Another test[/bb]",
    "[B]Both caps[/B]"                                                                                      => "<b>Both caps</b>",
    "[B]Case does not matter[/b]"                                                                           => "<b>Case does not matter</b>",
    "Testing [b]bbcode[/b].  Seems to [i]work [s]maybe[/s] actually it looks like it [u][/i] does! :D [/u]" => "Testing <b>bbcode</b>.  Seems to <i>work <s>maybe</s> actually it looks like it <u></i> does! :D </u>",
    "[b]Multiline\ntexts [i]should[/i]\n also[/b]\n[u]work[/u]"                                             => "<b>Multiline<br>texts <i>should</i><br> also</b><br><u>work</u>",

    "[b]has br[/b]\n[code]no br[/code]\n[u]has br[/u]\n[right]no br[/right]\n\n[i]end[/i]" => "<b>has br</b><br><pre>no br</pre><u>has br</u><br><p align=\"right\">no br</p><i>end</i>",
    "multiple\n\n\n\n\n\nnewlines\n\n\n\n\n\nend in\r\n\r\nonly one\r\n\r\n\r\n\n\n\r\nbr" => "multiple<br>newlines<br>end in<br>only one<br>br",
  }.each do |input, output|
    context "when input is #{input.inspect}" do
      it "returns the expected output" do
        BBCode.parse(input).should eq output
      end
    end
  end
end
