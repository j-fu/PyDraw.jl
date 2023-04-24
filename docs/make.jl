using PyDraw
using Documenter

DocMeta.setdocmeta!(PyDraw, :DocTestSetup, :(using PyDraw); recursive=true)

makedocs(;
    modules=[PyDraw],
    authors="Jürgen Fuhrmann <juergen-fuhrmann@web.de> and contributors",
    repo="https://github.com/j-fu/PyDraw.jl/blob/{commit}{path}#{line}",
    sitename="PyDraw.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://j-fu.github.io/PyDraw.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/j-fu/PyDraw.jl",
    devbranch="main",
)
