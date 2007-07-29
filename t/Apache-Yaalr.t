# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Apache-Yaalr.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 3;
BEGIN { use_ok('Apache::Yaalr') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

# see if we can create an object
my $apache_conf = Apache::Yaalr->new;
ok( defined $apache_conf );
ok( $apache_conf->isa( 'Apache::Yaalr' )); 
