#!/usr/bin/perl -w                                                                                                                                             \

use strict;
use warnings;

my @bamfiles = </local/projects-t3/SerreDLab-3/kieran.tebben/mali/hisat2_outputs/bam/*.bam>;
my $bam;
my $bam_assigned;

open(OUT, ">", "/local/projects-t3/SerreDLab-3/kieran.tebben/mali/hisat2_outputs/human.txt");

foreach $bam (@bamfiles){
open (BAM,"/usr/local/packages/samtools-1.9/bin/samtools view -h $bam |");
#print "$bam\n";
my @files = split /\//, $bam;
my $sample_name = $files[8];	
(my $sample = $sample_name) =~ s/\.[^.]+$//;
print "$sample\n";
my $bam_human = "${sample}.subset.human.bam";
my $total;
my $human;

open(HUMAN, "| /usr/local/packages/samtools-1.9/bin/samtools view -Sb - > $bam_human");

	while( my $line = <BAM>){
    		chomp $line;
    		if($line =~ m/^@/) { 
    			print HUMAN "$line\n";
    			next;
	  		}
    	my @sam = split(/\t+/, $line);  ## splitting SAM line into array
    	if($sam[1] == 83 or $sam[1] == 163 or $sam[1] == 99 or $sam[1] == 147){
	   		$total++;
			if($sam[2] =~ "NC_"){
				print HUMAN "$line\n";
     			$human++;
     		}
     		if($sam[2] =~ "NT_"){
				print HUMAN "$line\n";
     			$human++;
     		}
     		if($sam[2] =~ "NW_"){
				print HUMAN "$line\n";
     			$human++;
     		}
     	}    	 
	}
	print OUT "Sample\tNumberAlignedHuman\n";
	print OUT "$sample";
	print OUT "\t$human";
	print OUT "\n";
	close HUMAN;
}

close OUT; 

exit; 