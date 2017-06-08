use Mojolicious::Lite;

use lib 'lib';
use Model::sites;

helper site => sub { state $users = Model::sites->new };

any '/' => sub {
  my $c = shift;
  my $short = $c->param('user') || '';
  $c->stash(links => $c->site->check($short));
  my $site = $c->site->check($short);
  if ($short ne '') {$c->redirect_to("http://$site");}
} => 'index';

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
%= form_for index => begin
  % if (param 'user') {
    <b>There was an error in your redirect. Please try again. You were supposed to go to <%= $links %></b><br>
  % }
  %= text_field 'user'
  %= submit_button 'Redirect'
% end

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title>Redirector</title></head>
  <body><%= content %></body>
</html>
