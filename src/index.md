# Welcome to Makie!

Makie is a data visualization ecosystem for the [Julia](https://julialang.org/) programming language, with high performance and extensibility.
It is available for Windows, Mac and Linux.

## Example

```julia
using GLMakie
GLMakie.activate!() # hide

Base.@kwdef mutable struct Lorenz
    dt::Float64 = 0.01
    σ::Float64 = 10
    ρ::Float64 = 28
    β::Float64 = 8/3
    x::Float64 = 1
    y::Float64 = 1
    z::Float64 = 1
end

function step!(l::Lorenz)
    dx = l.σ * (l.y - l.x)
    dy = l.x * (l.ρ - l.z) - l.y
    dz = l.x * l.y - l.β * l.z
    l.x += l.dt * dx
    l.y += l.dt * dy
    l.z += l.dt * dz
    Point3f(l.x, l.y, l.z)
end

attractor = Lorenz()

points = Observable(Point3f[])
colors = Observable(Int[])

set_theme!(theme_black())

fig, ax, l = lines(points, color = colors,
    colormap = :inferno, transparency = true,
    axis = (; type = Axis3, protrusions = (0, 0, 0, 0),
        viewmode = :fit, limits = (-30, 30, -30, 30, 0, 50)))

record(fig, "lorenz.mp4", 1:120) do frame
    for i in 1:50
        push!(points[], step!(attractor))
        push!(colors[], frame)
    end
    ax.azimuth[] = 1.7pi + 0.3 * sin(2pi * frame / 120)
    notify.((points, colors))
    l.colorrange = (0, frame)
end
set_theme!() # hide
```

## Installation and Import

Add one or more of the Makie backend packages [`GLMakie.jl`](/documentation/backends/glmakie/) (OpenGL), [`CairoMakie.jl`](/documentation/backends/cairomakie/) (Cairo), or [`WGLMakie.jl`](/documentation/backends/wglmakie/) (WebGL), [`RPRMakie`](/documentation/backends/rprmakie/) (RadeonProRender) using Julia's inbuilt package manager. Each backend re-exports `Makie` so there's no need to install it separately.

```julia
]add GLMakie
using GLMakie
```

To switch to a different backend, for example `CairoMakie`, call `CairoMakie.activate!()`.
