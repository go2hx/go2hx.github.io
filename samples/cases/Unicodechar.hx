package cases;

import stdgo.unicode.Unicode;

function main() {
    Template.createTextTemplate(data -> {
     final input = data.input.value;
     final output = data.output;
     output.value = "";
     function write(text:String) {
         output.value += text + "\n";
     }
     for (c in input.split("")) {
         write('For \'$c\':');
         final c = c.charCodeAt(0);
         if (Unicode.isControl(c)) {
             write("\tis control rune");
         }
         if (Unicode.isDigit(c)) {
             write("\tis digit rune");
         }
         if (Unicode.isGraphic(c)) {
             write("\tis graphic rune");
         }
         if (Unicode.isLetter(c)) {
             write("\tis letter rune");
         }
         if (Unicode.isLower(c)) {
             write("\tis lower case rune");
         }
         if (Unicode.isMark(c)) {
             write("\tis mark rune");
         }
         if (Unicode.isNumber(c)) {
             write("\tis number rune");
         }
         if (Unicode.isPrint(c)) {
             write("\tis printable rune");
         }
         if (Unicode.isPunct(c)) {
             write("\tis punct rune");
         }
         if (Unicode.isSpace(c)) {
             write("\tis space rune");
         }
         if (Unicode.isSymbol(c)) {
             write("\tis symbol rune");
         }
         if (Unicode.isTitle(c)) {
             write("\tis title rune");
         }
         if (Unicode.isUpper(c)) {
             write("\tis upper rune");
         }
     }
    });
 }