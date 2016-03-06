---
layout: page
title: Running a script on the SANBI cluster
---
## One run, one working directory

Each analysis you do on the cluster should happen in its own working directory. Use directories to keep data
organised and put a README file in each analysis directory to describe the data that is held there. Let's
create such a directory

### Shell scripts and qsub

To run a job on the cluster you need to create a shell script that specifies what you want to do. For example, this shell script counts the lines in a file called *myfile.txt*:

    #!/bin/sh
    
    wc -l myfile.txt
    

Assuming that this script is saved as *myscript.sh*, it can be run on the cluster using the following command:

    qsub -cwd -q all.q myscript.sh
    

This will submit a job to the queue *all.q*. Then *grid00* picks up the job, checks if there are free resources to run the job and, if so, runs it. The output from the job will be written to two files, **myscript.sh.eNNNN** and **myscript.sh.oNNNN**. These files capture the output written to *stderr* and *stdout* respectively.

### SANBI queue names and resources

There are two standard queues at SANBI:

*   **all.q**: The default queue. Jobs in this queue are limited to 8 hours of running time.
*   **long.q**: The queue for long running jobs. Fewer CPUs are available via long.q, to ensure that if a user has a small job to run they will find a CPU free.

There are also queues available for specific research groups: *travers.q*, *junaid.q*, *h3a.q* and so forth.

By default a job is allocated 2 GB of RAM and 1 CPU slot. The queueing system makes sure that you do not exceed your RAM allocation: if your job uses more than the RAM requested it will be terminated. The system has no way of policing CPU allocation: if you run a job using that runs in parallel and uses more than 1 CPU it will do so, even though the system *thinks* it is only using a single CPU. There is a section below on running parallel jobs.