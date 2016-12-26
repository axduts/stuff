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
        $self->{validation} = [];
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
    
    $self->{input} = $input;
    
    # Validation sequence
    my @val_errors;
    for my $vsub ( @{ $self->{validation} } ) {
        my ($is_valid, $err) = $vsub->($input);
        if (! $is_valid) {
            push @val_errors, $err;
        }
    }
    
    if (scalar @val_errors) {
        # Flush err message and repeat question.
        for (@val_errors) {
            print "- $_\n";
        }
        print "Try again.\n";
        $self->do();
    }
    
    
    $self->{commit}->($self->{input});
}

sub _resolve_string {
    my $self = shift;
    my $args = {@_};
    
    return $args->{string};
}

1;