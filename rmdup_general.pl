#!/usr/bin/perl -w                                                                                                                                             \
                                                                                                                                                                            
use strict;
use warnings;

my @bamfiles = </local/projects-t3/SerreDLab-3/kieran.tebben/mali/*.bam>;
my $bam;

open(OUT2, ">", "/local/projects-t3/SerreDLab-3/kieran.tebben/mali/percent_duplicate_pf.txt");

foreach $bam (@bamfiles){
	my @files = split /\//, $bam;
	my $sample_name = $files[8];	
	(my $sample = $sample_name) =~ s/\.[^.]+$//;
	print "$sample\n";
	my $bam_rmdup = "${sample}.rmdup.bam";

	my $readname;
	my $chr;
	my $start;
	my $end;
	my $percent_dup = 0;
	my $duplicate = 0;
 	my $total = 0;
 	my $stats;
	
	open (BAM,"/usr/local/packages/samtools-1.9/bin/samtools view -h $bam |");
#	print "opened $bam\n";
	open(OUT, "| /usr/local/packages/samtools-1.9/bin/samtools view -Sb - > $bam_rmdup");
#	print "opened $bam_rmdup\n";

	my %reads;	
 	my %unique;
 	my $test = 0;
	
	while( my $line = <BAM>){
#		print "$line\n"; 
#		sleep(1);
    	chomp $line;
    	if($line =~ m/^@/) { 
    		print OUT "$line\n";
    		next;
		}
    	my @sam = split(/\t+/, $line);  ## splitting SAM line into array
    	$readname = $sam[0];
		if(defined $reads{$readname}){
   			if ($test ==1) {print OUT "$line\n"}
		}
   		else{
			$test = 0;
			$chr = $sam[2];
			if($sam[3] < $sam[7]){
    			$start = $sam[3];
    			$end = ($sam[7]+ 100);
    		}
    		else{
    			$start = $sam[7];
    			$end = ($sam[3] + 100);
    		}
#    		print "$sam[3]\n$sam[7]\n$start\n$end\n";
    		$stats = $chr."_$start"."_$end";
#   		print "$stats\n"; 
			if($sam[1] == 83 or $sam[1] == 163 or $sam[1] == 99 or $sam[1] == 147){
				$total++;
				if (defined $unique{$stats}) {
#					print "old $readname\tnew $unique{$stats}\n";
					$unique{$stats}++;
					$duplicate++;
				}
				else{
					$unique{$stats} = 1;
					print OUT "$line\n";
					$test = 1;
				}
			}
#			print "$reads{$stats}\n";
			$reads{$readname}++;
#			print $reads{$readname};
			}
		}	
		close OUT; 
#		print "$duplicate\n";
#		print "$total\n";
		if ($duplicate > 0){
			$percent_dup = ($duplicate/$total) * 100;
		}
		else{
			$percent_dup = 0;
		}
#	print "$percent_dup\n";
	print OUT2 "Sample\tPrimaryCorrectlyAlignedReads\tNumberDuplicates\tPercentDuplicateReads\n";
	print OUT2 "$sample";
	print OUT2 "\t$total";
	print OUT2 "\t$duplicate";
	print OUT2 "\t$percent_dup\n";
	print "$percent_dup\n";

	close BAM;

}
close OUT2; 

exit; 