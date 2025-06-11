# General Information

This release features a rework of how plot arguments and attributes are handled. Instead of using Observables we now use a `ComputeGraph`.

All the data a plot generates from its inputs to the final backend renderobject are stored in the graph as nodes. All the computations that connect data are stored as edges. When a plot input is updated, the graph marks every dependent node and edge as out-of-date. When data from an out-of-date node is requested, all related outdated nodes are resolved to compute the up-to-date value.

One of the goals of this refactor was to fix synchronous update issues, i.e. when two or more variables need to update together. An example would be adding a new value to the `x` and `y` values of a scatter plot. This can now be done with `Makie.update!(plot, arg1 = new_xs, arg2 = new_ys)`.

# Breaking Changes

## Attribute Handling in Recipes

Some styles of passing attributes through a recipe no longer work.

#### Splatting

Splatting "Attributes" no longer works, because attributes are now a `ComputeGraph` instead of the Dict-like `Attributes`.
```julia
plot!(parent, args...; kwargs..., parent.attributes...)
# or
attr = Attributes(parent)
plot!(parent, args...; attr...)
```

Instead they can be passed directly as the second argument:

```julia
attr = Attributes(parent)
plot!(parent, attr, args...; kwargs...)
```

Keyword arguments take priority over the nodes in `attr` here. Any node that is not compatible with `plot!()` will be ignored.

#### Copy - Modify

Copying and adjusting "Attributes" does not work anymore for the same reason
```julia
attr = copy(Attributes(plot)) # MethodError: copy(::ComputeGraph)
pop!(attr, :removed) # MethodError: pop!(::ComputeGraph, ...)
attr[:changed] = value # MethodError: setindex!(::ComputeGraph, ...)
plot!(parent, attr, args...; kwargs...)
# or plot!(parent, args...; kwargs..., attr...)
```

Instead of this you can again directly pass attributes. Instead of overwriting `attr[key] = val` you can pass that attribute as a keyword argument. Instead of deleting `pop!(attr, key)` you can [TODO]
```julia
attr = Attributes(plot)
plot!(parent, attr, args..., changed = value, TODO)
```

#### `replace_automatic!()`

`replace_automatic!()` has been removed as it is incompatible with the new `ComputeGraph`. Instead of
```julia
obs = replace_automatic!(() -> attr[:default], attr, :maybe_automatic)
plot!(..., something = obs)
```
use
```julia
# ComputeGraph (preferable)
map!(default_automatic, attr, [:maybe_automatic, :default], :new_name)
plot!(parent, ..., something = parent.new_name)

# Observable
obs = map(default_automatic, plot.maybe_automatic, plot.default)
plot!(parent, ..., something = obs)
```

## Lights

Lights are now handled by the ComputeGraph of the scene. Because of this lights no longer contain Observables and need to be updated through the scene/compute graph instead. For this a new set of helper functions has been added:
- `get_lights(scene)` returns the current lights vector (without the ambient light)
- `set_lights(scene, lights)` replaces the current lights with the given ones (excluding ambient)
- `set_ambient_light!(scene, color)` sets the color (and intensity) of the ambient light
- `set_light!(scene, n, light)` replaces the n-th light in the light vector with the given one
- `set_light!(scene, n; fields...)` updates a field of the n-the light in the light vector
- `push_light!(scene, light)` adds a light to the light vector
- `set_directional_light!(scene; [color, direction, camera_relative])` adjusts the directional light of the scene if it is the only available light other than the ambient light. (I.e. the scene is in FastShading mode)

The `shading` attribute has also changed back to a `Bool`. The decision between `FastShading` and `MultiLightShading` is now handled by the scene instead. You can also force the scene to pick one with `set_shading_algorithm!(scene, choice)`.

## Text

Text has been refactored to rely solely on the compute graph and avoid the nested structure it had before. While this may be considered internal, some recipes (and Blocks) do rely on the old structure. Usually this is for some kind of boundingbox. To simplify working with them, we added a new set of functions:
- `raw_glyph_boundingboxes(plot)` returns a markerspace boundingbox per glpyh which considers only the glyph and the fontsize.
- `fast_glyph/string_boundingboxes(plot)` returns a markerspace boundingbox per glyph/string which considers the above, string layouting, rotation and offset.
- `glyph/string_boundingboxes(plot)` returns a markerspace boundingbox per glyph/string which considers the above and positions.
- `full_boundingbox(plot, target_space)` returns a single boundingbox considering the above, transformed into `target_space`.

These functions should replace calls to `unchecked_boundingbox()`, `gl_bboxes()`, `string_boundingbox()` etc. Each of them also has a `register_$(name)!(plot)` version which registers the associated compute node, and a `$(name)_obs(plot)` version which returns an observable instead of a (vector of) boundingbox(es). Note that updating text inputs with these may result in infinite loops.

## Other breaking changes

- `annotations!()` has been removed (use `text!` instead)
- `@recipe PlotType (argnames...)` now controls the names of the converted arguments and thus has to match the output of `convert_arguments(::PlotType, ...)`
- `plot.attribute[] = value` no longer works. Use `plot.attribute = value`

# Fixes

- `surface()` now correctly aligns colors for 2x2 matrices in WGLMakie
- `meshscatter()` with per-element `uv_transform` now works in WGLMakie
- `local_update!(::Voxels)` now requires the updated data to be passed. I.e. `Makie.local_update!(plot, new_value, is, js, ks)`
