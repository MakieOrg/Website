using WGLMakie, GeoMakie, Downloads
using GeoJSON, GeoInterface, ColorSchemes
using HDF5, GeometryBasics, Proj
using CSV, DataFrames
using Dates

function toCartesian(lon, lat; r = 1.02, cxyz = (0,0,0) )
    x = cxyz[1] + r * cosd(lat) * cosd(lon)
    y = cxyz[2] + r * cosd(lat) * sind(lon)
    z = cxyz[3] + r *sind(lat)
    return x, y, z
end

function lonlat3D2(lon, lat; cxyz = (0,0,0))
    xyzw = zeros(length(lon), 3)
    for (i,lon) in enumerate(lon)
        x, y, z = toCartesian(lon, lat[i]; cxyz = cxyz)
        xyzw[i,1] = x
        xyzw[i,2] = y
        xyzw[i,3] = z
    end
    xyzw[:,1], xyzw[:,2], xyzw[:,3]
end

# https://www.kaggle.com/code/akshaychavan/average-temperature-per-country-per-year/data
year_country = CSV.read(joinpath(@__DIR__, "GlobalLandTemperaturesByCountry.csv"), DataFrame)

year_country2 = filter(x -> x.dt > Dates.Date("1991-06-01") && x.dt < Dates.Date("2009-01-01"), year_country)
year_country2[!, :year] = year.(year_country2.dt)
df_avg = combine(groupby(year_country2, [:year, :Country]; sort=true), :AverageTemperature => mean => :Average)
sort!(df_avg, :year)
country_names = unique(df_avg.Country)

country_to_temps = Dict(map(country_names) do name
    df = filter(x -> x.Country == name, df_avg)
    sort!(df, :year)
    return name => map(x -> ismissing(x) ? NaN32 : Float32(x), df.Average)
end);

file = Downloads.download("https://datahub.io/core/geo-countries/r/countries.geojson")
states_geo = GeoJSON.read(read(file, String))
polys = GeoMakie.geo2basic(states_geo)
n_temps = length(last(first(country_to_temps)))
using Statistics
df_avg = combine(groupby(year_country2, :dt), :AverageTemperature => mean => :Average) |> show

begin
    poly_mapped = []
    temps = []
    for feat in (states_geo)
        poly = GeoMakie.geo2basic(feat)
        poly = poly isa Vector ? poly : [poly]
        meshes = []
        for p in poly
            m = GeometryBasics.triangle_mesh(p)
            x = first.(m.position)
            y = last.(m.position)
            xw, yw, zw = lonlat3D2(x, y)
            push!(meshes, GeometryBasics.Mesh(Point3f.(xw, yw, zw), faces(m)))
        end
        push!(poly_mapped, merge([meshes...]))
        name = feat.ADMIN
        if name == "United States of America"
            name = "United States"
        end
        if haskey(country_to_temps, name)
            t = country_to_temps[name]
            push!(temps, t .- t[1])
        else
            println("Not found: $(name)")
            push!(temps, fill(NaN32, n_temps))
        end
    end
end

function create_visual(idx_obs)
    fig = Figure(resolution = (1250,700), fontsize = 22)
    crange = Makie.extrema_nan(vcat(temps...))
    color_values = lift(idx_obs) do idx
        return map(x -> ismissing(x) ? 0.0 : x, getindex.(temps, idx))
    end
    year = lift(idx_obs) do idx
        return "Year: $(year_country.dt[idx])"
    end
    ax = LScene(fig[1,1]; show_axis = false)
    # text!(ax, year, position=(10, 700 / 2), space=:pixel)
    # now the plot
    s = Sphere(Point3f(0), 1.03f0)
    sm = GeometryBasics.normal_mesh(Tesselation(s, 100))
    mesh!(sm, color = (:white, 0.35), transparency = true)
    mp = mesh!(ax, [poly_mapped...], colorrange=crange, color=color_values, colormap = [:blue, :gray, :red], strokecolor = :black, shading=false)
    # Colorbar(fig[2, 1], mp; label = "temperature difference to 2000", vertical = false)
    fig
end

App() do
    s = Bonito.Slider(1:length(temps[1]))
    DOM.div(s, create_visual(s.value))
end |> display



fig = Figure(resolution=(1250, 700), fontsize=22)
ax = LScene(fig[1, 1]; show_axis=false)
s = Sphere(Point3f(0), 1.03f0)
sm = GeometryBasics.normal_mesh(Tesselation(s, 100))
mesh!(sm, color=(:white, 0.35), transparency=true)
colors = getindex.(temps2, 500)
mp = mesh!(ax, [poly_mapped...], color=colors)
# Colorbar(fig[2, 1], mp; label = "temperature difference to 2000", vertical = false)
fig
