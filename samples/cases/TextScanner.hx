package cases;

import stdgo.strings.Strings;
import stdgo.text.scanner.Scanner;

function main() {
    Template.createTextTemplate(data -> {
        final input = data.input.value;
        final output = data.output;
        final src = input;
        var s = ({} : Scanner_);
        s.init(stdgo.Go.asInterface(Strings.newReader(src)));
        s.position.filename = "example";
        var tok = s.scan();
        output.value = "";
        while(tok != -1) {
            output.value += s.position.string() + "\t" + s.tokenText() + "\n";
            tok = s.scan();
        }
   }).input.value = 
   'function main() {
    if (value == 4) {
        trace(value);
    }
}';
}