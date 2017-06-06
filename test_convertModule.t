#!/usr/bin/perl
use strict;
use warnings;

#use Test::More tests => 4;
use Test::More qw/no_plan/;

use Cwd;
use lib cwd();

use_ok('convertModule');

test__getAnswer();

sub test__getAnswer {
    my $unitsHASH = getConversionValues();
    my %lookup = getLookup($unitsHASH);
    my $answer = getAnswer(
        lookup => \%lookup,
        type   => 'weight',
        from   => 'kg',
        to     => 'g',
        value  => 2
    );
    is ($answer, 2000, '2kg should be 2000g');

}

exit(0);
