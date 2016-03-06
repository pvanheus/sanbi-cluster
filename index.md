---
layout: page
title: Learning how to use the SANBI computing environment
---
SANBI has a small but powerful cluster of computers that provide a High Powered Computing
environment for our users.

> ## Prerequisites {.prereq}
>
> This lesson guides you through the basics of submitting and monitoring
> jobs on the SANBI cluster. If you have a working knowledge of the
> Linux/Unix shell, you're ready for this lesson.
>
> If you know how to `qsub` scripts, you probably won't learn a lot
> from this lesson.

## The SANBI cluster

The design of SANBI's cluster has two intended purposes: users should be able to run jobs without caring (much) on which computer the job runs and users' jobs should not interfere with each other.

![SANBI cluster design](http://docs.wp.sanbi.ac.za/wp-content/uploads/sites/9/2014/11/cluster_design.svg)

Users log onto the *login node* named **queue00** using *ssh*. This machine is only available from inside SANBI. If you want to access it from outside SANBI you need to use our *VPN* or first ssh to **gate.sanbi.ac.za**.

The cluster is managed by a machine called **grid00**. Users never log in here, and keeping this separate from **queue00** means that even if users crash **queue00** the cluster will keep running. The actual computing happens on machines named **grid01**, **grid02** and so forth. The Sun Grid Engine (SGE) software on **grid00** starts the jobs running on these machines, users never log into them directly.

## The SANBI /cip0 filesystem

All our research data is stored in directories under `/cip0`. In general, no data should be stored in your home
directory (`/usr/people/username`). On `/cip0` each user has a `scratch` directory and a `research` directory named
`/cip0/research/username` and `/cip0/research/scratch/username`. All work should be done in subdirectories of the
`scratch` directory and final results stored in the `research` directory. Make sure that you are now in
your `scratch` directory:

> ~~~ {.input}
> $ id -un
> ~~~
> ~~~ {.output}
> username
> ~~~
> ~~~ {.input}
> $ cd /cip0/research/username
> $ pwd
> ~~~
> ~~~ {.output}
> /cip0/research/username
> ~~~


## Topics

1.  [Running a script on the SANBI cluster](00-qsub.html)
2.  [Finding software on the cluster](01-finding-software.html)
3.  [Creating Things](02-create.html)
4.  [Pipes and Filters](03-pipefilter.html)
5.  [Loops](04-loop.html)
6.  [Shell Scripts](05-script.html)
7.  [Finding Things](06-find.html)

## Other Resources

*   [Reference](reference.html)
*   [Discussion](discussion.html)
*   [Instructor's Guide](instructors.html)
