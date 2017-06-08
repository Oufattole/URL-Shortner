package Model::sites;

use strict;
use warnings;

my $SITES = {
  aa => 'google.com',
  ab => 'amazon.com',
  ac => 'gmail.com',
  ad => 'youtube.com',
};

sub new { bless {}, shift }

sub check {
  my ($self, $short) = @_;

  return $SITES->{$short};
  return undef;
}

1;
