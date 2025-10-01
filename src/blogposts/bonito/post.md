# Bonito - A flashy Julia web framework

[Bonito](https://github.com/SimonDanisch/Bonito.jl) has been on a journey from being a pretty neglected prototype, to something offering similar functionality to established libaries like shiny/dash/Streamlit.

It is kind of funny, but I don't think I've ever officially announced [Bonito.jl](https://github.com/SimonDanisch/Bonito.jl) since its creation in 2019, because I've never really been happy with it!

It was born out of desperation for a framework to properly implement [Makie's](https://makie.org/) web backend:

* I invested significant time into [WebIO.jl](https://github.com/JuliaGizmos/WebIO.jl), but encountered several problems, the worst being that it was difficult to extend and implement new components in other packages
* In 2019, there was no real framework in Julia for generating HTML/JS with easy Julia-to-JS communication
* I needed it to work on standalone websites, inside Jupyter, the VSCode plot pane, and as a standalone HTML export, which made it impossible to find an existing solution for implementing WGLMakie

So I started what was initially called JSServe, which remained an unloved side project of mine for a long time, used solely for WGLMakie.

It has matured significantly since then, and it's now at a point where it went from something I didn't really like to something I'm actually proud of.

For example, implementing [BonitoBook](https://bonitobook.org) has been a real joy, and I'm honestly amazed by how well the composability and widget creation have worked out, since I've never actually put it to the test before. I'm not sure this would have been possible with any other framework, especially with the ability for users to completely customize it via the plugin system. Stay tuned for some updates on that later this week!
BonitoBook is probably one of the most complex Bonito apps and helped fix quite a few bugs.
[This is a small demo of using BonitoBook's claude integration]
[![bonitobook](upload://66zbhf2UubwWRV3af1dEKZw8ec2.jpeg)](https://bonitobook.org/website/bonito/mp4/ai-demo9078760227891508270.mp4)

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

```julia
using Bonito
# Create a reactive counter app
app = App() do session
    count = Observable(0)
    button = Button("Click me!")
    on(click -> (count[] += 1), button)
    return DOM.div(button, DOM.h1("Count: ", count))
end
display(app) # Display in browser or plot pane
export_static("app.html", app) # Generate self-contained HTML file from App
export_static("folder", Routes("/" => app)) # Export static site (without Julia connection)
# Or serve it on a server
server = Server(app, "127.0.0.1", 8888)
# Add it as a different route
# Regex and even custom matchers are possible for routes—read more in the docs!
route!(server, "/my-route" => app)
```

## Examples Built with Bonito

### [makie.org](https://makie.org/)

The Makie website and this blog are actually created with Bonito!

### [WGLMakie](https://docs.makie.org/dev/explanations/backends/wglmakie#WGLMakie)

Of course WGLMakie, the Interactive WebGL-accelerated plotting backend for Makie.

![ClimaAtmos](./images/animation.mp4)

[taken from ClimaAtmos.jl](https://github.com/CliMA/ClimaAtmos.jl)

### [BonitoBook](https://bonitobook.org/)

A customizable, Jupyter-like notebook environment

![](./images/book-demo.mp4)


## [NetworkDynamicsInspector](https://github.com/JuliaDynamics/NetworkDynamics.jl/tree/main/NetworkDynamicsInspector)

NetworkDynamicsInspector.jl is an extension package to NetworkDynamics.jl which provides a WebApp based on Bonito.jl and WGLMakie.jl for interactive visualization of solutions to systems based on network dynamics.

![](./images/network-inspector.mp4)

### [Example folder](https://github.com/SimonDanisch/Bonito.jl/tree/master/examples)

Have a look at some of the usage examples for Bonito, like the [interactive markdown rendering support](https://github.com/SimonDanisch/Bonito.jl/blob/master/examples/markdown.jl):

![](./images/markdown-example.mp4)

These are just selected highlights and there's much more I'm excited to share in future posts.

Looking ahead, I hope Bonito.jl gains more attention and builds a thriving ecosystem of components and apps, just like Makie! :)
