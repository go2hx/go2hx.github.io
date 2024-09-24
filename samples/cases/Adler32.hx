package cases;

function main() {
    Template.createTextTemplate(data -> {
    final input = data.input;
    final output = data.output;
    output.value = "" + stdgo.hash.adler32.Adler32.checksum(input.value.split("").map(c -> c.charCodeAt(0)));
   });
}