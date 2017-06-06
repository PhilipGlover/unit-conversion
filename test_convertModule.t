#!/usr/bin/perl
use strict;
use warnings;

use Test::More;

use Cwd;
use lib cwd();

use_ok('convertModule');

test__getAnswer();

done_testing();

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

    $answer = getAnswer(
        lookup => \%lookup,
        type   => 'time',
        from   => 'hr',
        to     => 's',
        value  => 1
    );
    is ($answer, 3600, '1 hour should be 3600 seconds');

    $answer = getAnswer(
        lookup => \%lookup,
        type   => 'length',
        from   => 'ft',
        to     => 'mm',
        value  => 2
    );
    is ($answer, 609.6, '2 feet should be 609.6 millimeters');
}

exit(0);
