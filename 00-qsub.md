---
layout: page
title: Running a script on the SANBI cluster
---
### One run, one working directory

Each analysis you do on the cluster should happen in its own working directory. Use directories to keep data
organised and put a README file in each analysis directory to describe the data that is held there. Let's
create such a directory and start our work there:

> ~~~ {.input}
> $ cd /cip0/research/username
> $ mkdir cluster-demo
> $ cd cluster-demo
> pwd
> ~~~
> ~~~ {.output}
> /cip0/research/username/cluster-demo
> ~~~

### Shell scripts and qsub

To run a job on the cluster you need to create a shell script that specifies what you want to do. For example, this shell script counts the lines in a file called *myfile.txt*:

> ~~~ {.bash}
> #!/bin/sh
>
> wc -l myfile.txt
> ~~~

For it to work we need the program `wc` and the data `myfile.txt`. The `wc` program is a standard Linux command
so we can assume it exists on all nodes on the cluster. The data `myfile.txt` can be downloaded:

> ~~~ {.input}
> $ wget http://pvanheus.github.io/sanbi-cluster/data-cluster/myfile.txt
> ~~~
> ~~~ {.output}
> --2016-03-06 11:33:47--  http://pvanheus.github.io/sanbi-cluster/data-cluster/myfile.txt
> Resolving pvanheus.github.io (pvanheus.github.io)... 185.31.18.133
> Connecting to pvanheus.github.io (pvanheus.github.io)|185.31.18.133|:80... connected.
> HTTP request sent, awaiting response... 200 OK
> Length: 1039 (1,0K) [text/plain]
> Saving to: ‘myfile.txt’
>   
> 100%[=====================================================================================================>] 1 039       --.-K/s   in 0s
>
> 2016-03-06 11:33:47 (43,6 MB/s) - ‘myfile.txt’ saved [1039/1039]
> ~~~

Using `nano` create this script as `myscript.sh`. It can be run on the cluster using the following command:

> ~~~ {.input}
> $ qsub -wd $(pwd) -q all.q myscript.sh
> ~~~
> ~~~ {.output}
> Your job 7493681 ("myscript.sh") has been submitted
> ~~~

This will submit a job to the queue *all.q*. Then *grid00* picks up the job, checks if there are free resources to run the job and, if so, runs it. The output from the job will be written to two files, `myscript.sh.eNNNN` and `myscript.sh.oNNNN`. These files capture the output written to the *stderr* and *stdout* streams respectively. Let us examine the output we got from running `myscript.sh`.

> ~~~ {.input}
> ls -l
> ~~~
> ~~~ {.output}
> total 12
> -rw-r--r-- 1 pvh messagebus 1039 Mar  6 11:22 myfile.txt
> -rw-r--r-- 1 pvh messagebus   28 Mar  6 12:02 myscript.sh
> -rw-r--r-- 1 pvh messagebus    0 Mar  6 12:03 myscript.sh.e7493681
> -rw-r--r-- 1 pvh messagebus   14 Mar  6 12:03 myscript.sh.o7493681
> ~~~

From this output we can see that `myscript.sh.e7493681` has zero size output, which is what we would expect if the command ran with no errors (and thus nothing was written to *stderr*). The output of the script is in 
`myscript.sh.o7493681` which contains:

> ~~~ {.input}
> $ cat myscript.sh.o7493681
> ~~~
> ~~~ {.output}
> 27 myfile.txt
> ~~~

You might recognise this as the output from `wc -l` and it is the same output you would receive if you ran `wc -l myfile.txt` on the command line.

### SANBI queue names and resources

There are two standard queues at SANBI:

*   **all.q**: The default queue. Jobs in this queue are limited to 8 hours of running time.
*   **long.q**: The queue for long running jobs. Fewer CPUs are available via long.q, to ensure that if a user has a small job to run they will find a CPU free.

There are also queues available for specific research groups: *travers.q*, *junaid.q*, *h3a.q* and so forth.

By default a job is allocated 2 GB of RAM and 1 CPU slot. The queueing system makes sure that you do not exceed your RAM allocation: if your job uses more than the RAM requested it will be terminated. The system has no way of policing CPU allocation: if you run a job using that runs in parallel or is multi-threaded and uses more than 1 CPU it will do so, even though the system *thinks* it is only using a single CPU. Later in this lesson we will discuss running jobs that use more than 1 CPU.

### Common qsub options

The `qsub` command submits a job to the queue. It has a large number of command line options, the most commonly used of which are:

*   **-q**: Specify the name of the queue. E.g. *-q long.q*
*   **-wd**: Specify a working directory. E.g. *-wd /cip0/research/scratch/pvh*
*   **-l**: Specify additional resources. E.g. *-l h_vmem=4G* specifies that your job needs 4 GB of RAM
*   **-N**: Give your job a name. E.g. *-N myjob1*. This changes the names used for output files.

The `-wd $(pwd)` option used in our previous `qsub` command specifies that the script should run using the
current directory as the working directory (`$(pwd)` expands to the name of the current directory). For more info,
read the manual page by running `man qsub`.