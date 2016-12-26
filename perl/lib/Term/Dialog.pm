package Term::Dialog;

use strict;
use warnings;
use Data::Dumper;

sub new {
    my $class = shift;
    my $self = {@_};
    
    
    bless $self, $class;
    
    return $self;
}

sub run {
    my $self = shift;
    
    for my $unit ( @{ $self->{queue} } ) {
        $unit->do();
    }
}

1;