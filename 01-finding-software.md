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
> $ module load blastplus
> $ which blastn
> ~~~
> ~~~ {.output}
> /cip0/software/x86_64/ncbi-blast-2.2.31+/bin/blastn
> ~~~
