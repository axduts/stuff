use strict;
use warnings;

use DialogSequencer::Dialog;

use Data::Dumper;

my $data = {};

my $post_install_top = DialogSequencer::Dialog->new(
    question => 'Do you want to configure post install [%{options}] [%{default}]?'
);

    # $post_install_script_list BEGIN
    my $post_install_script_list = DialogSequencer::Dialog->new(
        question => 'Enter script path #%{counter}:'
    );
    
        # $post_install_next_script_path BEGIN
        my $post_install_next_script_path = DialogSequencer::Dialog->new(
            question => 'Next script path [%{options}] [%{default}]?'
        );
        $post_install_next_script_path->route('yes', $post_install_script_list);
        $post_install_next_script_path->route('no', undef);
        # $post_install_next_script_path END
    
    $post_install_script_list->route('V_FILE_PATH', $post_install_next_script_path);
    $post_install_script_list->convey(
        sub {
            push @{$data->{post_install_scripts}}, shift;
        }
    );
    # $post_install_script_list END

$post_install_top->route('yes', $post_install_script_list);
$post_install_top->route('no', undef);
$post_install_top->map(yes => 1, no => 0);
$post_install_top->convey(sub {$data->{post_install_required} = shift});

print Dumper $post_install_top;

