use strict;
use warnings;
# include libs
use Bio::EnsEMBL::Registry;
use Data::Dumper qw(Dumper);
use Text::CSV;
use Data::Dump qw(dump);
use Scalar::Util qw(looks_like_number);
use Time::HiRes qw(time);

open(my $fh, '>>', './data/output.txt') or die "could not open";
my $file = $ARGV[0] or die "Need to get CSV file on the command line\n";
open(my $data, '<', $file) or die "Could not open '$file' $!\n";

my $registry2 = 'Bio::EnsEMBL::Registry';

# Load customized configuration.
$registry2->load_all(
    './myconfig.conf'
);

# Get human slice adaptor
my $slice_adaptor = $registry2->get_adaptor( 'Human', 'Core', 'Slice' );

# Create a Hash to store visited chr-s-e keys.
my $visited = {};
my $req_cnt = 0;
my $total_cnt = 0;

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

    # Get the chr-s-e key.
    my $chr_id = $fields[0];
    my $start = $fields[1]+0;
    my $end = $fields[2]+0;
    my $label = $fields[3];
    if(looks_like_number($chr_id)) {
        $chr_id = $chr_id + 0;
    }

    my $key = $chr_id.$start.$end.$label;
    
    $total_cnt++;
    # Check visited.
    if (exists $visited->{$key}) {
        next;
    }else{
        $visited->{$key} = 1;
        $req_cnt++;
    }
    my $start_time = time();

    # Fetch the chromosome data from db via slice_adaptor.
    my $slice = $slice_adaptor->fetch_by_region('chromosome', $chr_id, $start, $end);

    # Query the sequence.
    my $seq = $slice->seq();

    # push the sequence back to the array.
    push @fields, $seq;

    # check what inside fields array.
    #print Dumper \@fields;

    # Write the array to the file
    foreach (@fields) {
        print $fh "$_".',';
    }
    print $fh "\n";

    my $elapsed_time = time() - $start_time;
    $elapsed_time = sprintf("%.4f", $elapsed_time);

    print("Processed $req_cnt requests, ($total_cnt in file), using $elapsed_time seconds.\n");

}
close $fh;





