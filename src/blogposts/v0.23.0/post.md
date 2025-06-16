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

show example with new entries

[#4924](https://github.com/MakieOrg/Makie.jl/pull/4924)

### Hide/show interaction for Legend

show animation

[#2276](https://github.com/MakieOrg/Makie.jl/pull/2276)

### PolarAxis Ticks

show new feature

[#4902](https://github.com/MakieOrg/Makie.jl/pull/4902)

### Anisotropic marker rendering in GLMakie & WGLMakie

show old vs new

[#4918](https://github.com/MakieOrg/Makie.jl/pull/4918)

## Makie 0.22.3


### Textlabel

We added a new `textlabel` recipe which plots text with a background.

```julia
using CairoMakie

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