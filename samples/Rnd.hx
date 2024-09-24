function main() {
    Template.createTextTemplate(data -> {
        final input = data.input;
        final output = data.output;
        final src = input.value;
        var s = ({} : stdgo.text.scanner.Scanner.Scanner_);
        s.init(stdgo.Go.asInterface(stdgo.strings.Strings.newReader(src)));
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