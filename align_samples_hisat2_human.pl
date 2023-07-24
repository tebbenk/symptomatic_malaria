#!/usr/bin/perl -w                                                                                                                                             \
                                                                                                                                                                            
use strict;
use warnings;

my $genome = "/local/projects-t3/SerreDLab-3/kieran.tebben/mali/genomes/human_pf_USETHIS_indexed";
my $sam;
my $log;
my $bam; 
my $sorted;
my $log_files;
my @log_files; 
my $log_filename;
my @log_filepath;
my $log_filepath;

##Open list of sample names which are the directories and put into an array##
open (IN, "/local/projects-t3/SerreDLab-3/kieran.tebben/mali/sample_lists/sample3.txt");
my @sample_names;

while(<IN>) {
	chomp;
	push @sample_names, $_;
}

#print join " ", @sample_names;

##Write file path for directory where files for each sample are stored and sam/log file names##
my $sample_directory;

for my $sample (@sample_names) {
	print "$sample\n";
	$sample_directory = "/local/projects-t4/aberdeen2ro/SerreDLab-4/raw_reads/2021-09-16_UMB/${sample}/ILLUMINA_DATA";
#	print "$sample_directory\n";
	$sam = "${sample}.sam";
	$log = "${sample}_log.txt";
	$bam = "${sample}.bam";
#	$sorted = "${sample}.sorted.bam";
#	print "$sam\n$log\n";

##Open directory for each sample and pull out READ 1 files ##		
	opendir(DIR, $sample_directory);
			my @R1files = grep(/R1.fastq.gz$/,readdir(DIR));
		closedir(DIR); 
		
my $R1file;
my $R1_filepath;
		
	foreach $R1file (@R1files) {
		$R1_filepath = "$sample_directory/${R1file}";
# 		print "$R1_filepath\n";
	}

##Open directory for each sample and pull out READ 2 files ##
	opendir(DIR, $sample_directory);
			my @R2files = grep(/R2.fastq.gz$/,readdir(DIR));
		closedir(DIR);
		
my $R2file;
my $R2_filepath;
		
	foreach $R2file (@R2files) {
		$R2_filepath = "$sample_directory/${R2file}";
#		print "$R2_filepath\n";
	}
	
##Run hisat2 with each sample and human + plasmodium genome##
##Local
##system("/usr/local/packages/hisat2-2.0.4/hisat2 -x $genome -1 $R1_filepath -2 $R2_filepath -S  $sam --no-unal -p 16 &> $log"); 

##To run on grid 
system("/usr/local/packages/hisat2-2.1.0/hisat2 -x $genome -1 $R1_filepath -2 $R2_filepath -S  $sam --no-unal -p 16 &> $log"); 

##Convert sam to bam##
##Local
##system("/usr/local/packages/samtools-1.3.1/bin/samtools view -S -b -F 4 $sam > $bam"); 

##Grid
system("/usr/local/packages/samtools-1.9/bin/samtools view -S -b -F 4 $sam > $bam"); 

##Remove sam file##
system("unlink $sam");

}

close IN;

exit;