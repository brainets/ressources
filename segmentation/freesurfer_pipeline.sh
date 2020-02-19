#!/bin/bash
# To RUN the shell script type ./freesurfer_pipeline.sh subject_01
# Input 1 = subject directory

# -----------------------------------------------------------------------------
# Subject and task settings
SUBJECT=$1
TASK="seeg_causal"
TEAM_DIR=/hpc/bagamore/brainets/data

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Subject : $SUBJECT"
echo "Task : $TASK"
echo "Team directory : $TEAM_DIR"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

# -----------------------------------------------------------------------------
# Init
freesurfer_setup
export SUBJECTS_DIR=$TEAM_DIR/db_freesurfer/$TASK

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Select MRI in Brainvisa (check the correct fname) and create subject_id"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
recon-all -i $TEAM_DIR/db_brainvisa/$TASK/$SUBJECT/t1mri/default_acquisition/$SUBJECT.nii.gz -s $SUBJECT -openmp 16

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Run step 1"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
recon-all -autorecon1 -wsless -s $SUBJECT

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Clean dura from brain"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
recon-all -skullstrip -clean-bm -gcut -subjid $SUBJECT

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Continue Steps 2 and 3"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
recon-all -autorecon2 -autorecon3 -subjid $SUBJECT

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Watershed algorithm to make BEM surface"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
mri_watershed -useSRAS -atlas -less -surf $SUBJECTS_DIR/$SUBJECT/bem/ $SUBJECTS_DIR/$SUBJECT/mri/T1.mgz $SUBJECTS_DIR/$SUBJECT/bem/output_vols.mgz

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Copy results"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
mv $SUBJECTS_DIR/$SUBJECT/bem/_inner_skull_surface $SUBJECTS_DIR/$SUBJECT/bem/inner_skull.surf
mv $SUBJECTS_DIR/$SUBJECT/bem/_outer_skull_surface $SUBJECTS_DIR/$SUBJECT/bem/outer_skull.surf
mv $SUBJECTS_DIR/$SUBJECT/bem/_outer_skin_surface $SUBJECTS_DIR/$SUBJECT/bem/outer_skin.surf
exit 0
