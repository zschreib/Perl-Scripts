#!/usr/bin/perl -w

=head1 NAME
	
	cdhit_pull_clstrs_by_size.pl : Takes in a cd-hit cluster file and pulls 
				       out clusters that have a specified number of cluster members. 

=head1 SYNOPSIS

USAGE: 			   
	--input_file= -i
        --size= -n
        --help= -h

=head1 OPTIONS

B<--help, -h>
    Help

=head1  INPUT

    	Input cd-hit cluster file

=head1  OUTPUT

	Cluster file with a min set amount of rep members.

=head1	EXAMPLE
	
	cdhit_pull_clstrs_by_size.pl -i=db.clstr -n=4 > dboutput_4.clstr
	
=head1  CONTACT

        Zach Schreiber zschreib@udel.edu

=cut

use strict;
use warnings;
use Data::Dumper;
use Cwd;
use Pod::Usage;
use Getopt::Long qw(:config no_ignore_case no_auto_abbrev pass_through);

my %options = ();

my $results = GetOptions (\%options,
                          'input_file|i=s',
                          'size|n=i',
                          'help|h') || pod2usage();

if( $options{'help'} ){
    pod2usage( {-exitval => 0, -verbose => 2, -output => \*STDERR} );
}

##user input error flags
die "Missing input cd-hit cluster file! -i\n" unless $options{input_file};
die "Missing min cluster size cut off! -n\n" unless $options{size};
##

my $cluster = $options{input_file};
my $size = $options{size};

my $cluster_id;
my $whole_orf_id;
my @a = [];

my %data = ();
## LOAD DATA INTO HASH

open(IN,"<$cluster") || die "\n Cannot open the infile: $cluster\n";

while(<IN>) {
    chomp $_;

    if ($_ =~ m/^>/) {
        $cluster_id = $_;		
    }

    else {
        $whole_orf_id = $_;
	push(@{$data{$cluster_id}}, $whole_orf_id);		
    }
}

close(IN);

##
my $flag = 0;

for my $key (keys %data){
	my $seq = scalar(@{$data{$key}});

	if($seq >= $size){
		print $key . "\n";
		$flag = 1;
	}

	if($flag == 1){
	
	 for my $index ( @{$data{$key}}){
           if($seq >= $size){
		print $index . "\n";
		$flag = 0;
	   }
	 }
	}

	else{
		next;
	}
}
