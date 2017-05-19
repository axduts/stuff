package DialogSequencer::Dialog;

use strict;
use warnings;

use Data::Dumper;

sub new {
    my $class = shift;
    my $self = {@_};
    bless $self, $class;
    return $self;
}

sub go {
    
}

sub route {
    my $self        = shift;
    my $name        = shift;
    my $destination = shift;
    
    if (defined $destination && ref $destination eq 'DialogSequencer::Dialog') {
        $destination->_source($self);
    }
    
    $self->{_routes}->{$name} = $destination;
}

sub map {
    my $self = shift;
    $self->{_map} = {@_};
}

sub convey {
    my $self = shift;
    my $cb = shift;
    $cb->($self->{_result});
}

sub _source {
    my $self = shift;
    $self->{_source} = shift;
}

1;