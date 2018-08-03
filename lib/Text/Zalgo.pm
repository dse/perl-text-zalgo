package Text::Zalgo;
use warnings;
use strict;
use v5.10.0;

use open IO => ":locale";

use base "Exporter";
our @EXPORT_OK = qw(zalgo unzalgo);
our @EXPORT = qw(zalgo unzalgo);
our $min_intensity = 5;
our $max_intensity = 10;
our @zalgo_codes = (0x0300 .. 0x036f, 0x0488, 0x0489);

sub _zalgo {
    s{\S}{$& . zalgo_chars()}ge;
}

sub _unzalgo {
    s{[\x{0300}-\x{036f}\x{0488}\x{0489}]+}{}g;
}

sub zalgo {
    if (!scalar @_) {
        _zalgo;
    } elsif (!defined wantarray) {
        local $_;
        foreach (@_) {
            _zalgo;
        }
    }
    local $_;
    my @text = @_;
    foreach (@text) {
        _zalgo;
    }
    return @text if wantarray;
    return join("", @text);
}

sub unzalgo {
    if (!scalar @_) {
        _unzalgo;
    } elsif (!defined wantarray) {
        local $_;
        foreach (@_) {
            _unzalgo;
        }
    }
    local $_;
    my @text = @_;
    foreach (@text) {
        _unzalgo;
    }
    return @text if wantarray;
    return join("", @text);
}

sub zalgo_chars {
    my $result = "";
    my $chars = int(rand($max_intensity - $min_intensity + 1)) + $min_intensity;
    for (my $i = 1; $i <= $chars; $i += 1) {
        $result .= chr($zalgo_codes[int(rand(scalar @zalgo_codes))]);
    }
    return $result;
}

1;
