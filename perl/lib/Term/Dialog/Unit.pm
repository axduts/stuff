package Term::Dialog::Unit;

use strict;
use warnings;

use Data::Dumper;

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
    
    $self->{__INPUT__} = $input;
    
    # Validation sequence
    my @val_errors;
    for my $vsub ( @{ $self->{validation} } ) {
        
        if (ref $vsub ne 'CODE') {
            $vsub = $self->_resolve_validator($vsub);
        }
        
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
    
    
    $self->{commit}->($self->{__INPUT__});
}

sub _resolve_validator {
    my $self = shift;
    my $string = shift;
    
    my $resolved_value = $self->_dispatch($self->_sub_params($string));
    
    return $resolved_value;
}

sub _resolve_string {
    my $self = shift;
    my $args = {@_};
    
    my $string = $args->{string};
    
    my @matches = $string =~ /(\{\{.*?\}\})/g;
    
    for my $match (@matches) {
        
        my ($sub_params_str) = $match =~ m/\{\{\s*(.*?)\s*\}\}/g;
        
        
        my $resolved_value = $self->_dispatch($self->_sub_params($sub_params_str));
        
        $string =~ s/\Q${match}\E/${resolved_value}/;
    }
    
    return $string;
}

sub _sub_params {
    my $self = shift;
    my $string = shift;
    
    my ($sub, $params) = $string =~ m/(.*)\((.*)\)/g;
    
    my @params = ();
    
    if ($params) {
        @params = split(/\s*,\s*/, $params);
    }
    
    return ($sub, @params);
}

sub _dispatch {
    my $self = shift;
    my $sub = shift;
    my @args = @_;
    
    my $d = {
        items_row => sub {
            return sprintf("[%s]", join('/', @{ $self->{ $args[0] } }) );    
        },
        at_list => sub {
            return sub {
                my $input = shift;
                my $list = $self->{ $args[0] };
                
                if (grep( /^$input$/, @{ $list } )) {
                    return 1;
                }
                return (0, sprintf("%s is not at [%s]", $input, join '/', @{$list}));
            }
        }
    };
    
    
    return defined $d->{$sub} ? $d->{$sub}->() : "ERR_EMB:$sub";
}

1;