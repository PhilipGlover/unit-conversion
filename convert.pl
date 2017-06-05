#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long qw (GetOptions);
use JSON;
use LWP::Simple;

use Data::Dumper;

my ($type, $from, $to, $value);

GetOptions(
    'type=s' => \$type,
    'from=s' => \$from,
    'to=s'   => \$to,
    'v=f'    => \$value,
) or exit usage();

sub usage {
	print <<EOS;
./convert.pl --type --from --to --v

Converts measurement units as per given json file.

options:
    -type=s		unit of measurement eg time
    -from=s     convert from this unit
    -to=s       convert to this unit
    -v=f       	value to for filtering, see docs
    -help       print this help

EOS
    return 1;
}

#my $units.json = get https://gist.githubusercontent.com/jessjenkins/c88c6ff207bc43721e729f9c9011aafa/raw/2baa8d9ffe309632d8b55107caffd745d1802651/units.json
my $unitsJSON;
{
    local $/;
    open my $fh, "<", "units.json" or die "Can't open file";
    $unitsJSON = <$fh>;
    close $fh;
}

my $unitsHASH = decode_json($unitsJSON);
#warn Dumper $unitsHASH;
my %lookup;
foreach my $unit (@$unitsHASH) {
    $lookup{$unit->{name}} = $unit->{units};
}
#warn "lookup " . Dumper \%lookup;

die "The '$type' measurement can't be converted, please see https://gist.github.com/jessjenkins/c88c6ff207bc43721e729f9c9011aafa\n" if (!defined $lookup{$type});
die "The '$from' unit isn't part of '$type', please see https://gist.github.com/jessjenkins/c88c6ff207bc43721e729f9c9011aafa\n" if (!defined $lookup{$type}->{$from});
die "The '$to' unit isn't part of '$type', please see https://gist.github.com/jessjenkins/c88c6ff207bc43721e729f9c9011aafa\n" if (!defined $lookup{$type}->{$to});

my $answer = $value * $lookup{$type}->{$from} * 1/$lookup{$type}->{$to};
print "The conversion of $value$from in $type is $answer$to.\n";
