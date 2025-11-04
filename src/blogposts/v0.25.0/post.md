# Makie 0.25

## Dim Converts

Dim converts are Makie's system for handling dates, units, categorical data and other data that needs to synchronize across plots.
Up until 0.25, this would only work with `x, y` and `x, y, z` data, meaning data where each plot argument represents one dimension and either 2 or 3 were present.
The system has now been expanded to also allow point-like data, different argument orders (e.g. `y, x`), arguments that are not dimensional (e.g. the matrix passed to image) as well as repeated multiple arguments using the same dimension.
As a result almost every plot now works with dim converts.

```julia
using CairoMakie
using Makie.Unitful

cow = rotr90(Makie.loadasset("cow.png"))
f,a,p = image(0u"s" .. 10u"s", 0u"m" .. 10u"m", cow)
scatter!(
    a, [(3.4u"s", 6u"m"), (6.5u"s", 5.9u"m")],
    color = :black, markersize = 20, strokewidth = 10, strokecolor = :white, marker = Circle
)
barplot!(
    a, (1:9) .* u"m", 3 .* cos.(-0.5:0.3:1.9).^2 .* u"s", direction = :x,
    color = 1:9, strokewidth = 2
)
hlines!(
    a, (1:9) .* u"m", xmin = 1 .- 0.3 .* cos.(-0.5:0.3:1.9).^2,
    color = 1:9, linewidth = 10
)
f
```

We also added some more dim converts related attributes to `Axis` and `Axis3`.
You can use `x_unit_in_ticklabel` (etc.) to toggle units (or Dates, Categorical values) appearing in ticklabels, `x_unit_in_label` (etc.) to toggle them in axis labels, `xlabel_suffix` (etc.) to set a formatter for units in axis labels and use `use_short_x_units` to toggle between abbreviations ("s") and full names ("Second") in labels.

To make dim converts compatible with all the different argument structures recipes may have we added two new interface functions: `Makie.argument_dims()` and `Makie.argument_dim_kwargs()`.
The first allows you to map arguments to the dimensions they should convert with.
The second allows you to mark attributes to be passed to `argument_dims()` as keyword arguments, so they can be included in that decision.

```julia
# If MyPlot is called with two arguments, they are dimension 1 and 2
Makie.argument_dims(::MyPlot, x, y) = (1, 2)

# A vector of points has an inner set of dimensions
Makie.argument_dims(::MyPlot, ps::Vector{<:Point{N}}) where {N} = (1:N,)

# If the first argument is a function it should not be dim converted
Makie.argument_dims(::MyPlot, f::Function, x) = (0, 1)

# The last argument acts in the x or y dimension depending on "direction"
Makie.argument_dim_kwargs(::MyPlot) = (:direction,)
function Makie.argument_dims(::MyPlot, x, y, w; direction)
    return (1, 2, ifelse(direction == :x, 1, 2))
end
```

Note that the default `argument_dims` can already handle point-like data and x, y(, z) data.
If included via `argument_dim_kwargs` it will also handle `direction` and `orientation`.

## DataInspector [#5241](https://github.com/MakieOrg/Makie.jl/pull/5241)

Makie 0.25 includes a full rework of `DataInspector`.

### Usage

From an end-user perspective the changes include:
- `inspector_label` now consistently works when set in recipe plots
- `inspector_label` can now be a plain `String` or `Vector{String}` do define a label per plot or per plot element (e.g. marker)
- the callback version of `inspector_label` is now called with `(::Makie.PlotElement, ::Point)`
- `DataInspector` is now per scene rather than global, meaning that `DataInspector(axis)` ignores all plots outside the axis
- persistent tooltips have been added
- `inspector_hover` and `inspector_clear` have been removed

### Extension

The extension interface of DataInspector has changed more drastically.
Previously if you wanted a specialized tooltip for a recipe you needed to implement a `show_data()` method.
Given the picked primitive plot, it should figure out the position of the tooltip, the displayed label, update the tooltip and optionally manage indicator plots.
After the rework this functionality has been broken up into multiple components/methods.
This means that if you just want to change the default label you no longer have to implement everything else as well.

#### Accessors

The first function of the new interface is `Makie.get_accessor(plot, idx, plot_stack)` which should produce an `Makie.AbstractElementAccessor`.
These accessors abstract the element of the plot that has been picked, i.e. the element the cursor is hovering.
This can be, for example, an `Makie.IndexedAccessor{1}` referring to the n-th marker of a scatter plot, or an `Makie.InterpolatedAccessor{2}` referring to an interpolated point on a surface plot.
When a recipe has a different data format from its child plots, i.e. a different number of data points (e.g. errorbars), a different dimensionality (e.g. spy) or different interpolation behavior (e.g. barplot), it should add a method here.

The arguments of the `get_accessor` function are the `plot` for which the accessor should be produced, the `idx` of the underlying `pick` call and the `plot_stack` containing a trace down to the plot returned by `pick`.
When you need to extend this method, you can usually transform the results of the child plot types.

```julia
function Makie.get_accessor(plot::MyPlot, idx, plot_stack::Tuple{<:ChildPlotType, Vararg{Plot}})
    accessor = Makie.get_accessor(first(plot_stack), idx, Base.tail(plot_stack))
    # grab the indices (and interpolation information) and adjust them to fit
    # your plot type
    return Makie.IndexedAccessor(my_idx, my_size)
end
```

#### Tooltip Positions

The second function you can extend is `get_tooltip_position(element::PlotElement{<:PlotType})`.
It is responsible for extracting the position of the tooltip from a plot.
To do this it gets a `PlotElement` which bundles the accessor with the (top level) plot.
When accessing plot attributes or arguments from a PlotElement, the index/interpolation it includes is automatically applied.

This method typically needs to implemented when a specialized `get_accessor` is implemented, or if the tooltip should moved from its default position.
Since the `PlotElement` automates picking the correct (interpolated) element, this method usually just grabs a few values and combines them.
For example:

```julia
function Makie.get_tooltip_position(element::PlotElement{<:MyPlot})
    x = element.xs
    y = element.ys
    flip = element.direction === :x
    return ifelse(flip, Point(y, x), Point(x, y))
end
```

Note that these methods should not be defined recursively.
Doing so may cause the tooltip to use the wrong transformations.

#### Tooltip Labels

The (default) tooltip labels are similarly generated from a `PlotElement` using `get_default_tooltip_label(element, pos)`, where `pos` is the tooltip position from above.
This method can return either data to be transformed into a string, or a string itself.

```julia
Makie.get_default_tooltip_label(element::PlotElement{<:MyPlot}, pos) = element.ys
```

You can also overwrite `get_default_tooltip_label(formatter, element, pos)` if you want to avoid or directly use the string formatter.

```julia
function Makie.get_default_tooltip_label(formatter, element::PlotElement{<:MyPlot}, pos)
    return "Count " * Makie.apply_tooltip_format(formatter, element.ys)
end
```

These functions will be skipped if `inspector_label` is set for the plot.

#### Indicators

To add indicators to a DataInspector tooltip `update_indicator!(inspector::DataInspector, element::PlotElement, position)` should be implemented.
An indicator is one or multiple plots that typically highlight the selected element in some way.
For example, an indicator could draw a line around the element.
The method should calculate whatever is needed for the indicator, e.g. the path of the outline, and update the respective indicator plot accordingly.

```julia
function Makie.update_indicator!(inspector::DataInspector, element::PlotElement{<:MyPlot}, pos)
    # calculate data
    x = element.xs
    y = element.ys
    path = Point3f[(x-5, y-5, 0), (x+5, y-5, 0), (x+5, y+5, 0), (x-5, y+5, 0), (x-5, y-5, 0)]

    # update indicator plot
    indicator = Makie.get_indicator_plot(inspector, Lines)
    Makie.update!(indicator, arg1 = path, visible = true)

    return indicator
end
```

`get_indicator_plot()` returns a plot of a given type that is cached in the `DataInspector` object.
This is to prevent constant deletion and recreation of plots.
For this to work the plot type needs to have a `construct_indicator_plot()` method:

```julia
function construct_indicator_plot(inspector::DataInspector, ::Type{<:Lines})
    a = inspector.indicator_attributes
    return lines!(
        inspector.parent, Point3d[], color = a.color,
        linewidth = a.linewidth, linestyle = a.linestyle,
        visible = false, inspectable = false, depth_shift = -1.0f-6
    )
end
```

Note that `Lines`, `LineSegments` and `Scatter` already have definitions.
This system may change some more in the future if more flexibility is needed.

## Render Pipeline (GLMakie)

[#4689](https://github.com/MakieOrg/Makie.jl/pull/4689)

The render pipeline is a largely internal change for GLMakie.
It abstracts the steps taken to render a figure/scene, controlling the order plots are rendered in and what post processing is done.
As a user you can set the render pipeline by passing it via the `render_pipeline` keyword in `display()` or `GLMakie.Screen()`.
Though unless you want to experiment with it yourself, you have no reason to do so yet.
The `GLMakie.Screen` settings that used to control the hard-coded render pipeline, i.e. `ssao`, `fxaa` and `oit`, can still be passed the same way they used to.

So what's the point of this?
When we added screen-space ambient occlusion (SSAO) about 5 years ago, some users could no longer use GLMakie due to the increased vram demand it came with.
This was hastily fixed by essentially adding `if should_use_ssao; run_ssao()` to the render pipeline as well as the post processor initialization.
The same kind of branches also existed for order independent transparency (OIT) and FXAA.
With that the pipeline had a fixed order, which may be suboptimal for some configurations.
It also had 2^N (N steps) configurations with no indication of which made sense and which didn't.
Furthermore each step should reuse buffers (vram) when possible, which meant that initialization would be looking for hard-coded buffer names created by another step.
In short, the system was very inflexible.

The new system fixes these issues.
Instead of enabling/disabling parts of the pipeline, the whole pipeline can now be replaced, and buffer reuse is done automatically.
With that we can now write different pipelines for different purposes, rather than having a generalist pipeline that's usable for everything by everyone.
We can now add more post-processors without worrying about reusing buffers from other post-processors or worrying about how they would fit into the generalist pipeline.
We can also create pipelines where established steps like rendering work differently, such as a pipeline that relies on higher quality MSAA instead of FXAA.

## Non-Breaking Changes

### Axis Hints

[#5375](https://github.com/MakieOrg/Makie.jl/pull/5375)

We added a new interface function which provides default attributes to an axis, based on a plot.
It is used when the plot automatically generates an axis, i.e. with non-mutating calls like `scatter(...)`.

```julia
using CairoMakie

function Makie.preferred_axis_attributes(plot::Stem, ::Type{<:Axis})
    title = map(ps -> "Scatter Plot ($(length(ps)) points)", plot[1])
    return (
        title = title,
        xlabel = "x values", ylabel = "y values",
        xgridstyle = :dot, ygridstyle = :dot,
        xgridcolor = (:blue, 0.4), ygridcolor = (:red, 0.4)
    )
end

# Attributes explicitly set with `axis = ...` take precedence
f, a, p = stem(range(0, 2pi, 100), sin, axis = (ylabel = "sin", ))
```

As exemplified, default attributes can be dynamic, reacting to arguments or attributes of the plot.
Note however that the plot is not fully initialized when `preferred_axis_attributes()` is called.
Specifically the plot is not yet connected to a scene and has not called `plot!(plot)` yet.

The default axis type is chosen by `args_preferred_axis` (or `preferred_axis_type`).
This isn't new, but the method tree has been extended to include:
- `args_preferred_axis(::Plot)`
- `args_preferred_axis(::Plot, args...)`
- `args_preferred_axis(args...)`

### Recipe Projection

### Date Tick Improvements