package cases;

import stdgo.encoding.hex.Hex;

function main() {
    Template.createTextTemplate(data -> {
    final input = data.input.value;
    final output = data.output;
    output.value = Hex.dump(input.split("").map(c -> c.charCodeAt(0)));
   });
}