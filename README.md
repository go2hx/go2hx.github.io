# go2hx.github.io

go2hx's website, the pages are written in markdown and can be found in ``_content`` 

folders created in ``_content`` are searched inside to find an index.html to use as a template for all markdown files within. html files can use template syntax from [haxe.Template](https://api.haxe.org/haxe/Template.html).
 

# Run rnd sample located at ./samples/Rnd.hx
```haxe
haxe rnd.hxml
```

# Create new sample

drag working Rnd.hx sample into the cases folder and rename the file


# Build steps
```haxe
haxe samples.hxml
haxe build_data.hxml
haxe graph.hxml
haxe build.hxml
```

# Testing locally
cd page
npx http-server -c-1
