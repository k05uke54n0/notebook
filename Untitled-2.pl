#!/usr/bin/env perl

# Copyright (C) 2018 Itoh Laboratory, Tokyo Institute of Technology
# 
# This file is part of GINGER.
# 
# GINGER is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# GINGER is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License along
# with GINGER; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

######################################################################

my $cwd = `pwd`;
chomp($cwd);
my $vOpt = "-v $cwd:$cwd";
#my $sampleDir = "$cwd/sample_data";
my $outputDir = $ARGV[0];

if ($#ARGV < 0) {
    die "Usage: ./generateSampleData.pl [directory for sample data]";
}
my $sampleDir = "$cwd/$outputDir";

my $cmd = <<"GINGER";
mkdir $sampleDir
cd $sampleDir

#apptainer run --bind "$cwd:$cwd" /home/dendezia/tool/for_ginger/tools_GINGER_v1.0.1.sif /bin/bash -c "/usr/bin/wget https://ftp.ncbi.nlm.nih.gov/genomes/refseq/invertebrate/Caenorhabditis_elegans/all_assembly_versions/GCF_000002985.6_WBcel235/GCF_000002985.6_WBcel235_genomic.fna.gz -O $sampleDir/GCF_000002985.6_WBcel235_genomic.fna.gz"
#apptainer run --bind "$cwd:$cwd" /home/dendezia/tool/for_ginger/tools_GINGER_v1.0.1.sif /bin/bash -c "/usr/bin/wget [] -O $sampleDir/[]"

apptainer run --bind "$cwd:$cwd" tools_GINGER_v1.0.1.sif /bin/bash -c "/usr/bin/wget https://ftp.ncbi.nlm.nih.gov/genomes/refseq/invertebrate/Caenorhabditis_elegans/all_assembly_versions/GCF_000002985.6_WBcel235/GCF_000002985.6_WBcel235_genomic.fna.gz -O $sampleDir/GCF_000002985.6_WBcel235_genomic.fna.gz"

apptainer run --bind "$cwd:$cwd" /home/dendezia/tool/for_ginger/tools_GINGER_v1.0.1.sif /bin/bash -c "/usr/bin/wget https://ftp.ncbi.nlm.nih.gov/genomes/refseq/invertebrate/Caenorhabditis_elegans/all_assembly_versions/GCF_000002985.6_WBcel235/GCF_000002985.6_WBcel235_genomic.gff.gz -O $sampleDir/GCF_000002985.6_WBcel235_genomic.gff.gz"
apptainer run --bind "$cwd:$cwd" /home/dendezia/tool/for_ginger/tools_GINGER_v1.0.1.sif /bin/bash -c "/usr/bin/wget https://ftp.ncbi.nlm.nih.gov/genomes/refseq/invertebrate/Caenorhabditis_briggsae/all_assembly_versions/GCF_000004555.2_CB4/GCF_000004555.2_CB4_translated_cds.faa.gz -O $sampleDir/GCF_000004555.2_CB4_translated_cds.faa.gz" # for homology-based method 
apptainer run --bind "$cwd:$cwd" /home/dendezia/tool/for_ginger/tools_GINGER_v1.0.1.sif /bin/bash -c "/usr/bin/wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/180/635/GCA_000180635.4_El_Paco_v._4/GCA_000180635.4_El_Paco_v._4_translated_cds.faa.gz -O $sampleDir/GCA_000180635.4_El_Paco_v._4_translated_cds.faa.gz" # for homology-based method 
apptainer run --bind "$cwd:$cwd" /home/dendezia/tool/for_ginger/tools_GINGER_v1.0.1.sif /bin/bash -c "/usr/local/bin/prefetch SRR5849934 -O $sampleDir"

apptainer run --bind "$cwd:$cwd" /home/dendezia/tool/for_ginger/tools_GINGER_v1.0.1.sif /bin/bash -c "/usr/bin/zcat $sampleDir/GCF_000002985.6_WBcel235_genomic.fna.gz | /usr/local/bin/header.pl > $sampleDir/GCF_000002985.6_WBcel235_genomic.commentModified.fna"
apptainer run --bind "$cwd:$cwd" /home/dendezia/tool/for_ginger/tools_GINGER_v1.0.1.sif /bin/bash -c "/usr/local/bin/lower2N.pl $sampleDir/GCF_000002985.6_WBcel235_genomic.commentModified.fna > $sampleDir/GCF_000002985.6_WBcel235_genomic.commentModified.masked.fna"
apptainer run --bind "$cwd:$cwd" /home/dendezia/tool/for_ginger/tools_GINGER_v1.0.1.sif /bin/bash -c "/usr/bin/touch $sampleDir/GCF_000002985.6_WBcel235_genomic.out"
apptainer run --bind "$cwd:$cwd" /home/dendezia/tool/for_ginger/tools_GINGER_v1.0.1.sif /bin/bash -c "/usr/bin/rm $sampleDir/GCF_000002985.6_WBcel235_genomic.fna.gz"

apptainer run --bind "$cwd:$cwd" /home/dendezia/tool/for_ginger/tools_GINGER_v1.0.1.sif /bin/bash -c "/usr/bin/gunzip $sampleDir/GCF_000002985.6_WBcel235_genomic.gff.gz"

apptainer run --bind "$cwd:$cwd" /home/dendezia/tool/for_ginger/tools_GINGER_v1.0.1.sif /bin/bash -c "/usr/bin/gunzip $sampleDir/GCF_000004555.2_CB4_translated_cds.faa.gz"
apptainer run --bind "$cwd:$cwd" /home/dendezia/tool/for_ginger/tools_GINGER_v1.0.1.sif /bin/bash -c "/usr/bin/gunzip $sampleDir/GCA_000180635.4_El_Paco_v._4_translated_cds.faa.gz"

apptainer run --bind "$cwd:$cwd" /home/dendezia/tool/for_ginger/tools_GINGER_v1.0.1.sif /bin/bash -c "/usr/local/bin/fastq-dump --split-files $sampleDir/SRR5849934/SRR5849934.sra --outdir $sampleDir"
apptainer run --bind "$cwd:$cwd" /home/dendezia/tool/for_ginger/tools_GINGER_v1.0.1.sif /bin/bash -c "rm -r $sampleDir/SRR5849934"
GINGER

# コマンド実行
system($cmd);