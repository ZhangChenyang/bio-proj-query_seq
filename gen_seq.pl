use strict;
use warnings;
# include libs
use Bio::EnsEMBL::Registry;
use Data::Dumper qw(Dumper);
use Text::CSV;
use Data::Dump qw(dump);

open(my $fh, '>>', './data/output.txt') or die "could not open";
select $fh;
my $file = $ARGV[0] or die "Need to get CSV file on the command line\n";
open(my $data, '<', $file) or die "Could not open '$file' $!\n";

my $registry2 = 'Bio::EnsEMBL::Registry';

# Load customized configuration.
$registry2->load_all(
    './myconfig.conf'
);

# Get human slice adaptor
my $slice_adaptor = $registry2->get_adaptor( 'Human', 'Core', 'Slice' );

while (my $line = <$data>) {
    # Remove any tailing '\n'.
    chomp $line;

    # Break string into array.
    my @fields = split "," , $line;

    # Note, the last character is somehow "Carriage Return", if so, we chop that char from the tail
    # of that string.
    my $last_word = pop @fields;
    my $last_word_length = length $last_word;
    if (ord(substr($last_word, $last_word_length-1, 1)) == 13) {
        $last_word = substr($last_word, 0, $last_word_length-1);
    }
    push @fields, $last_word;

    # Fetch the chromosome data from db via slice_adaptor.
    my $slice = $slice_adaptor->fetch_by_region('chromosome', $fields[0]+0, $fields[1]+0, $fields[2]+0);

    # Query the sequence.
    my $seq = $slice->seq();

    # push the sequence back to the array.
    push @fields, $seq;
    #print Dumper \@fields;

    # Write the array to the file
    foreach (@fields) {
        print "$_".',';
    }
    print "\n";

}
close $fh;
# TODO: cannot get file output working, so just select $fh, redirecting STDOUT to FILE, not good.





