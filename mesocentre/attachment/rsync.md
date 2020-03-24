# Transfer data from/to the mesocentre via rsync

Rsync is a tool that allows you to synchronize your data between a source and a destination folder.

To transfer data between mesocentre and frioul it's better to connect to the mesocentre and use rsync from there, 
while if you want to transfer files between mesocentre and your PC it's better to launch rsync commands from
your local bash.

## Basic usage example

A classic use of rsync is in the form of:

    rsync -av /path/source/ /path/destination/
    
We will see the synopsis of the options in the next chapter.
    
If you're using a remote computer/cluster you should add its address.
For example, our friend Olof Babbé have to enxchange some file from frioul to mesocentre.
After connecting to the mesocentre, he will **start an interactive session** and then:
* if he wants to send files from mesocentre to frioul:

        rsync -av /home/obabbe/data/ babbe.o@frioul.int.univ-amu.fr:/hpc/equipe/babbe.o/data
        
* while if he wants to send files from frioul to mesocentre:

        rsync -av babbe.o@frioul.int.univ-amu.fr:/hpc/equipe/babbe.o/data/ /home/obabbe/data
        
> N.B.: pay attention to the slashes at the end of the source/destination directory. 
> To write '../data/' means 'what is in the folder data', while writing '../data' means 'the folder data itself'.
> Thus in the previous command line we are saying to synchronize the content of '../data' from the source, 
with the content of '../data' in the destination. 
Indeed, to understand this mechanism, the last command line can be written also as:   
>    ```rsync -av babbe.o@frioul.int.univ-amu.fr:/hpc/equipe/babbe.o/data /home/obabbe/```

## Useful options

### Basic synopsis

Now we will see some usefull option for rsync and their usage.

* -a: archive mode, for the sake of brevity this is a 'powerful' recursive option, that allows to recursively 
transfer files/directories and to keep track of their changes (e.g. updated files). 
High recommended instead of the recursive option.
* -r: recursive, used to synchronize source/destination folder and their subfolders and files.
* -v: verbose, it will print what is going on during the synchronization
* -m: prune empty folders, to avoid the synchronization of empty folders. 
Very useful in case of exclusions (next section).
* -n: dry run, you're not sure about the result of your rsync command? Try it with a dry run first! 
Executing a rsync -avn command will show you which file will be synchronized and where, 
without actually transferring anything.

### Include/exclude options