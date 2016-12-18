package Term::Dialog;

use strict;
use warnings;

sub new {
    my $class = shift;
    my $self = {@_};
    
    
    bless $self, $class;
    
    return $self;
}

sub run {
    my $self = shift;
    
    my $config = $self->{config};
    
    for my $unit ( @{ $config } ) {
        
        if (! defined $unit->{id}) {
            die "[ERROR]: id of the dialog unit must be presented\n";
        }
        
        if (! defined $unit->{rendering}) {
            # Default is printing from "echo" directly
            $unit->{rendering} = sub {
                return ();
            }
        }
        
        if (! defined $unit->{input}) {
            # Default is passing undef
            $unit->{input} = sub {return undef};
        }
        
        if (! defined $unit->{commit}) {
            # Default is do nothing
            $unit->{commit} = sub {return};
        }
        
        if (! defined $unit->{next}) {
            # Default is do nothing
            $unit->{next} = sub {return};
        }
        
        # Resolve "echo" macros
        my @rvars = $unit->{rendering}->();
        my $resolved_echo = resolve_macros(
            string  => $unit->{echo},
            vars    => \@rvars
        );
        
        
    }
}

sub resolve_macros {
    my $args = {@_};
    

}

1;