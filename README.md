# Ne_MSC

This repository contains the scripts to reproduce the results from Impact of Variable Population Size on Species Tree and Divergence Time Inference by Anna A. Nagel and Michael J. Landis. 

There are two main sets of analyses in this manuscript: inferring tree topology and inferring divergence time on the true topology. 
These analyses are run for a variety simulation conditions with several methods.
The dependencies are listed at the bottom of the README.md.
Note that many of the scripts below are written to use multiple threads. 
All scripts are run from within the Ne_MSC directory, not any of the directories within it.

## Simulating datasets
There are two types of datasets: multilocus datasets which assume no recombination within a locus and free recombination between loci and datasets with unlinked sites, where each site independent of all all other sites conditional on the species tree. 
The gene trees are simulated with msprime and saved to file. 
Then, sequences are generated with seq-gen. 
Although sequences can be simulated with msprime, it is quite slow for full sequence data. 

### Linked sites 
To simulate the sequence data, first create a virtual environment with msprime. 
The simulation script assumes the virtual environment is called venv in is located at the Ne\_MSC directory.   
Then, run simulation script. 
This runs msprime to generate topologies and then runs seq-gen to generate sequence data.
Note that this script will run many scripts at once. 

```
./run_topo_sim.sh
```
Note that some additional datasets are generated that were not use in the final analyses. 

### Unlinked sites 
Simulation of datasets unlinked sites with unlinked sites works very similarly to the linked sites. 
However, it takes much longer and it computationally more expensive since every site has a unique gene tree and the DNA simulation must be run separately for every gene tree. 
After the DNA is simulated for each gene tree, the site patterns must be combined into a single sequence file.
This procedure results in generating a very large number of files. 
The scripts are written to delete many of the files as they are no longer needed. 
However, the number of files may cause issues on some computers.
The simulations take a while and are written to use multiple threads.

In initial analyses, datasets were generated with 5,000 and 20,000 sites. 
Later, it was decided to use 20,000 and 80,000 site datasets.
To remain reproducible based on how the seeds are determined, the 5,000 site datasets are included in the script though they do not appear in the manuscript. 
The unlinked sites simulations can be run with the following command: 

```
./run_SNP_sim.sh
```

## Topology Analyses
Both ASTRAL and MP-EST require gene trees as input. 
Gene trees can be  with RAxML using the command below.
This will infer a gene tree for all loci in the linked sites datasets.

```
./run_raxml.sh
```

Next, ASTRAL can be run with the following command:
```
astral_files/run_astral.sh
```
This first combines the inferred gene trees into a single files and then runs ASTRAL for all datasets. 

MP-EST can be run with: 
```
./run_mpest.sh
```
This first formats the data into newick format, runs MP-EST, and then format the results for comparison to other programs.
MP-EST can only run on datasets with a single sample per species.

There are two sets of PICL analyses, ones with theta fixed and ones with theta first inferred and the inferred values used in the analyses. 
The latter analyses are only run on the datasets with multiple samples per species.
To run the PICL analyses, first the settings files much be created and the data must be formatted. 
The data also must be formatted into a vcf file to infer theta.
This is accomplished with:
```
picl_files/prep_SNP_PICL.sh
picl_files/prep_SNP_est_theta.sh
```
This also prepares the files for the divergence time analyses. 
PICL is run 4 times for each topology inference with different seeds. 
Then, the tree with the maximum composite likelihood is chosen as the best tree and an outgroup is added to the tree for comparisons to the other trees.

```
picl_files/run_picl_parallel_topo_SNP.sh
picl_files/run_picl_parallel_topo_est_theta.sh
picl_files/find_likelihood.sh 
```

Lastly, the control files for bpp and reformatting of the sequence data is accomplished with 
```
bpp_files/mk_bpp_ctrl.sh
```
This also prepares the files the divergence time analyses.

For each dataset, bpp is run twice using the following command. The larger analyses take several hours to run.
```
bpp_files/run_bpp_topology.sh
```

To check the convergence of the analyses, whether the two replicate MCMCs give the same MAP tree is checked. 
Additionally, the R packages RWTY is used to get approximate ESS values. 
This requires some reformatting of the output bpp trees first.
To check the convergence, run the following: 
```
bpp_files/only_bpp_trees.sh
bpp_files/get_MAP_bpp.sh
Rscript bpp_files/check_bpp_topology.R
bpp_files/prep_convergence_bpp.sh
```
This produces files with approximate ESS values for each pair of MCMCs and a file that lists analyses where the two MAP trees did not match.

The coverage table for bpp can be reproduced with the following. It first makes a table of all the tree topologies from bpp for a single run. Then these are used to calculate coverage in R. 
```
bpp_files/coverage_topology.sh
Rscript bpp_files/check_coverage.R
```

## Divergence Time  and Branch Length Analyses
Divergence time analyses infer the divergence times or branch lengths.

Branch lengths are estimated with CASTLES integrated into ASTRAL. First the inferred gene trees are combined and then ASTRAL is run. 
Then, a secondary script is used to collect all the inferred branch lengths in a table.
```
astral_files/run_astral_bl.sh
astral_files/get_astral_bl.R
```

As with the topology analyses, two sets of PICL analyses are run. 
The first uses the theta value from simulation and the other first infers theta and uses the inferred value to run PICL.
The latter analyses are only run for the datasets with multiple samples per species.
```
picl_files/run_picl_parallel_SNP_time.sh
picl_files/run_picl_parallel_SNP_time_est_theta.sh
```

The inferred tree is found in the output files.
Note the first script does this for both the topology and the divergence times inferences.
Then, the divergence times from all the analyses are combined into a table.
```
picl_files/process_picl_SNP.sh
Rscript picl_files/get_picl_tau.R
```

Similar to the topology analyses, bpp is run twice for each dataset using the following command.
```
bpp_files/run_bpp_time.sh
```

An additional set up bpp analyses uses ghost population to correctly specify the demographic model. 
These can be run with the following: 
```
bpp_files/run_bpp_time_ghost.sh
```

Convergence is assess using the ESS values reported by bpp and the Gelman diagnostic. 
These are both accomplished with the following script.
```
bpp_files/convergence_time_bpp.sh
```

Then, the divergence time inferences are summarized, first by getting the means and HPDs from each individual analyses and them combining them into a table
```
bpp_files/bpp_time_sum.sh
Rscript summary_time_bpp.R 
```

Analyses to estimate divergence times with baseml are run with the command below.
This prepares the sequence data and runs baseml. If baseml does not converge, it is run again. 
Then the tree with divergence time estimates is extracted from the output and the divergence times are summarized into a table.
```
./run_baseml.sh
```

## Summarizing Results and Plotting 
This section summarizes how to reproduce the figure in the manuscript. 
Some paths will need to be changed to run on a different machine, in particular all the output paths of the figures.

### Gene tree distributions
To summarize the distribution of gene trees and recreate the figures, run the following
```
./list_gene_tree.sh
Rscript gene_tree_topology.R
Rscript gene_tree_dist.R
```
The first line creates a list of all of the gene tree files.
The next line calculates the RF distance to the species tree topology and writes it to a file. 
The last line creates the figures. 

### Tree topology analyses
To summarize the topology analyses, first the RF distance is computed between the true and inferred trees. 
Then, the tree topology plots are created. The script to infer RF distances takes a list of the trees, which is created in a separate script first.
```
./list_trees.sh
Rscript check_topology.R
Rscript rf_plots.R
```

### Divergence time and branch length analyses
The divergence time and branch length analyses are plotted with the commands below. 
The coverage is also plotted.
This also plots the bias for the branch lengths.
```
Rscript plot_divergence_combined.R
Rscript bl_plots.R
```

The thetas for bpp are plotted with: 
```
Rscript bpp_time_plot.R
```

## Dependencies
- Python3
- python packages: msprime (version 1.4.0), AlignIO, numpy
- seq-gen (version 1.3.5)
- ASTRAL in ASTER (version v1.25.4.8)
- RAXML-NG (version 2.0.1)
- MP-EST (version 3.0)
- PICL (version 1.2 (commit 5195c80)
- bpp (version v4.8.7) 
- baseml in PAML (version 4.10.10)
- R
- R packages: ape, coda, dplyr, forcats, ggplot2, patchwork, phangorn, rwty, tidyr, viridis
- bcftools (version 1.13)
- vcftools (version 0.1.18)

