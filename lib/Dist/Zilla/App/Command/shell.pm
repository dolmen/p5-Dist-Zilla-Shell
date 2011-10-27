use 5.008001;
use strict;
use warnings;
package Dist::Zilla::App::Command::shell;

# ABSTRACT: open
use Dist::Zilla::App -command;

sub abstract { "Open a interactive Dist::Zilla shell" }

sub opt_spec
{
    [ ]
}

sub execute
{
    my $self = shift;
    require Term::ReadLine;

    my $term = Term::ReadLine->new('Dist::Zilla shell');
    my $prompt = 'DZ> ';

    #my $DZA = Dist::Zilla::App->new;

    while (1) {
	my $line = $term->readline($prompt);
	last if $line =~ /\A\s*(?:exit|x|quit|q)\b/;

	# TODO: use a module implementing POSIX shell parsing
	local @ARGV = split /\s+/, $line;
	next unless @ARGV;
	last if $ARGV[0] =~ /\A(?:exit|x|quit|q)\z/;

	# Unfortunately we can not reuse the same Dist::Zilla::App object
	# (at least it does not work as expected)
	#$DZA->execute_command($DZA->prepare_command(@ARGV));
	# So, we use a new one
	Dist::Zilla::App->new->run;
    }
}

1;
