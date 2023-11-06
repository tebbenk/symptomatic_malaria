#!/usr/bin/perl -w                                                                                                                                             \
                                                                                                                                                                            
use strict;
use warnings;

####Pre-processing steps before running HaplotypeCaller
####Have to run from hush and make sure that python is loaded

open (IN, "/local/projects-t3/SerreDLab-3/kieran.tebben/mali/sample_lists/symptomatic_IDs.txt");
my @raw_bamfiles;

while(<IN>) {
	chomp;
#	print "$_\n";
	push @raw_bamfiles, $_;
}

for my $bam_file (@raw_bamfiles){
	print "$bam_file\n";
	my $bam = "${bam_file}.pf.subset.rmdup.bam";
	my $add_readgroup_bam = "${bam_file}_readgroup.bam";
	my $bam_path = "/local/projects-t3/SerreDLab-3/kieran.tebben/mali/hisat2_outputs/pf_rmdup_bams/${bam}";
#	print "$add_readgroup_bam\n";
	system("/usr/local/packages/gatk/gatk AddOrReplaceReadGroups -I $bam_path -O $add_readgroup_bam -ID $bam_file -SM $bam_file -PL illumina -PU NONE -LB laneX");
	
	my $splitntrim = "${bam_file}_splitntrim.bam";
	system("/usr/local/packages/gatk/gatk SplitNCigarReads -R /local/projects-t3/SerreDLab-3/kieran.tebben/mali/genomes/PlasmoDB-54_Pfalciparum3D7_Genome.fa -I $add_readgroup_bam -O $splitntrim");

	print "Sorting\n";
	my $sorted_bam = "${bam_file}_splitntrim_sorted.bam";
	system("/usr/local/packages/samtools-1.9/bin/samtools sort $splitntrim -o $sorted_bam");
	
	print "Indexing\n";
	system("/usr/local/packages/samtools-1.9/bin/samtools index $sorted_bam");
}

