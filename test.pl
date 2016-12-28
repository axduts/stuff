use strict;
use warnings;

use Term::Dialog;
use Term::Dialog::Unit;

use Data::Dumper;

my $data = {
};

my $dialog = Term::Dialog->new(
    queue => [
        #Term::Dialog::Unit->new(
        #    question => "Enter user name: ",
        #    validation => [
        #        sub {
        #            if (shift eq '') {
        #                return (0, 'cant be empty')
        #            }
        #            return 1;
        #        },
        #        sub {
        #            if (shift ne 'foo') {
        #                return (0, 'not a foo user')
        #            }
        #            return 1;
        #        }
        #    ],
        #    commit => sub {
        #        $data->{user} = shift;
        #    }
        #),
        Term::Dialog::Unit->new(
            question => "What is your gender {{ foo() }} {{ items_row(_gender) }}?",
            _gender => ['male', 'female'],
            validation => [
                'at_list(__INPUT__, _gender)'
            ],
            commit => sub {
                $data->{gender} = shift;
            }
        )
    ]
);

$dialog->run();

print Dumper $data;


