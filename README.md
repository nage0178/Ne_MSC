# Ne_MSC
To simulate the sequence data, activate the virtual enviornment and run simulation script. 
This runs msprime to generate topologies and then runs seq-gen to generate sequence data.
msprime much be installed.

```
./run_topo_sim.sh
```

Then, infer trees with RAxML. These are needed as input for many of the methods.
```
./run_raxml.sh
```

Run ASTRAL
```
./run_astral.sh
```

Run MPEST
```
./run_mpest.sh
```

## Summarizing Results
To summarize the distribution of gene trees and recreate the figures, run the following
```
./list_gene_tree.sh
Rscript gene_tree_topology.R
Rscript gene_tree_dist.R
```
The first line creates a list of all of the gene tree files.
The next line calculates the RF distance to the species tree topology and writes it to a file. 
The last line creates the figures. 
Some paths will need to be changed to run on a different machine.


