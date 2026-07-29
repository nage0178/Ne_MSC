seed = 1

seqfile  = ../seq_noOutgroup.txt
Imapfile = ../1_imap.txt
jobname  = out

# fixed number of species/populations 
speciesdelimitation = 0

# fixed species tree
speciestree = 0

species&tree = 9  A  A1 A2 B  C  D D1 D2  E
                  8  0  0  8  8  8  0  0  8
                 ((((((((A,A1),A2), B), C), D),D1),D2), E);

# unphased data for all 4 populations
phase =   0 0 0 0 0 0 0 0 0 

# use sequence likelihood
usedata = 1

nloci = 40 

# do not remove sites with ambiguity data
cleandata = 0

thetaprior = gamma 2 800 # gamma(a, b) for theta (estimate theta)
tauprior = gamma 2.5 200 # gamma(a, b) for root tau & Dirichlet(a) for other tau's

# auto-tune step lengths during burnin (key:val pairs may be appended)
finetune = 1

# MCMC samples, locusrate, heredityscalars, Genetrees
print = 1 0 0 0   * 
burnin = 5000
sampfreq = 4
nsample = 50000
checkpoint = 10000 10000
