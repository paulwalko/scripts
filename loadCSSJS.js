    function loadCSS(fileName){ 
        
        var file = document.createElement("link");
        file.setAttribute("rel", "stylesheet");
        file.setAttribute("type", "text/css");
        file.setAttribute("href", fileNameame);
        document.head.appendChild(file);
 
    }
 
    function loadJS(fileName) {
       
        var file = document.createElement("script");
	file.setAttribute("type", "text/javascript");
	file.setAttribute("src", fileName);
	document.head.appendChild(file);
    }
