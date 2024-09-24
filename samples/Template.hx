package;

import js.html.*;

var articleElement:Element = js.Browser.document.querySelector("article.markdown-body");


function addHeader(text:String, breaks:Bool=true) {
    
    text = '<h3>$text</h3>';
    if (breaks)
        text = "<br>" + text;
    articleElement.innerHTML += text;
}

function addText(text:String, breaks:Bool=true) {
    if (breaks)
        text = "<br>" + text;
    articleElement.innerHTML += text;
}

function textArea(readOnly:Bool=false) {
    final elem:TextAreaElement = cast js.Browser.document.createTextAreaElement();
    elem.readOnly = readOnly;
    elem.style.width = "600px";
    elem.style.height = "200px";
    elem.style.fontSize = "24px";
    elem.style.resize = "none";
    return elem;
}

function button(text:String, onClick:Void->Void) {
    addText("<br>");
    final elem:ButtonElement = cast js.Browser.document.createButtonElement();
    elem.style.fontSize = "26px";
    elem.textContent = text;
    elem.onclick = onClick; 
    return elem;
}

function createTextTemplate(onRun:TextDataTemplate->Void):TextDataTemplate {
    final input = textArea();
    input.placeholder = "input";
    final output = textArea(true);
    output.placeholder = "output";
    output.style.height = "400px";
    // data
    final data:TextDataTemplate = {
        input: input,
        output: output,
    };
    var oldValue = "";
    addUpdateLoop(100, () -> {
        if (oldValue != input.value) {
            oldValue = input.value;
            onRun(data);
        }
    });
    final runButton = button("run", () -> onRun(data));
    articleElement.appendChild(input);
    articleElement.appendChild(output);
    return data;
}

function addUpdateLoop(delay:Int, onUpdate:Void->Void) {
    new haxe.Timer(delay).run = onUpdate;
}

typedef TextDataTemplate = {
    input:TextAreaElement,
    output:TextAreaElement,
    
}
