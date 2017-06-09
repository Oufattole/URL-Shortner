use Mojolicious::Lite;
use Mojo::URL;

##Variable Declaration##
my $f = "db.txt";	#text document used for link storage
my $y;			#empty variable used for something later/file length??
my $fh;			#file handler, integrated variable

##Subroutines and Helpers##
sub fhlen{ #Sets Y as the length of the file
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
	my $s = $urs{$sma};   #Defines the long address
  	chomp $s;             #Removes any whitespace - for safey
	$c->redirect_to("$s");#The Redirect
};

app->start;

##DATA comments##
#index.html.ep is the main page and has two boxes, one for the URL, and one for the key. They each redirect to newsurl and newburl respectively.
#redir.html.ep will redirect the user to their site
#short.html.ep has the new key for the user and a link back to the main page
__DATA__

@@ index.html.ep 
% layout 'default';
% title 'Welcome';
<h1>Enter the URL you would like shortened below!</h1>
%= form_for newsurl => begin
%= text_field 'big'
%= submit_button 
%= end
<h2> Or you can enter a shortened key below!</h2>
%= form_for newburl => begin 
%= text_field 'small'
%= submit_button
%= end

@@ redir.html.ep
<html><%= link_to 'hyper' => begin %>Les Goooo!!!<% end %>
<html>

@@ short.html.ep
<html>The special key for your website is <b><%=$burl%></b>
To go back click <%= link_to 'here' => '/'%>
</html>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
	<head><title><%= title %></title></head>
	<body><%= content %></body>
</html>
