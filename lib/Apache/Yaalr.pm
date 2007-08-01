package Apache::Yaalr;

# $Id: Yaalr.pm 9 2007-07-31 21:20:13Z jeremiah $

use 5.008008;
use strict;
use warnings;
use Carp qw(croak);

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw( @readable_httpd_conf );
our $VERSION = '0.02.9';

my (@readable_httpd_conf, @dirs);
my @mac = qw( /etc/apache /etc/apache2 /etc/httpd /usr/local/apache2 /Library/WebServer/ );
my @lin = qw( /etc/apache /etc/apache2 /etc/httpd /usr/local/apache2 /etc/apache-perl );

sub new {
    my $package = shift;
    return bless({}, $package);
}

sub os { # operating system best guess, we'll need this later                                                         
    my $self = shift;
    my $uname = `which uname`;
    my @os;
    
    if ($uname) {
        push @os, `uname -a` or croak "Cannot execute uname -a";
    } elsif ($^O) {
        push @os, "$^O unknown";
    } else {
        push @os, "unknown unknown";
    }
    return @os;
}

sub find_conf {
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

Apache::Yaalr - Perl module for Yet Another Apache Log Reader

=head1 SYNOPSIS

    use Apache::Yaalr qw( @readable_httpd_conf );

    my $files = Apache::Yaalr->new;
    my @config_files = $files->find_conf;
    print, print "\n" for @file_array;

    $q->os();          - a guess of the operating system using uname -a if uname exists. 
                         Otherwise this uses $^O. If it cannot find the hostname or oper-                                          
                         ating system, it returns unknown.    

=head1 DESCRIPTION

The goal of Yaalr (Yet Another Apache Log Reader) is to read Apache access logs and report 
back. Since the Apache web server can have its access log in different places
depending on operating system, Yaalr does its best to find out what type of operating 
system is being used and then find the configuration files to extract the location of the log
files. Along the way a lot of other potentially useful information is gathered which can also 
be accessed through the above interface. 

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
