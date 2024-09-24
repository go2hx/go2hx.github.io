package cases;

function main() {
    Template.createTextTemplate(data -> {
    final input = data.input;
    final output = data.output;
    output.value = stdgo.encoding.hex.Hex.dump(input.value.split("").map(c -> c.charCodeAt(0)));
   });
}