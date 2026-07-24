seed = 1
seqfile  = ../seq_noOutgroup.txt
Imapfile = ../1_imap.txt
jobname = out

speciestree = 1  *0.4 0.2 0.1   * speciestree pSlider ExpandRatio ShrinkRatio

speciesmodelprior = 1  * 0: uniform LH; 1:uniform rooted trees; 2: uniformSLH; 3: uniformSRooted

# fixed number of species/populations 
speciesdelimitation = 0


species&tree = 5  A  B  C  D  E
                  1  1  1  1  1
                 ((((A, B), C), D), E);

# unphased data for all 4 populations
phase =   0 0 0 0 0

# use sequence likelihood
usedata = 1

nloci = 40 

# do not remove sites with ambiguity data
cleandata = 0

thetaprior = gamma 2 200 # gamma(a, b) for theta (estimate theta)
tauprior = gamma 5 100 # gamma(a, b) for root tau & Dirichlet(a) for other tau's

# auto-tune step lengths during burnin (key:val pairs may be appended)
finetune = 1

# MCMC samples, locusrate, heredityscalars, Genetrees
print = 1 0 0 0   * 
burnin = 20000
sampfreq = 4
nsample = 50000
checkpoint = 10000
