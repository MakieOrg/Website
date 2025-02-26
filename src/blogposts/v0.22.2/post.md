# Makie v0.22.2

Makie 0.22.2 is finally here and introduces many fixes and improvements.

## [Cleanup Patterns/Hatching](https://github.com/MakieOrg/Makie.jl/pull/4715)

Enhanced Patterns and Hatching features by improving line quality, adding unit and reference image tests, handling patterns in CairoMakie, fixing related issues in other backends, and [updating documentation](https://docs.makie.org/dev/explanations/colors#Textures,-Patterns-and-MatCaps). This also introduced pattern anchoring to model space.

![](./images/pattern.png)

## [Nudge Axis3 clip planes to avoid clipping at 0 margin](https://github.com/MakieOrg/Makie.jl/pull/4742)

Adjusted Axis3 clip planes to prevent unintended clipping when the margin is set to zero. Updated reference images to illustrate the change.

| v0.22 | v0.22.2 |
| --- | --- |
| ![0.22.2](./images/img1.png) | ![0.22.2](./images/img2.png) |


## [Added a tutorial on creating an inset plot](https://github.com/MakieOrg/Makie.jl/pull/4697)

Introduced a [tutorial](https://docs.makie.org/dev/tutorials/inset-plot-tutorial#Creating-an-Inset-Plot) explaining how to create inset plots. Mention the [zoom_lines](https://juliaaplavin.github.io/MakieExtraDocs.jl/notebooks/examples.html#3526c688-aea9-411b-a837-dc02ff81a7ee) function from [MakieExtras.jl](https://github.com/JuliaAPlavin/MakieExtra.jl) for connecting inset plots.

![](./images/inset.png)

## [Add documentation on mesh normal generation](https://github.com/MakieOrg/Makie.jl/pull/4787)

[Documented](https://docs.makie.org/dev/reference/plots/mesh#Simple-mesh-plots) how vertex order affects normal generation in mesh plots, providing clarity on how different vertex arrangements can impact plot appearance.

![](./images/face-normals.png)

## [Cleanup volume](https://github.com/MakieOrg/Makie.jl/pull/4726)

Addressed discrepancies in volume plot algorithms between different platforms and added more detailed documentation and tests for volume rendering.
![](./images/volume1.png)
![](./images/volume2.png)

## [Improve nan handling in surface plots](https://github.com/MakieOrg/Makie.jl/pull/4735)

Improved handling of NaN values in surface plots, ensuring consistency across different backends and updated reference images to reflect these changes.

| v0.22 | v0.22.2 |
| --- | --- |
| ![v0.22](./images/nan-surf-before.png) | ![v0.22.2](./images/nan-surf-after.png) |

## [DPI metadata for png](https://github.com/MakieOrg/Makie.jl/pull/4812)

Added DPI metadata to PNG files, allowing external applications to interpret and display images at the correct size specified by their px_per_unit setting.

![Image with DPI metadata](./images/img3.png)

## Voxel improvements

* Replace voxel uvmap interface with uv_transform interface [#4758](https://github.com/MakieOrg/Makie.jl/pull/4758)
* Fix voxels on linux firefox [#4756](https://github.com/MakieOrg/Makie.jl/pull/4756).
* Fix voxel rotation [#4824](https://github.com/MakieOrg/Makie.jl/pull/4824)

| v0.22 | v0.22.2 |
| --- | --- |
| ![0.22.2](./images/img5.png) | ![0.22.2](./images/voxel-0.22.2.png) |

## [Curvilinear `contourf`](https://github.com/MakieOrg/Makie.jl/pull/4744)

Enabled curvilinear `contourf` plots by allowing contour calculations to be dispatched on and transforming Isoband output using bilinear interpolation.

![](./images/filled contour 2d with curvilinear grid.png)

## [Fix broken `voronoiplot` for clipped tessellations](https://github.com/MakieOrg/Makie.jl/pull/4740)

Resolved an issue with `voronoiplot` to work correctly with clipped tessellations and automatic color generation which was previously causing errors.

## [Add option to turn off clipping](https://github.com/MakieOrg/Makie.jl/pull/4791)

Introduced a feature that allows users to disable clipping in plots by setting `ax.clip[] = false`, providing more control over plotting output.
## [Resolve :data space when deciding whether to connect transformations](https://github.com/MakieOrg/Makie.jl/pull/4723)

Improved transformation handling by tracing `:data` space back to the scene, ensuring correct transformation connections.

## [Improvements for Slider updates](https://github.com/MakieOrg/Makie.jl/pull/4748)

Added options to slider updates, including `update_while_dragging` and `throttle`, and introduced `lowres_background` to the `Resampler` to optimize performance when updating `heatmap(Resampler(data))` often.

## Internal fixes for (W)GLMakie


* Fix rare shader compilation error[#4755](https://github.com/MakieOrg/Makie.jl/pull/4755)
* [Upgrade to threejs 0.173, fixing a rare problem with NaNs in buffers](https://github.com/MakieOrg/Makie.jl/pull/4809)
* Fix WGLMakie nan error in cut plane, which broke Axis3 [#4772](https://github.com/MakieOrg/Makie.jl/pull/4772)
* fix UInt underflow in line indices [#4782](https://github.com/MakieOrg/Makie.jl/pull/4782)

## [Allow higher dimensional geometries in poly](https://github.com/MakieOrg/Makie.jl/pull/4738)

Restored support for rendering higher-dimensional geometries with the `poly()` function, enabling 3D shape visualization as a mesh with outlines.


## [allow setting inspectable in the theme](https://github.com/MakieOrg/Makie.jl/pull/4739)

Enabled setting the `inspectable` attribute within themes, allowing for theme-wide customization of inspectability options across plots.


## [Allow `Block.attri...` to autocomplete](https://github.com/MakieOrg/Makie.jl/pull/4786)

Improved developer experience by enabling autocomplete for Block attributes, facilitating easier exploration and usage of block properties.



## [Consider visible in PolarAxis protrusions](https://github.com/MakieOrg/Makie.jl/pull/4823)

Fixed the issue where PolarAxis protrusions did not consider visibility states, ensuring accurate rendering of visible elements only.

## [Widget optimizations](https://github.com/MakieOrg/Makie.jl/pull/4821)

Optimized widget updates by reducing redundant updates, particularly removing `pick()` usage where possible.
This solves a rare issue, where `Textfield` would stop working on a server with higher latency.

## [Fix WGLMakie tick and window_open events](https://github.com/MakieOrg/Makie.jl/pull/4818)

Fixed issues related to tick and window_open events in WGLMakie, ensuring accurate event handling and fixing the toggle button for WGLMakie.
