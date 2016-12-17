use strict;
use warnings;

use Term::Dialog;

use Data::Dumper;

my $d = Term::Dialog->new(config => [
    {
        id          => 'animals_names_prompt',
        echo        => '- - - - - - - - Animals names - - - - - - - - -',
        rendering   => sub { return 1; },
        input       => sub { return; },
        commit      => sub { return; }
    }
]);
