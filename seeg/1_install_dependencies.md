# Install and configure dependencies

## Software and toolboxes

* Download [3D slicer](https://download.slicer.org/), a visualization software (no installation required)
* Clone the [SEEGA](https://github.com/EtienneCmb/SEEGA) repository. SEEGA is a module for localizing sEEG contacts that is then going to be imported inside 3D slicer. Checkout the [installation instructions](https://github.com/mnarizzano/SEEGA/wiki) and the [publication](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-017-1545-8)
* Clone and install [seegpy](https://github.com/brainets/seegpy/tree/master/seegpy). This python toolobox contains utility functions for loading sEEG related files, labelling contacts according to Freesurfer segmentation etc.

Once everything is installed, start [localizing sEEG contacts](https://github.com/brainets/ressources/blob/master/seeg/2_localize_contacts.md)

## Additional files

### MarsAtlas colorbar for 3D Slicer

If you want to use the MarsAtlas colorbar inside 3D Slicer, copy [this file](https://github.com/brainets/seegpy/blob/master/seegpy/data/MarsAtlas.ctbl) and paste it in the slicer folder inside the directory : `slicer/share/Slicer-4.10/ColorFiles/MarsAtlas.ctbl`. You can check that it works by launching `Slicer` and then open the `Colors` module and search for the `MarsAtlas` colormap