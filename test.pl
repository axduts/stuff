use strict;
use warnings;

use Term::Dialog;
use Term::Dialog::Unit;

use Data::Dumper;

my $data = {
};

my $dialog = Term::Dialog->new(
    queue => [
        Term::Dialog::Unit->new(
            question => "Enter user name: ",
            validation => sub {return 1;},
            commit => sub {
                $data->{user} = shift;
            }
        )
    ]
);

$dialog->run();

print Dumper $data;


