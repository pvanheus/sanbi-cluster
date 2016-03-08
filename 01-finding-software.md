---
layout: page
title: Finding software on the SANBI cluster
---
### A shared software collection

The software that your scripts run on the SANBI cluster needs to be available on each
*compute node* (*grid01*, *grid02*, etc). For standard Linux programs like `wc`,
`grep` and `awk` this is not a problem, they are present wherever Linux is installed.

For scientific software, however, making it available everyone *is* a problem. The
package managers that allow admins to install `wc` and `grep` typically don't provide
up to date scientific software. The software we use for bioinformatics is thus installed
in directories under `/cip0/software`. These directories are not in the PATH, which means
that they will not be found when your script needs to run them.

To solve this problem we have *[Environment Modules](http://modules.sourceforge.net/)*.
This is software that configures the shell with correct settings for a given program.

When you log into the SANBI cluster head node, *queue00*, the *Environment Modules*
commands are automatically loaded for you. Let's use one:

> ~~~ {.input}
> $ module add blastplus
> $ which blastn
> ~~~
> ~~~ {.output}
> /cip0/software/x86_64/ncbi-blast-2.2.31+/bin/blastn
> ~~~

You can see which packages you have settings loaded with:

> ~~~ {.input}
> $ module list
> ~~~
> ~~~ {.output}
> Currently Loaded Modulefiles:
>   1) blastplus/default
> ~~~

The `blastn` program is part of the *BLAST+* package from *NCBI* and is a very commonly
used tool to search for sequences by homology. As you can see from the output of the 
`which` command, it is install in `/cip0/software/x86_64/ncbi-blast-2.2.31+`. The
`module add` command changed your `PATH` environment variable by adding the path to
`blastn`. To see what is being added use the `module show` command:

> ~~~ {.input}
> $ module show blastplus
> ~~~
> ~~~ {.output}
> -------------------------------------------------------------------
> /cip0/software/modules/modulefiles/blastplus/default:
> 
> append-path  PATH /cip0/software/x86_64/ncbi-blast-2.2.31+/bin 
> setenv       BLASTPLUS_HOME /cip0/software/x86_64/ncbi-blast-2.2.31+ 
> -------------------------------------------------------------------
> ~~~

The `setenv` commands sets an environment variable. This is useful if
the package directories contain, for example, data that might be useful
for your analysis.

### Exploring the SANBI software collection

The SANBI cluster has more than 150 software packages installed. To list what is
available use `module avail`:

> ~~~ {.input}
> $ module avail 2>&1 |more
> ~~~
> ~~~ {.output}
> ----------------------- /cip0/software/modules/versions ------------------------
> 3.2.9
> 
> ----------- /cip0/software/x86_64/modules/Modules/3.2.9/modulefiles ------------
> dot         module-cvs  module-info modules     null        use.own
> 
> ---------------------- /cip0/software/modules/modulefiles ----------------------
> FastQC/0.10.1
> FastQC/0.11.2
> FastQC/0.11.4
> FastQC/default
> R/R-3.0.1
> R/R-3.1.1
> ...
> ~~~

This output lists many packages and the versions that are available. Because the output is
written to `stderr` and more than one screen, the `2>&1` and `| more` directs the output
to the `more` pager program, It is probably more
info than you need, so you can search for packages using `module avail`:

> ~~~ {.input}
> $ module avail velvet
> ~~~
> ~~~ {.output}
> --------------------- /cip0/software/modules/modulefiles -----------------------------------
> velvet/velvet-1.2.03          velvet/velvet-1.2.10(default)
> velvet/velvet-1.2.06          velvet/velvet-1.2.10-big-long
> ~~~

This searches for all packages matching *velvet*.

### Using Environment Modules in your scripts

Since most scripts that you will run on the cluster use packages that are made available
using *Environment Modules* you need to include `module add` commands in your scripts.

As an example, let's use `blastn` to match some data against the NCBI non-redundant
nucleotides (*nr*) database. We don't know what species the sequences in our sample
originated, so we'll include some options to display the species that our query
matches in the BLAST output. The script is:

> ~~~ {.input}
> #!/bin/sh
> 
> . /etc/profile.d/module.sh
> module add blastplus
> 
> QUERY=/cip0/research/projects/cluster_demo/sample.fa
> BLAST_OPTS='6 qseqid sseqid evalue bitscore sgi sacc staxids sscinames scomnames stitle'
> BLASTDB=/cip0/db/ncbi/nt/default
> export BLASTDB
> blastn -db /cip0/db/ncbi/nt/default/nt -max_target_seqs 1 -outfmt $BLAST_OPTS \
>   -evalue "1e-30" -query $QUERY -out blast_results.txt
> ~~~

and it uses `module add blastplus` to add the path to the `blastn` program. It also includes the line:

> ~~~ {.input}
> . /etc/profile.d/module.sh
> ~~~

which is necessary to import the *Environment Modules* packages and make the `module` command work. You can download this script from [this link](http://pvanheus.github.io/sanbi-cluster/data-cluster/run_blast.sh) using `wget`:

> ~~~ {.bash}
> $ wget http://pvanheus.github.io/sanbi-cluster/data-cluster/run_blast.sh
> ~~~

or use an editor (such as `nano`) to save the script as `run_blast.sh`.

Submit it to the cluster:

> ~~~ {.input}
> qsub -wd $(pwd) run_blast.sh
> ~~~

This should run for about 12 minutes and when its done you can look in the `blast_results.txt` file
to see what species the sample data is from.

> ~~~ {.input}
> more blast_results.txt
> ~~~

### Environment Modules summarised

Command                Function
-------                --------
`module add package`   Add the settings for `package` to your environment
`module avail`         List available packages
`module avail name`    Search for packages named `name`
`module show package`  Show what `module add package` would do
`module list`          Show which packages settings are currently loaded
`module rm package`    Remove the settings for `package` from your environment