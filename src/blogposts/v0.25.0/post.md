# Makie 0.25

## Complex Recipes/Block Recipes

We have extended the `@Block` macro to double as a recipe for blocks.
They can now be used to define a layout of Blocks, which can also be plotted to by the block recipe.
This could be used, for example, to define a new block which creates an Axis and a plot based on user arguments and automatically adds a Legend and/or Colorbar to its internal layout.

```julia
# no-eval
# Block recipes can be added to a figure like any other block
fig = Figure()
block = MyBlock(fig[1, 1], rand(10))

# Blocks are now also allowed to directly create figures:
fig, block = MyBlock(rand(10))
```

### Block Recipe Interface

Block recipes are similar to plot recipes.
To define one the `@block` macro is used to define a new block type, similar to how `@recipe` is used for plots.
Then an `initialize_block!()` method is implemented to add blocks and plots to the new block type, similar to how `plot!()` adds other plots to a recipe plot.

#### Small example

A bare bones version of the `MyBlock` recipe may look like this:

```julia
@Block MyBlock (positions,) begin
    @attributes begin
        "Color of scatter markers"
        color = :red
    end
end

Makie.conversion_trait(::Type{<:MyBlock}) = PointBased()

function Makie.initialize_block!(b::MyBlock)
    ax = Axis(b[1, 1])
    scatter!(ax, b.positions, color = b.color, label = "Scatter Plot")
    Legend(b[0, 1], ax, tellwidth = false, tellheight = true)
    return
end

f, b = MyBlock(rand(10), color = :orange)
```

The `@Block` macro defines the name of the new block as `MyBlock`.
It then defines the converted arguments as `positions`.
Unlike with `@recipe` this is currently required for blocks.
Finally it defines a single attribute `color` with a docstring in an `@attributes begin ... end` block.

Following that is an overload of `conversion_trait` for the new block type.
This tells the conversion pipeline how to convert the arguments given to `MyBlock`.
The result will be contained in `block.positions`, just like with `@recipe`.

The final part is the `initialize_block!(b::MyBlock)` implementation.
As you can see other blocks can be added to the parent block `b` as if it were a figure.
Plots can be added to any axis-like added to `b`.
The attributes of MyBlock can be accessed an passed around with `b.attribute_name` just like with plot recipes.

#### Working with recipe blocks

A content of a recipe block can be accessed and manipulated in the same way it does in `initialize_block!()` once it is created.
If you wanted to add another plot to the axis of `MyBlock` you could do so with `plot!(b[1, 1], ...)`.
If you wanted to add another block, you can add it with `Label(b[-1, 1], "Title")`.
If you want to get the Axis block out of `b`, you can grab it from `ax = b.blocks[1]`.
From there you can access the plots added to the axis `ax.plots`.

#### `@Block` macro

The example above does not include all the options the `@Block` macro provides.
A more feature complete example would be

```julia
# no-eval
abstract type ParentType <: Block end

@Block MyBlock <: ParentType (positions::Vector{<:Point},) begin
    field1
    field2::Int
    @attributes begin
        # undocumented
        attribute1 = 1
        "documented"
        attribute2 = 2
        "documented + typed"
        attribute3::Int = 3
    end
end
```

This adds:
- a parent type `<: ParentType` for the block
- a type annotation `::Vector{<:Point}` for the converted arguments, enabling type checks
- an untyped `field1` and typed `field2` which will be added to the `MyBlock` struct directly
- an undocumented `attribute1` and a typed `attribute3`

Adding a type annotation to an attribute causes the attribute to be passed to `BlockAttributeConvert{TargetType}()(value)`, after which it must be of the given type.
If the target type is not already handled by Makie and requires a conversion, a new method of `(::Makie.BlockAttributeConvert{TargetType})(value)` needs to be implemented.

#### Argument Conversions

Internally the only difference with argument handling between plot and block recipes is that block recipes do not include dim converts.
This means that blocks call the same `convert_arguments` interface, just with a block instead of a plot.
You can thus define `conversion_trait(::Type{MyBlock})` or `convert_arguments(::Type{MyBlock}, args...)` just like with plots.
You can also use the `used_attributes()` interface to mark attributes (or more generally keyword arguments) as used by `convert_arguments()`.
(Using `<:MyBlock` is not necessary here because blocks are not a parametric type.)

### Traditional Blocks

The changes made to the block infrastructure should have little effect on pre-0.25 blocks.
The main change for them is that attributes moved from fields to a compute graph.
This should not break old `initialize_block!()` implementations, as attributes can be accessed the same way they did before and they can be treated as Observables.
Using `notify(block.attribute)` to initialize observable chains of a block should also continue to work, even if the attribute is now a compute graph node.

## Dim Converts

Dim converts are Makie's system for handling dates and time, units, categorical data and other data that needs to synchronize across plots.
Up until 0.25, this only worked with `x, y` and `x, y, z` data, meaning data where each plot argument represents one dimension and either 2 or 3 were present.
The system has now been expanded to also allow point-like data, different argument orders (e.g. `y, x`), arguments that are not dimensional (e.g. the matrix passed to image) as well as multiple arguments acting in the same dimension.
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
You can use `x_unit_in_ticklabel` (etc.) to toggle units (or Dates, Categorical values) appearing in ticklabels, `x_unit_in_label` (etc.) to toggle them in axis labels, `xlabel_suffix` (etc.) to set a formatter for units in axis labels and use `use_short_x_units` to toggle between abbreviations ("s") and full names ("Second") in axis labels.

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



## Nested Attributes

With 0.25 nested attributes are now supported directly by the compute graph.

### Makie before 0.25

Since 0.24 nested attributes were more or less broken. Defining them in a recipe

```julia
# no-eval
@recipe MyPlot begin
    outer = Attributes(
        inner1 = 1.0,
        inner2 = 1
    )
end
```

would not create some kind of nested compute graph structure.
Instead the `Attributes` would be treated like any other default value, i.e. as the initial value of the `plot.outer` node.
As a result accessing nested attributes required fetching the node first `outer = plot.outer[]` and then working with the enclosed observable `outer.inner1`.
In a recipe this means either working with them as observables or adding them as inputs with `add_input!(plot, :outer_inner1, plot.outer[].inner1)`.
In either case a user could break interactivity by updating `plot.outer = Attributes(...)`.
Furthermore calling `myplot(..., outer = (x = 2.0,))` would not validate names and overwrite `outer` entirely rather than merging with the nested defaults.
All of this is also true for the old `@recipe ... do scene ... end` style of recipes.

### Makie after 0.25

With the 0.25 release nested attributes are now supported in a consistent manner across (new) plot and Block recipes.

#### Nested Attribute Definition

`@attributes begin ... end` blocks are used to define nested attributes.
Docstrings can be added not just to the inner "leaf" attributes, but also to the branches containing them.

```julia
# no-eval
@recipe MyPlot begin
    "outer container"
    outer = @attributes begin
        "inner1"
        inner1 = 1.0
        inner2 = 1
    end
end
```

These docstrings can be queried with `?MyPlot.outer` or `help(MyPlot, :outer, :inner1)` for nested attributes.
Mixin expressions, e.g. `Makie.documented_attributes(Scatter)...` can also be used within an `@attributes` block.

!!! note
    The old `@recipe .... do scene ... end` style of recipes now translates `Attributes()` to `@attributes` blocks.
    The newer `@recipe ... begin ... end` style does not, and instead continues to treats them as values.

#### Access and Updates

Nested attributes are converted to individual compute nodes.
Their names are a merged version of their nesting path, e.g. `Symbol("outer.inner1")`.
They can be accessed using that name directly, or more comfortably using nested `getindex` or `getproperty` expressions:

```julia
# no-eval
plot[Symbol("outer.inner1")]
plot.outer.inner1
plot[:outer][:inner1]
```

Accessing an incomplete path, e.g. `plot.outer`, will show all the attributes inside that branch.

Attributes can be updated with `setproperty` and `setindex` expressions just like unnested attributes.
`update!()` allows the merged name or tuples to be used to refer to an attribute.
Additionally plots also allow a branch to be updated with a dict-like container.

```julia
# no-eval
plot[Symbol("outer.inner1")] = 1
plot.outer.inner1 = 1
plot[:outer][:inner1] = 1
update!(plot, Symbol("outer.inner1") => 1)
update!(plot, Dict((:outer, :inner1) => 1))
plot.outer = Dict(:inner1 => 1)
```

#### Computations

Since nested attributes lower to individual compute nodes they can be addressed without problems.
They can be referred to by a tuple or a merged symbol, or they can directly be passed as a node.
Outputs can be created in nested scope if their name is given as a tuple.

```julia
# no-eval
# by name
map!(plot, [(:outer, :inner1), Symbol("outer.inner2")], :output) do x1, x2
    ...
end
# creates: plot.output

# explicit node (can be mixed)
map!(plot, [plot.outer.inner1, (:outer, :inner2)], (:outer, :output)) do x1, x2
    ...
end
# creates: plot.outer.output
```

Computations can also be defined relative to a nesting scope, e.g. `plot.outer`.
The input and output names are then evaluated relative to that scope, e.g. `:inner1` will refer to `plot.outer.inner1`.
This can be useful if you have a set of computations that needs to act in different contexts.
For example `Axis` now has an `xaxis` and `yaxis` scope which contains the respective tick and label calculations.

```julia
# no-eval
# scoped (explicitly passed nodes can escape scope)
map!(plot.outer, [:inner1, plot.other], :output) do x1, x2
    ...
end
# creates: plot.outer.output
```

### ComputePipeline

On the ComputePipeline side nested input attributes can be added with any of

```julia
# no-eval
graph = ComputeGraph()
add_input!(graph, :outer, :inner1, 1)
add_input!(graph, (:outer, :inner2), 2)
add_input!(graph.outer, :inner3, 3) # requires graph.outer to be accessible
```

Each version saves some nesting information and adds a normal input node with names like `Symbol("outer.inner1")`.
When accessing `graph.outer`, the nesting information is checked to ensure that this nesting path leads to something.
If it does a `ComputeGraphView(graph, :outer)` is returned, which acts as a view into the "nested" graph.
Once the nesting path leads a node, e.g. `graph.outer.inner1`, the view resolves to that node.

Note that manually creating a `ComputeGraphView(graph, name)` will create an unfinished path instead of erroring if `graph[name]` does not yet exist.
(This can be useful if you want a function to fill out a nesting scope that doesn't yet exist/has no content.)

From here, access and computations work the same as discussed above.

### Old Recipes

Old recipes, e.g.

```julia
# no-eval
@recipe MyPlot do scene
    return Attributes(
        a = 1,
        b = get_theme(scene, :markercolor)
    )
end
```

are now marked as deprecated.
The `@recipe ... begin ... end` style (Makie 0.21+) should be used instead.
The translation should be relatively straight forward:
- the outer most `Attributes()` call is dropped
- `get_theme(scene, :key)` translates to `@inherit :key`
- nested `Attributes(...)` translate to `@attributes begin ... end`
- `default_theme(scene, PlotType)` translates to `documented_attributes(PlotType)`, `filtered_attributes(PlotType)` or explicitly defining attributes depending on its usage

And additionally you will be able to set docstrings by adding a string above an attribute definition.

The example above translates to:

```julia
# no-eval
@recipe MyPlot begin
    a = 1
    b = @inherit :markercolor
end
```

Note that `?Makie.@DocumentedAttributes` now documents the syntax for attributes within `@recipe`, `@Block` and `Makie.@DocumentedAttributes`.

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



## Fixes

TODO:
- barplot
- Legend
- maybe compute graph concurrency
- maybe merge precedence



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

Some recipes need to transform their data into another space, for example to add a pixel space offsets.
Doing this correctly is quite complicated due to all the different attributes and transformations that may influence the total transformation.
To simplify this process for recipes we added `register_projected_position!()`.
It builds up all the relevant computations and reacts to all the relevant inputs.

```julia
f, a, p = scatter(Rect2f(0, 0, 1, 1))
register_projected_positions!(
    p, Point2f, # optional target type for the output
    input_name = :positions,
    output_name = :pixel_positions,
    input_space = :space, # :space refers to the space attribute dynamically
    output_space = :pixel,
)
text!(
    a, p.pixel_positions, text = string.(1:4), space = :pixel,
    align = (:center, :center),
    offset = [(10, 10), (-10, 10), (-10, -10), (10, -10)]
)
f
```

A similar function also exists for transforming 2D data space directions into pixel space rotations, e.g. for rotating markers or text.
This can be tricky because the rotations change when the aspect ratio is not 1 or if the transform function distorts space.
The relevant function for that is `register_projected_rotations_2d!()`.

### Date Tick Improvements