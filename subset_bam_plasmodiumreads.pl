#!/usr/bin/perl -w                                                                                                                                             \

use strict;
use warnings;

my @bamfiles = </local/projects-t3/SerreDLab-3/kieran.tebben/mali/ovale/bam/*.intronlen.bam>;
my $bam;
my $bam_assigned;

open(OUT, ">", "/local/projects-t3/SerreDLab-3/kieran.tebben/mali/ovale/number_mapped_plasmo.txt");

foreach $bam (@bamfiles){
open (BAM,"/usr/local/packages/samtools-1.3.1/bin/samtools view -h $bam |");
#print "$bam\n";
my @files = split /\//, $bam;
my $sample_name = $files[8];	
(my $sample = $sample_name) =~ s/\.[^.]+$//;
print "$sample\n";
my $bam_pf = "${sample}.pf.subset.bam";
my $bam_po = "${sample}.po.subset.bam";
my $total;
my $pf;
my $po;

open(PF, "| /usr/local/packages/samtools-1.3.1/bin/samtools view -Sb - > $bam_pf");
open(PO, "| /usr/local/packages/samtools-1.3.1/bin/samtools view -Sb - > $bam_po");
	
	while( my $line = <BAM>){
    		chomp $line;
    		if($line =~ m/^@/) { 
    			print PF "$line\n";
  				print PO "$line\n";
    			next;
	  		}
    	my @sam = split(/\t+/, $line);  ## splitting SAM line into array
    	if($sam[1] == 83 or $sam[1] == 163 or $sam[1] == 99 or $sam[1] == 147){
	   		$total++;
      		if($sam[2] =~ "Pf3D7"){
      			print PF "$line\n";
      			$pf++;
 	     	}
 	     	if($sam[2] =~ "PocGH01"){
 	     		print PO "$line\n";
      			$po++;
	     	}
     	}    	 
	}
	print OUT "Sample\tNumberAlignedPf\tNumberAlignedPo\n";
	print OUT $sample;
	print OUT "\t$pf";
	print OUT "\t$po";
	print OUT "\n";
	close PF;
	close PO;
	close BAM;
}

close OUT; 

exit; 