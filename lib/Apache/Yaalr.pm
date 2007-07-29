package Apache::Yaalr;

# $Id: Yaalr.pm 8 2007-07-05 23:44:48Z jeremiah $

use 5.008008;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw( @readable_httpd_conf );
our $VERSION = '0.02.8';

my (@readable_httpd_conf, @dirs);
my @mac = qw( /etc/apache /etc/apache2 /etc/httpd /usr/local/apache2 /Library/WebServer/ );
my @lin = qw( /etc/apache /etc/apache2 /etc/httpd /usr/local/apache2 /etc/apache-perl );

sub new {
    my $package = shift;
    return bless({}, $package);
}

sub guess {
    my $self = shift;

    use File::Find qw(find);
   
    if ($^O =~ /darwin/) {
	# grep for potential apache dirs on the system
	@dirs = grep {-d} @mac;
	die "no suitable directories" unless @dirs;
	
	find(\&httpd, @dirs);
	find(\&apache2, @dirs);	
	
	# return an array of files
	return @readable_httpd_conf;
    
    } elsif ($^O =~ /linux/) {
	
	@dirs = grep {-d} @lin;
	die "no suitable directories" unless @dirs;
	
	find(\&httpd, @dirs);
	find(\&apache2, @dirs);	

	# return an array of files
	return @readable_httpd_conf;

    } else {
	die "Cannot determine operating system.";
    }
}

sub httpd { 
    /^httpd.conf$/ &&
	-r &&
	push @readable_httpd_conf, $File::Find::name;
}

sub apache2 { 
    /^apache2.conf$/ &&
	-r &&
	push @readable_httpd_conf, $File::Find::name;
}


1;
__END__

=head1 NAME

Apache::Yaalr - Yet Another Apache Log Reader

=head1 SYNOPSIS

  use Apache::Yaalr qw( @readable_httpd_conf );

  my $files = Apache::Yaalr->new;
  my @file_array = $files->guess;
  print, print "\n" for @file_array;

=head1 DESCRIPTION

Apache::Yaalr will ultimately parse an Apache log file. Since there are a number of kinds
of log files and a number of different versions of Apache, we need to determine if an Apache 
web server exists on the computer we are running on. If we find an Apache web server, then 
we try to find the configuration file and the type of log being used. Finally we will parse
the log and report back.

=head1 Methods

Right now the module provides only guess()

=head1 SEE ALSO

More information can be found regarding Yaalr here: http://yaalr.sourceforge.net

Also Apache(1)

=head1 AUTHOR

Jeremiah Foster, E<lt>jeremiah@jeremiahfoster.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Jeremiah Foster

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
