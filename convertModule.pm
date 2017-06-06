package convertModule;

use strict;
use warnings;
require Exporter;
use vars qw(@ISA @EXPORT);
@ISA = qw(Exporter);
@EXPORT = qw( getConversionValues getLookup getAnswer );
use JSON;
use Data::Dumper;

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

sub getLookup {
    my $unitsHASH = shift @_;

    #warn "in module". Dumper $unitsHASH;
    my %lookup;
    foreach my $unit (@$unitsHASH) {
        $lookup{$unit->{name}} = $unit->{units};
    }
    #warn "lookup " . Dumper \%lookup;
    return %lookup;
}

sub getAnswer {
    my %args   = @_;
    my $lookup = $args{lookup};
    my $type   = $args{type};
    my $from   = $args{from};
    my $to     = $args{to};
    my $value  = $args{value};

    my $answer = $value * $lookup->{$type}->{$from} * 1/$lookup->{$type}->{$to};
    return $answer;
}

1;
