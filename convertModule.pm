package convertModule;

use strict;
use warnings;
require Exporter;
use vars qw(@ISA @EXPORT);
@ISA = qw(Exporter);
@EXPORT = qw( getConversionValues getLookup getAnswer );
use JSON;

# retrieves values in JSON format
sub getConversionValues {
    #my $units.json = get https://gist.githubusercontent.com/jessjenkins/c88c6ff207bc43721e729f9c9011aafa/raw/2baa8d9ffe309632d8b55107caffd745d1802651/units.json
    my $unitsJSON;
    {
        local $/;
        open my $fh, "<", "units.json" or die "Can't open file";
        $unitsJSON = <$fh>;
        close $fh;
    }
    return decode_json($unitsJSON);
}

# converts the JSON into a workable lookup for the getAnswer function
sub getLookup {
    my $unitsHASH = shift @_;
    my %lookup;
    foreach my $unit (@$unitsHASH) {
        $lookup{$unit->{name}} = $unit->{units};
    }
    return %lookup;
}

# returns the measurement conversion based on supplied arguments
sub getAnswer {
    my %args   = @_;
    my $lookup = $args{lookup};
    my $type   = $args{type};
    my $from   = $args{from};
    my $to     = $args{to};
    my $value  = $args{value};

    # every value is converted into 'base' unit, then divided into required unit
    # this relies on the values in units.json
    return $value * $lookup->{$type}->{$from} * 1/$lookup->{$type}->{$to};
}

1;
