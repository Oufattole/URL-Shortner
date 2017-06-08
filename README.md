# URL-Shortner
Shorten URLs

### Explanation of the Shortener  
1) User visits the website   
        This will require us to host the website in order for it to be used, no problem.
        
2) User puts their URL into a textbox   
        This will require an interactive textbox on the site screen. Might also be important to pretty the site up.
        
3) User gets back a shortened URL   
        The URL the user puts in needs to be taken and stored into a text document/hash along with the shortcut they are given.
        
4) Every time the user uses the short URL they are redirected to the real one   
        This will require pulling the URL they put in for processing which will match it with the full URL and then redirect them.


### Formatting
Example shortened address:  
        medgar.interns.kit.cm/andix

Format for storage of websites:  
        google.com/isearchedathing

TODO THINGS:
Within the redirect code we shouldn't use the html meta redirect but instead a mojo redirect along with a 3xx code $c->res->code  
For storage of links we could use a text document with Mojo::File, a database with postgres, or a key/value store with Redis.  
Within the textbox and button code we should replace them with appropriate tag helpers.
