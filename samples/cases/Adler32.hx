package cases;

import stdgo.hash.adler32.Adler32;

function main() {
    Template.createTextTemplate(data -> {
    final input = data.input.value;
    final output = data.output;
    final value = Adler32.checksum(input.split("").map(c -> c.charCodeAt(0)));
    output.value = "" + value;
   });
}