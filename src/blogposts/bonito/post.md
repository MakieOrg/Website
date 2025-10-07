# Bonito - A flashy Julia web framework

[Bonito](https://github.com/SimonDanisch/Bonito.jl) has been on a journey from being a pretty neglected prototype to something offering similar functionality to established libraries like Shiny/Dash/Streamlit.

It is kind of funny, but I don't think I've ever officially announced [Bonito.jl](https://github.com/SimonDanisch/Bonito.jl) since its creation in 2019, because I've never really been happy with it!

It was born out of desperation for a framework to properly implement [Makie's](https://makie.org/) web backend, WGLMakie:

* I invested significant time into [WebIO.jl](https://github.com/JuliaGizmos/WebIO.jl), but encountered several problems, the worst being that it was difficult to extend and implement new components in other packages
* In 2019, there was no real framework in Julia for generating HTML/JS with easy Julia-to-JS communication
* I needed it to work on standalone websites, inside Jupyter, the VSCode plot pane, and as a standalone HTML export, which made it impossible to find an existing solution

So I started what was initially called JSServe, which remained an unloved side project of mine for a long time, used solely for WGLMakie.

It has matured significantly since then, and it's now at a point where it went from something I didn't really like to something I'm actually proud of.

It's now a framework with lots of features, including an extensible [handler system](https://simondanisch.github.io/Bonito.jl/stable/handlers.html) (similar to middleware) that lets you wrap apps with authentication, rate limiting, or custom logic. For example, `ProtectedRoute` adds HTTP Basic Authentication with password hashing and rate limiting to protect any app or static files:

```julia
# no-eval
using Bonito
server = Server("127.0.0.1", 8081)
admin_app = App(()-> DOM.h1("Admin Panel"))
protected = ProtectedRoute(admin_app, SingleUser("admin", "secret"))
route!(server, "/admin" => protected)
```

It comes with a simple `SingleUser` store for basic needs, but you can extend the `AbstractPasswordStore` interface to integrate with databases, LDAP, or any authentication backend by implementing a single `get_user` method. Meanwhile, `FolderServer` serves static files with proper MIME types. Handlers compose naturally, making it straightforward to create complex server setups and password-protect your apps.

This composability theme runs throughout Bonito. Implementing [BonitoBook](https://bonitobook.org), a Jupyter-like notebook ecosystem, has been a real joy. The composability and widget creation worked surprisingly well at this scale — something I wouldn't have been confident attempting a few years ago. With the upcoming plugin system, users will be able to completely customize how their notebooks work, which opens up some exciting possibilities. Expect an announcement on that soon!

For now, here's a demo of BonitoBook's Claude chat widget creating an interactive dashboard with a Makie plot in seconds:

![bonitobook](./images/ai-demo.mp4)

At this point, Bonito brings several interesting features to the table, perhaps even outside the Julia world:

- **Reactive & Interactive**: Built on Observables.jl for automatic UI updates when data changes, sending only the minimal amount of data via a fast binary serialization protocol
- **Rich Component Library**: Buttons, sliders, tables, code editors, and easy custom widget creation
- **Seamless Plotting**: Deep integration with WGLMakie, plus support for Plotly, Gadfly, and anything else supporting the Julia display system
- **Deploy Anywhere**: Works in VSCode, Jupyter, Pluto, web servers, or export to static HTML
- **JavaScript When You Need It**: Easy ES6 module integration and JavaScript execution
- **Pure Julia Development**: Write your entire application in Julia, with optional JavaScript for client-side rendering
- **Extensible Handlers**: Wrap and compose handlers for authentication, logging, static files, and custom middleware
- **Use Any Existing JS/CSS/HTML**: Bonito provides no opinionated styling by default. Combined with straightforward external dependency integration, this gives you complete access to the entire JS/CSS/HTML ecosystem from within Julia.


## Quick Example

[Bonito.Table](https://simondanisch.github.io/Bonito.jl/stable/widgets.html#Bonito.Table-widgets) got a revamp in the newest release, with better styling options and column/row sorting:

```julia
using Bonito
# Returning any DOM or jsrender'able in a markdown block,
# you can inline it into the blogpost
function example()
    # Interactive table from any Tables.jl-compatible data
    df = (
        name=["Alice", "Bob", "Charlie"],
        age=[25, 30, 35],
        city=["NYC", "LA", "Chicago"]
    )
    # Reactive counter
    count = Observable(0)
    button = Button("Click me!")
    on(click -> (count[] += 1), button)
    return DOM.div(
        DOM.h2("Sortable Table"),
        Bonito.Table(df),  # Automatic formatting, sortable columns
        DOM.h2("Counter: ", count), # Inline Observables directly into DOM
        button
    )
end
example()
```

Note that the table sorting (by clicking on column headers) stays interactive since it's implemented in JavaScript, while the button calls Julia, so it needs a running Julia process:

```julia
# no-eval
# Deploy it, wrap it into an App:
app = App(example) # any function returning a jsrender'able
# Works in VSCode, Jupyter, Pluto, or opens a browser in the REPL
display(app)
# Serve on a live server with full interactivity
server = Server(app, "127.0.0.1", 8888) # adds app as route!(server, "/" => app)
# Export to static HTML (counter won't work without Julia)
export_static("app.html", app)
# Export full static site into a folder
export_static("site", Routes("/" => app))
```

## Examples Built with Bonito

### [makie.org](https://makie.org/)

The Makie website and this blog are actually created with Bonito!

### [BonitoBook](https://bonitobook.org/)

A customizable, Jupyter-like notebook environment

![](./images/book-demo.mp4)


### [NetworkDynamicsInspector](https://github.com/JuliaDynamics/NetworkDynamics.jl/tree/main/NetworkDynamicsInspector)

NetworkDynamicsInspector.jl is an extension package to NetworkDynamics.jl which provides a WebApp based on Bonito.jl and WGLMakie.jl for interactive visualization of solutions to systems based on network dynamics.

![network inspector demo](./images/network-inspector.mp4)

### [Example folder](https://github.com/SimonDanisch/Bonito.jl/tree/master/examples)

Have a look at some of the usage examples for Bonito, like the [interactive markdown rendering support](https://github.com/SimonDanisch/Bonito.jl/blob/master/examples/markdown.jl):

![markdown example](./images/markdown-example.mp4)

### [WGLMakie](https://docs.makie.org/dev/explanations/backends/wglmakie#WGLMakie)

And of course WGLMakie, the Interactive WebGL-accelerated plotting backend for Makie.

![ClimaAtmos](./images/animation.mp4)

[Example from Alexandre Renchon in ClimaAtmos.jl](https://github.com/CliMA/ClimaAtmos.jl)


These are just selected highlights and there's much more I'm excited to share in future posts.

Looking ahead, I hope Bonito.jl gains more attention and builds a thriving ecosystem of components and apps, just like Makie! :)
