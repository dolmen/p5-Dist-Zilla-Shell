use strict;
use warnings;
# ABSTRACT: An interactive shell to run Dist::Zilla commands
package Dist::Zilla::App::Command::shell;

use Dist::Zilla::App -command;

sub abstract { "open an interactive shell to run other DZ commands" }

sub execute
{
    my $self = shift;

    # Get the list of commands
    my %builtins = map { ($_ => 1) } $self->app->command_names;
    my $app_class = ref($self->app);

    require Term::ReadLine;
    require Text::ParseWords;

    my $term = Term::ReadLine->new('Dist::Zilla shell');
    my $prompt = 'DZ> ';
    my $count = 0;

    while (1) {
	my $line = $term->readline($prompt);

	local @ARGV = Text::ParseWords::shellwords($line);
	next unless @ARGV;
	last if $ARGV[0] =~ /\A(?:exit|x|quit|q)\z/;

	if ($ARGV[0] eq 'release' && $count) {
	    warn "AFAIK, DZil is not totally clean in starting each command from a clean state.\nSo for safety reasons, please run \"dzil realease\" outside the DZil Shell.\n";
	    last;
	} elsif (exists $builtins{$ARGV[0]}) {
	    $count++;
	    local $@;
	    eval { $app_class->run(@ARGV) };
	    print STDERR $@ if $@;
	} else {
	    # Pass the line as-is to the shell
	    system $line;
	}
    }
}

1;
__END__

=head1 NAME

Dist::Zilla::App::Command::shell - An interactive shell for Dist::Zilla

=head1 SYNOPSIS

    $ dzil shell
    
    DZ> build
    ...
    
    DZ> test
    ...
    
    DZ> release
    ...
    
    DZ> q

=head1 DESCRIPTION

See L<Dist::Zilla::Shell>.

=head1 AUTHOR

Olivier MenguE<eacute>, L<mailto:dolmen@cpan.org>

=head1 COPYRIGHT & LICENSE

Copyright E<copy> 2011 Olivier MenguE<eacute>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

