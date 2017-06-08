use Mojolicious::Lite;

my $file_store = "urls.txt";
my $num_sites = shift;
my $already = shift;
my $formatcheck = shift;

get '/' => 'home';

#Method for shortening a url
put '/shorten' => sub{
	my $c = shift;
	my $url = $c->param('url_shorten');
	$already = 0;
	$formatcheck = 1;
	#Checking if format of url is correct
	
	
	#Checking for url already in list.
	if($formatcheck == 1)
	{
		open(my $fh1, "<", $file_store) || die "Couldn't open '".$file_store."' for reading because: ".$!;
		while(my $curr_line = readline $fh1){
			chomp $curr_line;
			chomp $url;
			if($curr_line eq $url){
				close $fh1;
				$c->flash(confirmation => "URL already entered in our database."); 
				$already = 1;
			};
		};
	};
	
	#adding url to list.
	if($already == 0){
		open(my $fh2, ">>", $file_store) || die "Couldn't open '".$file_store."' for reading because: ".$!;
		$num_sites++;
		print $fh2 "rcaraway.interns.kit.cm/"."$num_sites"."\n";
		print $fh2 "$url"."\n";
		close $fh2;	
		$c->flash(confirmation => "Shortened URL: rcaraway.interns.kit.cm/$num_sites"); 
	};
	$c->redirect_to('home');
};

#
put '/search' => sub{
	my $c = shift;	
	my $url = $c->param('url_search');
	
	open(my $fh1, "<", $file_store) || die "Couldn't open '".$file_store."' for reading because: ".$!;
	while(my $curr_line = readline $fh1){
		chomp $curr_line;
		chomp $url;
		if($curr_line eq $url){
			$url = readline $fh1;
			chomp $url;
			$c->flash(confirmation => "URL: $url");
			#Redirect to url
			close $fh1;
		};
	};
	$c->redirect_to("$url");
	#$c->redirect_to('home');
};

put '/reset' => sub{
	my $c = shift;
	open(my $fh, ">", $file_store) || die "Couldn't open '".$file_store."' for reading because: ".$!;
	close $fh;
	$num_sites = 0;	
	$c->flash(confirmation => "The text file containing the (KEY : URL) pairings has been wiped.");
	$c->redirect_to('home')
};

app -> start;

__DATA__

@@ home.html.ep
<!DOCTYPE html>
<html>
  <head>
	<title>Mojo URL Shortener</title>
  </head>
  <body>
	% if (my $confirmation = flash 'confirmation') {
      <p>Message: <%= $confirmation %></p>
    % }
	<h1>Enter URL to shorten below</h1>
    %= form_for shorten => begin
      %= text_field url_shorten => ''
      %= submit_button 'shorten'
    % end
    <h1>Enter shortened URL to be redirected</h1>
    %= form_for search => begin
      %= text_field url_search => ''
      %= submit_button 'search'
    % end
	<h1>Reset button below</h1>
	%= form_for reset => begin
	  %= submit_button 'reset'
	% end
  </body>
</html>