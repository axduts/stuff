package Term::Dialog::Unit;

use strict;
use warnings;

sub new {
    my $class = shift;
    my $self = {@_};
    
    # init defaults
    
    if (! defined $self->{question}) {
        $self->{question} = 'PLACEHOLDER - NEED TO DEFINE A QUESTION';
    }
    
    if (! defined $self->{validation}) {
        $self->{validation} = sub {return 1};
    }
    
    if (! defined $self->{commit}) {
        $self->{commit} = sub {return 1};
    }
    
    bless $self, $class;
    
    return $self;
}

sub do {
    my $self = shift;
    
    printf("%s", $self->_resolve_string(string => $self->{question}));
    
    my $input = <STDIN>;
    chomp $input;
    
    $self->{commit}->($input);
}

sub _resolve_string {
    my $self = shift;
    my $args = {@_};
    
    return $args->{string};
}

1;