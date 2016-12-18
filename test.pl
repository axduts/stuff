use strict;
use warnings;

use Term::Dialog;

use Data::Dumper;

my $data = {
};

my $d = Term::Dialog->new(config => [
    {
        id          => 'animals_names_prompt',
        echo        => '- - - - - - - - Animals names - - - - - - - - -',
    },
    {
        id => 'animals_names_question',
        echo => 'Enter animal name %{order}',
        rendering => sub {
            my $args = {@_};
            
            my $order = defined $data->{animals} ?
                        scalar @{ $data->{animals} } + 1 :
                        0;
            
            if (scalar @{ $data->{animals} } < 3 ) {
                return (order => $order);
            }
            return undef;
        },
        input => sub {
            return shift;
        },
        commit => sub {
            my $args = {@_};
            push @{ $data->{animals} }, $args->{value};
        },
        next => sub {
            my $args = {@_};
            return $args->{parent};
        }
    }
]);

$d->run;
