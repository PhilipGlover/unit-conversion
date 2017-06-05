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
) or die ("arggh");

#print "type : $type\n";
#print "from : $from\n";
#print "to : $to\n";
#print "value : $value\n";

my $units_json;
{
    local $/;
    open my $fh, "<", "units.json" or die "Can't open file";
    $units_json = <$fh>;
    close $fh;
}
#warn Dumper \$units_json;
my $conversion = decode_json($units_json);
#warn Dumper $conversion;
my %lookup;
foreach my $unit (@$conversion) {
    #warn Dumper $unit->{name};
    #$lookup{$unit->{name}} = 1;
    $lookup{$unit->{name}} = $unit->{units};
}
#warn "lookup " . Dumper \%lookup;
#warn "one " . $lookup{'time'}->{min};

die "The '$type' measurement can't be converted, please see https://gist.github.com/jessjenkins/c88c6ff207bc43721e729f9c9011aafa\n" if (!defined $lookup{$type});
die "The '$from' unit isn't part of '$type', please see https://gist.github.com/jessjenkins/c88c6ff207bc43721e729f9c9011aafa\n" if (!defined $lookup{$type}->{$from});
die "The '$to' unit isn't part of '$type', please see https://gist.github.com/jessjenkins/c88c6ff207bc43721e729f9c9011aafa\n" if (!defined $lookup{$type}->{$to});

my $answer = $value * $lookup{$type}->{$from} * 1/$lookup{$type}->{$to};

print "The answer is $answer\n";
