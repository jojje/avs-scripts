# avs-scripts

Some of my avisynth scripts created for addressing various video processing hurdles

## BlendDupes

Whenever a duplicate frame is encountered, replaces the frame with a blend of the previous and next frame. Duplicate is defined as the luma pixel difference, compared to the previous frame, being below a user defined threshold.

![BlendDupes illustration][blenddupessample]

The image above illustrates this behavior. Frames that have low difference (zero in the example) are judged as being dupes, and are being replaced by blended frames. Frames above the threshold are left untouched.

Upper left is the previous frame, upper right the current, lower left the next frame and lower right the output of the function.

[blenddupessample]: images/blend_dupes_sample.gif
