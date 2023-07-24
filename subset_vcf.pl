#!/usr/bin/perl -w                                                                                                                                             \

##Filters our var genes, removes indels

                                                                                                                                                                            
use strict;
use warnings;

my %keep;

open(GENES, "/local/projects-t3/SerreDLab-3/kieran.tebben/mali/genomes/po_genes.txt");
#print "opened\n";

while(my $line = <GENES>){
#	print $line;
	
	my @info = split(/\t+/, $line);
#	print "$info[1]\n";
	my $chr = $info[0];
#	print "$chr\n";
	my $start = $info[1];
	my $end = $info[2];
#	print "$chr\t$start\t$end\n";
	for(my $i = $start; $i <= $end; $i++){
		my $position = $chr."_$i";
		$keep{"$position"} = 1;
#		print "$position\n";
#		sleep(1);
	}
}

close(GENES);

my $vcf = "/local/projects-t3/SerreDLab-3/kieran.tebben/mali/ovale/po_bams/vcf_files/po_filt2.vcf.recode.vcf";

my $out = "po_final_filtered.vcf";
#	print "$out\n";
open(OUT, ">", "/local/projects-t3/SerreDLab-3/kieran.tebben/mali/ovale/po_bams/vcf_files/$out");

open(IN, $vcf);
print "opened\n";
	
while(my $vcf_line = <IN>){
	chomp $vcf_line;
	if($vcf_line =~ m/^#/) {
		if($vcf_line =~ "N[CTW]_"){
			next;
		} 
		else{
			print OUT "$vcf_line\n";
			next;
		}
	}
#	print "$vcf_line\n";
#	sleep(1);
	my @info = split(/\t+/, $vcf_line);
	my $type = $info[7];
#	print "$type\n";
#	sleep(1);
	my $chr = $info[0];
#	print "$chr\n";
#	sleep(1);
 	my $loc = $info[1];
#	print "$loc\n";
#	sleep(1);
 	my $position = $chr."_$loc";
# #		print "$position\n";
 	if (defined $keep{$position}){
 		if ($type =~ "INDEL"){
 #			print "$type\n";
 			next;
 		}
 		else{
 		#print "$position\n";
 		print OUT "$vcf_line\n";
 		}
 	}
}
close(OUT);



exit;