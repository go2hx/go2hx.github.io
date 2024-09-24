package cases;

function main() {
    Template.createTextTemplate(data -> {
     final input = data.input;
     final output = data.output;
     output.value = "";
     function write(text:String) {
         output.value += text + "\n";
     }
     for (c in input.value.split("")) {
         write('For \'$c\':');
         final c = c.charCodeAt(0);
         if (stdgo.unicode.Unicode.isControl(c)) {
             write("\tis control rune");
         }
         if (stdgo.unicode.Unicode.isDigit(c)) {
             write("\tis digit rune");
         }
         if (stdgo.unicode.Unicode.isGraphic(c)) {
             write("\tis graphic rune");
         }
         if (stdgo.unicode.Unicode.isLetter(c)) {
             write("\tis letter rune");
         }
         if (stdgo.unicode.Unicode.isLower(c)) {
             write("\tis lower case rune");
         }
         if (stdgo.unicode.Unicode.isMark(c)) {
             write("\tis mark rune");
         }
         if (stdgo.unicode.Unicode.isNumber(c)) {
             write("\tis number rune");
         }
         if (stdgo.unicode.Unicode.isPrint(c)) {
             write("\tis printable rune");
         }
         if (stdgo.unicode.Unicode.isPunct(c)) {
             write("\tis punct rune");
         }
         if (stdgo.unicode.Unicode.isSpace(c)) {
             write("\tis space rune");
         }
         if (stdgo.unicode.Unicode.isSymbol(c)) {
             write("\tis symbol rune");
         }
         if (stdgo.unicode.Unicode.isTitle(c)) {
             write("\tis title rune");
         }
         if (stdgo.unicode.Unicode.isUpper(c)) {
             write("\tis upper rune");
         }
     }
    });
 }