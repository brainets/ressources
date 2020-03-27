# Volume

## Color and labelize a mesh according to MarsAtlas

### Add the MarsAtlas color table

1. Download the [MarsAtlas.ctbl](https://github.com/brainets/ressources/tree/master/slicer/data/MarsAtlas.ctbl) file.
2. Copy the file inside the `slicer` directory : `slicer/share/Slicer-4.10/ColorFiles/MarsAtlas.ctbl`
3. Close and reopen slicer. If you go to the `Colors` module you should find the `MarsAtlas` color

### Labelize the volume with MarsAtlas

![malabel](_images/malabel.png)

1. Import your volume
2. Select the `Editor` module
3. Select the `MarsAtlas` colormap
4. Switch to the `Volume` module
5. In the `Volume Information` section, in the `Convert to label map` dropdown list, select the label defined above
6. Click on `Convert`

Colors should now be updated.

**TRICK :** if you see weird edges, go to `Volume > Display` and uncheck the box `Interpolate`

## Extract mesh from volume

![segmentation](_images/segmentation.png)

1. Import the volume
2. Go to `Segment Editor`
3. You can create a new segmentation : `Segmentation > Create new segmentation as...`
4. Select the volume to use for the segmentation `Master volume`
5. Click on `+ Add`
6. Rename it according to the ROI number (e.g OFCvm=38). You can also change the color
7. Select the `Threshold` in the `Effect` section below
8. Set manually the boundaries. For example, if you want to extract the ROI 38 you can set the min to `38.1` and the max to `38.9`. The only important thing is that min and max are starting with `38.`
9. Click on `Apply`
10. If the mesh is not showing click on `Show 3D`. You can also set the smoothing factor

You can then add multiple ROI mesh using the `+ Add` button. Once you added all of the ROI, you can click on `-> Segmentations`. By clickong on it, you switch to the `Segmentation` module. From it, you have a fine control over the generated mesh (transparency, hide / display etc.)