# Makie v0.23.0

Makie 0.23.0 is a relatively small breaking release before the big 0.24.0 ComputePipeline refactor. It's only breaking change is the `arrows()` refactor.

## Arrows

show new plots, exemplifying
- fully size considered in alignment
- marker attributes + scaling
- How to fight scaling (especially 3D)
- 3D quality improvement, Cone
- argmode, maybe shrink-align

[#4925](https://github.com/MakieOrg/Makie.jl/pull/4925)

## Dendrogram

show new plot

[#2755](https://github.com/MakieOrg/Makie.jl/pull/2755)

# Backlog

## Makie 0.22.8

### Annotation

show new plot

[#4891](https://github.com/MakieOrg/Makie.jl/pull/4891)

## Makie 0.22.5

### Legend entries for mesh, meshscatter, image, heatmap and surface plots

`Legend` now has entry visualizations for mesh, meshscatter and surface in 3D and image and heatmap in 2D.

```julia
using GLMakie
GLMakie.activate!()

f = Figure(size = (400, 400))
a,p = heatmap(f[1, 1:2], sin.(1:10)' .* sin.(1:10), label = "Heatmap")
image!(10.5..20.5, 0.5..10.5, sin.(1:10)' .* sin.(1:10), label = "Image")
axislegend(a)

a,p = meshscatter(f[2, 1], [rand(Point3f) + Vec3f(0,0,1) for i in 1:10] , label = "MeshScatter" => (color = :orange,))
mesh!(Rect3f(0,0,0,1,1,1), label = "Mesh" => (color = :lightblue,))
surface!(-1..2, -1..2, sin.(1:10)' .* sin.(1:10), label = "Surface")
Legend(f[2, 2], a, tellwidth = false)
f
```

[#4924](https://github.com/MakieOrg/Makie.jl/pull/4924)

### Hide/show interaction for Legend

You can now toggle the visibility of plots by left clicking their respective `Legend` entries.
Right clicking will toggle all connected plots and middle clicking will synchronize and toggle them

TODO: animation

[#2276](https://github.com/MakieOrg/Makie.jl/pull/2276)

### PolarAxis Ticks

PolarAxis now supports `ticks` (lines between tick labels and the axis frame).
The related attributes are `r-`, `rminor-`, `theta-` and `thetaminor-`:
- `-ticksvisible`: Are ticks shown (default false)
- `-ticksize`: Controls the length of ticks
- `-tickwidth`: Controls the width of ticks
- `-tickcolor`: Controls the color of ticks
- `-ticksmirrored`: Swaps the tick location to the opposite end of the PolarAxis if hte PolarAxis doesn't span a full circle (`rmin > 0` or `thetamax - thetamin < 2pi`)
- `-tickalign`: Controls the alignment of ticks relative to the frame. (default 0, point outwards)

```julia
using CairoMakie
CairoMakie.activate!()

f = Figure(size = (800, 400))
kwargs = (
    rticksvisible = true, rticksize = 12, rtickwidth = 4, rtickcolor = :red, rtickalign = 0.5,
    thetaticksvisible = true, thetaticksize = 12, thetatickwidth = 4, thetatickcolor = :blue, thetatickalign = 0,
    rminorticksvisible = true, rminorticksize = 8, rminortickwidth = 3, rminortickcolor = :orange, rminortickalign = 1.0,
    thetaminorticksvisible = true, thetaminorticksize = 8, thetaminortickwidth = 3, thetaminortickcolor = :cyan, thetaminortickalign = 1.0,
)
a = PolarAxis(f[1,1], title = "normal", rticksmirrored = false, thetaticksmirrored = false; kwargs...)
rlims!(a, 0.5, 0.9)
thetalims!(a, 1pi/5, 2pi/5)
a = PolarAxis(f[1,2], title = "mirrored", rticksmirrored = true, thetaticksmirrored = true; kwargs...)
rlims!(a, 0.5, 0.9)
thetalims!(a, 1pi/5, 2pi/5)
f
```

[#4902](https://github.com/MakieOrg/Makie.jl/pull/4902)

### Anisotropic marker rendering in GLMakie & WGLMakie

Rendering scatter markers (or text) with anisotropic `markersize` (or fontsize), e.g. `markersize = Vec2f(10, 50)`, used to result in blurred or pixelated edges in WGLMakie and GLMakie.
This has been mostly fixed:

```julia
#no-eval
scene = Scene(size = (250, 250))
ms = [Vec2f(60, 10), Vec2f(60), Vec2f(10, 60)]
scatter!(scene, fill(-0.75, 3), [-0.75, 0.0, 0.75], marker = :rect, markersize = ms)
scatter!(scene, fill(0, 3), [-0.75, 0.0, 0.75], marker = :circle, markersize = ms)
scatter!(scene, fill(0.75, 3), [-0.75, 0.0, 0.75], marker = 'L', rotation = pi/3, markersize = ms)
scene
```

| Before | After |
| --- | --- |
| ![marker before update](./images/anisotropic_marker_pre.png) | ![marker after update](./images/anisotropic_marker_post.png) |


[#4918](https://github.com/MakieOrg/Makie.jl/pull/4918)


## Makie 0.22.3

### Textlabel

We added a new `textlabel` recipe which plots text with a background.

```julia
using CairoMakie
CairoMakie.activate!()

f,a,p = textlabel(0, 0, text = "Default Label")
textlabel!(
    a, fill(1, 3), 0:2, text = ["Label 1", "Label 2", "Label 3"],
    shape = Circle(Point2f(0), 1), shape_limits = Rect2f(-1,-1,2,2), keep_aspect = true,
    background_color = RGBf(1, 1, 0.7), text_color = :darkgreen, strokecolor = :orange,
    fontsize = 20, strokewidth = 3, padding = 10
)
textlabel!(
    a, 0, 2, text = "A long\nmultiline\nlabel",
    cornerradius = 0, text_align = (:left, :top)
)
xlims!(a, -0.5, 1.5)
ylims!(a, -0.5, 2.5)
f
```

[#4879](https://github.com/MakieOrg/Makie.jl/pull/4879)


### `space` and `transformation` changes

`space` and plot transformations used to be intertwined.
For example transform functions used to consider `space`, essentially running:

```julia
# no-eval
function apply_transform_func(func, data, space)
    if is_data_space(space)
        apply_transform_func(func, data)
    else
        return data
    end
end
```

This meant you could never have a `transform_func` apply to a plot that is not in data space.
It also suggested that `space` should control which transformations get applied, which would mean every of the current space options should split into four (with and without model and transform_func).

On the other hand we were also checking space compatibility between plots and their parents during construction, only inheriting transformations if they were compatible.
So a plot with `space = :pixel` (and a parent that isn't in pixel space) would have identity transformations unless they were explicitly passed, meaning that applying them wouldn't actually change anything.
We decided to rely on this as the source of truth.
As such:
- plots now always apply their transform_func
- transformations can be explicitly (not) inherited by setting `plot(..., transformation = :inherit/:inherit_model/:inherit_transform_func/:nothing)`

[#4792](https://github.com/MakieOrg/Makie.jl/pull/4792)


### Scatter font

You can now set the `font` used for rendering `Char` markers in scatter plots.

```julia
using CairoMakie
CairoMakie.activate!()

kwargs = (marker = ['a', '♪', '@', '→'], markersize = 30)
f,a,p = scatter(1:4, fill(0, 4); color = :black, kwargs...)
scatter!(1:4, fill(1, 4); font = Makie.defaultfont(), color = :black, kwargs...)
scatter!(1:4, fill(2, 4); font = "Noto Sans", color = :blue, kwargs...)
scatter!(1:4, fill(3, 4); font = "Fira", color = :red, kwargs...)
f
```

[#4832](https://github.com/MakieOrg/Makie.jl/pull/4832)