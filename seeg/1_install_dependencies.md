# Install and configure dependencies

* Download [3D slicer](https://download.slicer.org/), a visualization software (no installation required)
* Clone the [SEEGA](https://github.com/EtienneCmb/SEEGA) repository. SEEGA is a module for localizing sEEG contacts that is then going to be imported inside 3D slicer. Checkout the [installation instructions](https://github.com/mnarizzano/SEEGA/wiki) and the [publication](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-017-1545-8)
* Clone and install [seegpy](https://github.com/brainets/seegpy/tree/master/seegpy). This python toolobox contains utility functions for loading sEEG related files, labelling contacts according to Freesurfer segmentation etc.

Once everything is installed, start [localizing sEEG contacts](https://github.com/brainets/ressources/blob/master/seeg/2_localize_contacts.md)