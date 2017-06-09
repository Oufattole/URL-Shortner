use Mojolicious::Lite;
use Mojo::URL;

##Variable Declaration##
my $f = "db.txt";	#text document used for link storage
my $y;			#empty variable used for something later/file length??
my $fh;			#file handler, integrated variable

##Subroutines and Helpers##
sub fhlen{
	open($fh, "<", $f);
	$y=0;
	while(<$fh>)
	{
		$y++;
	}
	close $fh;
}


#Main Page: uses index template
get '/' => sub {
	my  $c = shift;
	$c->render(template => 'index');
};

#Shortened Page: uses short template and gives the shortened link
get '/newsurl' => sub {
	my $c = shift;
	my $bigg = $c->param('big');
	fhlen();  #Sets y as the length of the text file lines
	open($fh, ">>", $f);
	print $fh "\n", $y, " ", $bigg;
	close $fh;
	$c->render(template => 'short', burl => $y); #burl means SmallUrl - the placeholder number
};

#Input Key Page: uses 'notshort' template which has a textbox for the key
get '/nshort' => sub{
	my $c = shift;
	$c->render(template => 'notshort'); 
};

#Key Page: takes in a key#after inputing small redirects to big
get '/newburl' => sub {
	my $c = shift;
	my $sma = $c->param('small');
	my %urs;
	open($fh, "<", $f);
	while(!eof $fh) {                             #while not at the end of the file
		my $line = readline $fh;              #In a loop readline automatically goes line by line
		if(defined $line){                    #Makes sure the line is not '' or '0'
			my %words = split / /, $line; #creates a hash with every word in the line
			%urs = (%urs, %words);        #appending the %words
		}
	}
	close $fh;
	my $s = $urs{$sma}; # defines the long address
  	chomp $s;           #remove any whitespace - for safety
	#Debug Stuff
  	foreach (sort keys %urs) {
    		print "$_ : $urs{$_}\n";
  	}	
  	print $s;
 	 if(defined $s){
 		 print "defined bee bee";
  	}
	#The redirect
	$c->redirect_to("$s");
};

app->start;

##DATA comments##
#index.html.ep is the main page and redirects to either /nshort - uses the default template
#redir.html.ep will redirect the user to their site
#short.html.ep has the new key for the user and a link back to the main page
#notshort.html.ep has a textbox which will take in a key and redirects to newburl with parameter 'small'
__DATA__

@@ index.html.ep 
% layout 'default';
% title 'Welcome';
<h1>Enter Big URL</h1>
To unshorten URL click
<%= link_to 'here' => '/nshort' %>.

@@ redir.html.ep
<html><%= link_to 'hyper' => begin %>Les Goooo!!!<% end %>
<html>

@@ short.html.ep
<html><%=$burl%>
<h1>Click to go back and enter another one</h1>
<%= link_to 'click' => '/'%>
</html>

@@ notshort.html.ep
<html>
<h1>Enter small URL to get big one</h2>
<h2>click the link to shorten a big url</h2>
<%=link_to 'click' => '/'%>
%= form_for newburl => begin 
%= text_field 'small'
%= submit_button
%= end
</html>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %>
  %= form_for newsurl => begin
  %= text_field 'big'
  %= submit_button 
  %= end
</body>
</html>
