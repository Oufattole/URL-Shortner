use Mojolicious::Lite;
use Mojo::URL;

##Variable Declaration##
my $f = "db.txt";	#text document used for link storage
my $fh;			#file handler, integrated variable
my %urls;

##Subroutines and Helpers##
sub fhlen{ #Sets Y as the length of the file
	open($fh, "<", $f);
	my $y=0;
	while(<$fh>)
	{
		$y++;
	}
	close $fh;
	return $y
}

helper redirection => sub { #Helper that takes in a key and using that redirects the user to the appropriate site 
	my $c = shift;
	my $small = $c->param('thing');
	if ( $small ne '' ) {
		my %urllist;
		open($fh, "<", $f);
		while(!eof $fh) {                      #while not at the end of the file
			my $line = readline $fh;           #In a loop readline automatically goes line by line
			if( $line ne '' ){                 #Makes sure the line is not '' or '0'
				my %words = split / /, $line;  #creates a hash with every word in the line
				%urllist = (%urllist, %words); #appending the %words
			}
		}
		close $fh;
		my $link = $urllist{$small};   #Defines the long address
  		chomp $link;                   #Removes any whitespace - for safey
  		warn $link;
  		if ( index ( $link, "http://" ) != -1 ) {$c->redirect_to("$link"); }
		else{$c->redirect_to("http://$link");}      #The Redirect
	}
};	

#Main Page: uses index template
get '/0(*thing)' => { thing => ''} => sub {
	my $c = shift;
	my $thing = $c->param('thing');
	if ( $thing ne '' ) {
		$c->redirection;
	}
	else {
		$c->render(template => 'index', surl =>'');
	}
};

get '/long' => sub {
	my $c = shift;
	my $long = $c->param('lurl');

	my $y = fhlen();
	open($fh, ">>", $f);
	print $fh $y, " ", $long,"\n";
	close $fh;
	$c->render(template => 'index', surl => $y)
};

get '/' => sub {
	my $c = shift;
	$c->render(template => 'index', surl => '');
};

app->start;

__DATA__

@@ index.html.ep 
% layout 'default';
% title 'Welcome';
<h1>Enter the URL you would like shortened below!</h1>
%= form_for 'long' => begin
%= text_field 'lurl'
%= submit_button 
	% if ( $surl ne '' ) {
		Please use the link <b>medgar.interns.kit.cm/0<%= $surl %></b> to access your site.
	%	}
%= end


@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
	<head><title><%= title %></title></head>
	<body><%= content %></body>
</html>
