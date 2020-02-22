# Labelling sEEG contacts

For labelling your contacts, you'll need to use the function `seegpy.pipeline.pipeline_labelling_ss`. Here's an example of how to use it :

```python
from seegpy.io import read_3dslicer_fiducial

"""
First, define the path to :
* Freesurfer root folder where all the subjects are stored
* If you performed your segmentation with MarsAtlas, you can also provide
  the root path to the BrainVisa folder
* The name of your subject
"""
fs_root = '/home/etienne/db_freesurfer/seeg_causal'
bv_root = '/home/etienne/db_brainvisa/seeg_causal'
suj = 'subject_01'
# define the path that contains electrode coordinates
xyz_path = '/home/etienne/db_anatomy/seeg_causal/recon.fcsv'
# define where to save the contact's labels
save_to = '/home/etienne/db_anatomy/seeg_causal/'

# read the coordinates and the contact names
df = read_3dslicer_fiducial(xyz_path)
c_xyz = np.array(df[['x', 'y', 'z']])
c_names = np.array(df['label'])

"""
Run the pipeline for labelling contacts :
* Here, we're going to search for voxels / vertices that are contained in a
  sphere of 5mm centered around each sEEG sites (`radius=5.`)
* Use `bipolar=True` to localize bipolar derivations
* Use `bad_label='none'` for each contact that can't be labelled
"""
pipeline_labelling_ss(save_to, fs_root, bv_root, suj, c_xyz, c_names,
                      bipolar=True, radius=5., bad_label='none', verbose=False)
```
At the end, you should get an Excel file that contains all of the labels of each monopolar and bipolar contacts using both volume and surface from Freesurfer and MarsAtlas outputs. The file is going to be saved to `/home/etienne/db_anatomy/seeg_causal/subject_01.xlsx`
