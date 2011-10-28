use strict;
use warnings;
# ABSTRACT: An interactive shell to run Dist::Zilla commands
package Dist::Zilla::App::Command::shell;

use Dist::Zilla::App -command;

sub abstract { "open an interactive shell to run other DZ commands" }

sub execute
{
    my $self = shift;

    require Term::ReadLine;
    require Text::ParseWords;

    my $term = Term::ReadLine->new('Dist::Zilla shell');
    my $prompt = 'DZ> ';

    # Get the list of DZ commands
    my %builtins = map { ($_ => 1) } $self->app->command_names;

    while (1) {
	my $line = $term->readline($prompt);

	local @ARGV = Text::ParseWords::shellwords($line);
	next unless @ARGV;
	last if $ARGV[0] =~ /\A(?:exit|x|quit|q)\z/;

	if (exists $builtins{$ARGV[0]}) {
	    local $@;
	    eval { Dist::Zilla::App->new->run(@ARGV) };
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

This module is adds a new command to L<Dist::Zilla>: C<shell>. Run it and an
interactive shell is opened. You can then run any other Dist::Zilla
command that you usually run with "dzil I<command>" (even C<shell> itself, to
open a sub-shell, but that is useless). Type C<q|quit|exit|x> to exit the shell.

Any unknown command is executed in a system shell, so you can mix DZ commands
and system commands (ls, prove, git...).

Running DZ commands from a shell brings the benefit of avoiding the huge
startup cost due to Moose and all Dist::Zilla plugins. So the first run of
a command under the shell may be still slow, but any successive run will be
much faster.

=head1 TRIVIA

I started to seriously learn L<Dist::Zilla> at the QA Hackathon 2011 in
Amsterdam. I immediately had the idea of this shell as DZ is really
slow to start. Six months after, this the first DZ extension that I have
written.

=head1 SEE ALSO

L<http://dzil.org/>, L<Dist::Zilla>

=head1 AUTHOR

Olivier MenguE<eacute>, L<mailto:dolmen@cpan.org>

=head1 COPYRIGHT & LICENSE

Copyright E<copy> 2011 Olivier MenguE<eacute>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

