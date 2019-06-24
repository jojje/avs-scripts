# Blend duplicate frames
#
# A frame is classified as duplicate if its luma difference from the previous frame is less
# than a specified threshold value.
#
# thresh: Dupe threshold. A frame diff less than this value will result in the frame being replaced
#         by one produced by blending the previous and next frame.
# weight: Blend weight. How mych of the next frame will show compared to the previous frame during
#         the frame blending. A value of 0.5 produces a 50:50 (equal) blend of both frames.
# debug:  Render an overlay with the frame difference and mark blended (replaced) frames when they
#         are displayed.
function BlendDupes(last, float "thresh", float "weight", bool "debug") {
  thresh = Default(thresh, 1)
  weight = Default(weight, 0.5)
  debug  = Default(debug, false)
  # Pad beginning and end with still frames, for time shifted clips
  Trim(0, length=2) + last + Trim(FrameCount-1, length=1)

         previous = Trim(0, FrameCount-2)  # Lets you get the previous frame
  global current  = Trim(1, FrameCount-1)  # The current frame of the clip
         next     = Trim(2, 0)             # The next frame

  blended = Merge(previous, next, weight=weight)
  blended = debug ? blended.subtitle("BLENDED", x=70) : blended

  ConditionalFilter(current, blended, current, "yDifferenceFromPrevious", "lessthan", string(thresh))

  debug ? ScriptClip(""" subtitle("Diff: " + string(current.yDifferenceFromPrevious), x=180) """) : last

  # Get rid of te padded frames to restore original clip length
  Trim(1, FrameCount-2)
}

# ---------------------------------------------------
# Reproducable test clip to demo and play with the algorithm
#
# function TestClip() {
#   function ConvertToFilm(last) {
#     SelectEvery(5, 0,1,2,2,3)
#   }
#
#   BlankClip(pixel_type="YV12", length=30*4, fps=30000, fps_denominator=1001, width=320, height=240)
#   ScriptClip("""subtitle(string(current_frame), size=200)""")
#
#   # interleave two simulated inverse telecined FILM and VIDEO segments
#   sceneLength = FrameCount / 4
#   scene1 = Trim(sceneLength*0, 1*sceneLength-1).subtitle("VIDEO")
#   scene2 = Trim(sceneLength*1, 2*sceneLength-1).ConvertToFilm().subtitle("FILM")
#   scene3 = Trim(sceneLength*2, 3*sceneLength-1).subtitle("VIDEO")
#   scene4 = Trim(sceneLength*3, 4*sceneLength-1).ConvertToFilm().subtitle("FILM")
#   return scene1 + scene2 + scene3 + scene4
# }
#
# Usage
# TestClip()
# processed = BlendDupes(thresh=1, weight=0.5, debug=true)
# StackHorizontal(last.subtitle("Original", y=214), processed.subtitle("Processed", y=214))