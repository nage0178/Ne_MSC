import msprime
import tskit
import argparse
import numpy as np
import sys

# Should be able to use the same as exponential decline
# Thinking backward in time, start is close to time present
def bottleneck(demo, pop, N_1, N_2, t_start, t_end ):
    
    if (N_1 < N_2):
        N_start = N_1
        N_end = N_2
    else:
        N_start = N_2
        N_end = N_1


    growth_rate = np.log(N_end / N_start) / -(t_end - t_start)

    demo.add_population_parameters_change (
        time=t_start,
        initial_size=N_start,
        growth_rate=growth_rate,
        population=pop
    )

    return
    
# The middle third of the branch is population different size
def piecewise_const(demo, pop, N_middle, N_ends, t_start, t_end ):

    time_length = t_end - t_start 

    demo.add_population_parameters_change (
        time=t_start + (time_length / 3),
        initial_size=N_middle,
        growth_rate=0,
        population=pop
    )

    demo.add_population_parameters_change (
        time=t_start + (time_length * 2 / 3),
        initial_size=N_middle,
        growth_rate=0,
        population=pop
    )

    return

def build_bal_topol_sim(N, T_AB, T_ABC, T_DE, T_ABCDE, T_root, Ne_scenario, Ne_size):
    demo_bal = msprime.Demography()
    demo_bal.add_population(name = "A", initial_size = N)
    demo_bal.add_population(name = "B", initial_size = N)
    demo_bal.add_population(name = "C", initial_size = N)
    demo_bal.add_population(name = "D", initial_size = N)
    demo_bal.add_population(name = "E", initial_size = N)
    demo_bal.add_population(name = "O", initial_size = N)
    
    demo_bal.add_population(name =   "AB",  initial_size = N)
    demo_bal.add_population(name =  "ABC",  initial_size = N)
    demo_bal.add_population(name =   "DE",  initial_size = N)
    demo_bal.add_population(name = "ABCDE", initial_size = N)
    demo_bal.add_population(name = "root",  initial_size = N)
    
    demo_bal.add_population_split(time =   T_AB,  derived=[   "A",  "B"],  ancestral =    "AB")
    demo_bal.add_population_split(time =  T_ABC,  derived=[  "AB",  "C"],  ancestral =   "ABC")
    demo_bal.add_population_split(time =   T_DE,  derived=[   "D",  "E"],  ancestral =    "DE")
    demo_bal.add_population_split(time = T_ABCDE, derived=["ABC",  "DE"],  ancestral = "ABCDE")
    demo_bal.add_population_split(time =  T_root, derived=["ABCDE", "O"],  ancestral =  "root")

    if (Ne_size == "i") :
        bottle_ratio = 100
        piecewise_ratio = 10
    elif (Ne_size == "d") :
        bottle_ratio = 0.01
        piecewise_ratio = 0.1
    else :  
        sys.exit("Ne_size not recognized. Check --Ne_size option. Options are i (increase) and d (decrease).")

    # Bottleneck
    if (Ne_scenario == "s2"):
        bottleneck(demo_bal,  "A", N, N * bottle_ratio, T_AB * .5, T_AB)
        bottleneck(demo_bal, "DE", N, N * bottle_ratio, (T_DE + T_ABCDE) / 2.0, T_ABCDE)

    # Population decline
    elif (Ne_scenario == "s3"):
        # Reduction by order of magnitude in pop size
        piecewise_const(demo_bal,  "A", N * piecewise_ratio, N,  0,  T_AB)
        piecewise_const(demo_bal, "DE", N * piecewise_ratio, N, T_DE,  T_ABCDE)
        #bottleneck(demo_asy, "DE", N * 0.01, N, (T_DE + T_ABCDE) / 2.0, T_ABCDE)
        #bottleneck(demo_asy,  "A", N * 0.01, N, T_AB * .5, T_AB)

    # Not implemented in msprime
    # Either linear or cycles
    #elif (Ne_scenario == "s4"):
    #    bottleneck(demo_asy, "A", N, N * .01, T_AB * .5, T_AB)

    # Constant
    elif (Ne_scenario != "s1"):
         sys.exit("sim_name not recognized. Check --sim_name option. Options are s1, s2, s3.")

    demo_bal.sort_events()
    #print(demo_bal.debug())

    return demo_bal

def build_asy_topol_sim(N, T_AB, T_ABC, T_ABCD, T_ABCDE, T_root, Ne_scenario, Ne_size):
    demo_asy = msprime.Demography()
    demo_asy.add_population(name = "A", initial_size = N)
    demo_asy.add_population(name = "B", initial_size = N)
    demo_asy.add_population(name = "C", initial_size = N)
    demo_asy.add_population(name = "D", initial_size = N)
    demo_asy.add_population(name = "E", initial_size = N)
    demo_asy.add_population(name = "O", initial_size = N)
    
    demo_asy.add_population(name =    "AB", initial_size = N)
    demo_asy.add_population(name =   "ABC", initial_size = N)
    demo_asy.add_population(name =  "ABCD", initial_size = N)
    demo_asy.add_population(name = "ABCDE", initial_size = N)
    demo_asy.add_population(name =  "root", initial_size = N)
    
    demo_asy.add_population_split(time =    T_AB, derived=[     "A", "B"], ancestral =    "AB")
    demo_asy.add_population_split(time =   T_ABC, derived=[    "AB", "C"], ancestral =   "ABC")
    demo_asy.add_population_split(time =  T_ABCD, derived=[   "ABC", "D"], ancestral =  "ABCD")
    demo_asy.add_population_split(time = T_ABCDE, derived=[  "ABCD", "E"], ancestral = "ABCDE")
    demo_asy.add_population_split(time =  T_root, derived=[ "ABCDE", "O"], ancestral =  "root")

    if (Ne_size == "i") :
        bottle_ratio = 100
        piecewise_ratio = 10
    elif (Ne_size == "d") :
        bottle_ratio = 0.01
        piecewise_ratio = 0.1
    else :
        sys.exit("Ne_size not recognized. Check --Ne_size option. Options are i (increase) and d (decrease).")
    
    # Bottleneck
    if (Ne_scenario == "s2"):
        bottleneck(demo_asy,     "A", N, N * bottle_ratio, T_AB * .5, T_AB)
        bottleneck(demo_asy, "ABCD",  N, N * bottle_ratio, (T_ABCD + T_ABCDE) / 2.0, T_ABCDE)

    # Piecewise constant
    elif (Ne_scenario == "s3"):
        #bottleneck(demo_asy,     "A", N * 0.01, N, T_AB * .5, T_AB)
        #bottleneck(demo_asy, "ABCD",  N * 0.01, N, (T_ABCD + T_ABCDE) / 2.0, T_ABCDE)
        piecewise_const(demo_asy,    "A", N * piecewise_ratio, N,  0,  T_AB)
        piecewise_const(demo_asy, "ABCD", N * piecewise_ratio, N, T_ABCD,  T_ABCDE)

    # Not implemented in msprime
    # Either linear or cycles
    #elif (Ne_scenario == "s4"):
    #    bottleneck(demo_asy, "A", N, N * .01, T_AB * .5, T_AB)

    # Constant
    elif (Ne_scenario != "s1"):
         sys.exit("sim_name not recognized. Check --sim_name option. Options are s1, s2, s3.")

    demo_asy.sort_events()
    #print(demo_asy.debug())

    return demo_asy

def build_demography(topology, infer, theta, Ne_scenario, Ne_size): 

    # MSC parameters
    #theta  = 0.01
    mu_g = pow(10, -8)
    #mu_y = pow(10, -9)
    N = theta / (4 * mu_g) 

    if (topology == "B"):
        if (infer == "topology"): 
            # Balanced topology inference parameters
            # The time's Ziheng's papers use are 4.7 * theta
            # To convert to generation, we divide by the per 
            # GENERATION mutation rate, not per year
            T_AB    = 4.7 * theta / mu_g 
            T_ABC   = 4.8 * theta / mu_g 
            T_DE    = 4.8 * theta / mu_g 
            T_ABCDE = 5.0 * theta / mu_g 
            T_root  = 7.5 * theta / mu_g 

        elif (infer == "time"): 
            # Balanced divergence time inference parameters
            T_AB    = 3.0 * theta / mu_g 
            T_ABC   = 4.0 * theta / mu_g 
            T_DE    = 4.5 * theta / mu_g 
            T_ABCDE = 5.0 * theta / mu_g 
            T_root  = 7.5 * theta / mu_g 

        else: 
            sys.exit("Infer not recognized. Check --infer option")

        demo = build_bal_topol_sim(N, T_AB, T_ABC, T_DE, T_ABCDE, T_root, Ne_scenario, Ne_size)

    elif (topology == "U"):
        if (infer == "topology"): 
            # Unbalanced (asymmetric) topology inference parameters
            T_AB    = 4.4 * theta / mu_g 
            T_ABC   = 4.6 * theta / mu_g 
            T_ABCD  = 4.8 * theta / mu_g 
            T_ABCDE = 5.0 * theta / mu_g 
            T_root  = 7.5 * theta / mu_g 

        elif (infer == "time"): 
            # Unbalanced (asymmetric) divergence time inference parameters
            T_AB    = 2.5 * theta / mu_g 
            T_ABC   = 3.0 * theta / mu_g 
            T_ABCD  = 4.0 * theta / mu_g 
            T_ABCDE = 5.0 * theta / mu_g 
            T_root  = 7.5 * theta / mu_g 

        else: 
            sys.exit("Infer not recognized. Check --infer option")

        demo = build_asy_topol_sim(N, T_AB, T_ABC, T_ABCD, T_ABCDE, T_root, Ne_scenario, Ne_size)

    else:
        sys.exit("Topology not recognized. Check --topology option")

    return demo


def write_newick(replicates, out_dir):
    for replicate_index, ts in enumerate(replicates):
        name = out_dir + "/l" + str(replicate_index + 1) + ".tre"
        f = open(name, "w")
        for tree in ts.trees() : 
           f.write(tree.as_newick())
        f.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--sim_name", type=str,   help="Name of the simulation")
    parser.add_argument("--topology", type=str,   help="B (balanced) or U (unbalanced) topology")
    parser.add_argument("--infer",    type=str,   help="topology or time")
    parser.add_argument("--loci",     type=int,   help="Number of loci")
    parser.add_argument("--samples",  type=int,   help="Number of number of samples")
    parser.add_argument("--theta",    type=float, help="theta")
    parser.add_argument("--Ne_size",  type=str,   help="i (increase) or d (decrease) Ne")
    parser.add_argument("--out_dir",  type=str,   help="Output directory")
    parser.add_argument("--seed",     type=int,   help="seed")

    args = parser.parse_args()

    sim_name  = args.sim_name
    topology  = args.topology
    infer     = args.infer
    n_samples = args.samples
    theta     = args.theta
    loci      = args.loci
    Ne_size   = args.Ne_size
    out_dir   = args.out_dir
    seed      = args.seed

    samples = [
        msprime.SampleSet(        1, population="O", time=0, ploidy=1),
        msprime.SampleSet(n_samples, population="A", time=0, ploidy=1),
        msprime.SampleSet(n_samples, population="B", time=0, ploidy=1),
        msprime.SampleSet(n_samples, population="C", time=0, ploidy=1),
        msprime.SampleSet(n_samples, population="D", time=0, ploidy=1),
        msprime.SampleSet(n_samples, population="E", time=0, ploidy=1),
    ]
    
    demo = build_demography(topology, infer, theta, sim_name, Ne_size) 
    
    replicates = msprime.sim_ancestry(
            samples=samples,
            demography=demo,
            sequence_length=1,
            recombination_rate=0,
            random_seed=seed,
            num_replicates=loci
         )

    write_newick(replicates, out_dir)
