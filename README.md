# PBS
1. Estimates pairwise Fst values among 1000G East Asian, Eurasian, and African populations with:    
sbatch slurm-vcftools-fst

2. Download human refseq genes   
(1) go to http://hgdownload.soe.ucsc.edu/downloads.html  
(2) choose human genomes  
(3) choose 'Genome sequence files and select annotations (2bit, GTF, GC-content, etc)' under 'Feb. 2009 (GRCh37/hg19)' + go down to the end   
(4) choose 'genes/'   
(5) double click 'hg19.ncbiRefSeq.gtf.gz' + copy link address ('https://hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/genes/hg19.ncbiRefSeq.gtf.gz')   
(6) choose after 'https:'   
(7) download with the following code on server:   
	rsync -a -P rsync:remote_path_to_file ./       
(8) unzip the file w/script    
	gunzip hg19.ncbiRefSeq.gtf.gz   
(9) find the boundaries of EDAR gene transcript on chr2 and save it to use in the figure   
	grep -w 'EDAR' hg19.ncbiRefSeq.gtf  

############    
    alternatively one can intersect PBS.bed and hg19.ncbiRefSeq.gtf files     
	 (1) sort PBS.bed file sort -k1,1 -k2,2n PBS.bed > PBS_sorted.bed    
	 (2) bedtools intersect -a PBS_sorted.bed -b hg19.ncbiRefSeq.gtf -loj > PBS_sorted_intersect_genes.bed    
############    

3. Estimate and print PBS values   
R pbs_rstudio.R   
