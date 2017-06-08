#!/usr/bin/env perl
use Mojolicious::Lite;
use Mojo::URL;
use feature qw(say);
# Documentation browser under "/perldoc"
plugin 'PODRenderer';



my $f = "db.txt";
my $y;
my $fh;



sub fhlen{
open($fh, "<", $f);
$y=0;
while(<$fh>)
{
	$y++;
}
close $fh;
}
# input big URL
get '/' => sub {
  my  $c = shift;
  $c->render(template => 'index');
};
#returns shortened URL
get '/newsurl' => sub {
  my$c = shift;
  my $bigg = $c->param('big');
fhlen();
open($fh, ">>", $f);
print $fh "\n", $y, " ", $bigg;
close $fh;
$c->render(template => 'short', burl => $y);
};
#input shortened URL
get '/nshort' => sub{
  my $c = shift;
  $c->render(template => 'notshort'); 
};
#after inputing small redirects to big
get '/newburl' => sub {
  my $c = shift;
  my $sma = $c->param('small');
  my %urs;
  open($fh, "<", $f);
  while(!eof $fh) {
	my $line = readline $fh;
	if(defined $line){
		my %words = split / /, $line;
		%urs = (%urs, %words);
		}
	}
close $fh;
  my $s = $urs{$sma};
  chomp $s;
  foreach (sort keys %urs) {
    print "$_ : $urs{$_}\n";
  }
  print $s;
  if(defined $s){
  print "defined bee bee";
  }
  $c->redirect_to("$s");

};
app->start;
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
