module PyDraw
import PyPlot
import Triangulate

function pyplot(f; width = 300, height = 300, savefig = nothing, dpi = 100)
    PyPlot.clf()
    f()
    fig = PyPlot.gcf()
    fig.set_size_inches(width / 100, height / 100)
    !isnothing(savefig) &&
        PyPlot.savefig(savefig; dpi, pad_inches = 0.0, bbox_inches = "tight")
    fig
end


function pydraw(f; width = 300, height = 300, savefig = nothing, dpi = 100)
    PyPlot.clf()
    ax = PyPlot.axes(aspect = 1.0)
    f()
    fig = PyPlot.gcf()
    fig.set_size_inches(width / 100, height / 100)
    PyPlot.axis("off")
    ax.get_xaxis().set_visible(false)
    ax.get_yaxis().set_visible(false)
    PyPlot.tight_layout()
    !isnothing(savefig) &&
        PyPlot.savefig(savefig; dpi, pad_inches = 0.0, bbox_inches = "tight")
    fig
end


line(p1, p2, lt = "-"; kwargs...) =
    PyPlot.plot([p1[1], p2[1]], [p1[2], p2[2]], lt; kwargs...)

function arrow(p1, p2; doublehead = false, kwargs...)
    PyPlot.arrow(
        p1[1],
        p1[2],
        p2[1] - p1[1],
        p2[2] - p1[2];
        length_includes_head = true,
        kwargs...,
    )
    if doublehead
        arrow(p2, p1; doublehead = false, kwargs...)
    end
end
#    arrow(p1,p2;kwargs...)=PyPlot.annotate("",p1,p2;kwargs...)

text(p, txt; kwargs...) = PyPlot.text(p[1], p[2], txt; kwargs...)

polygon(X::AbstractVector, Y::AbstractVector; kwargs...) = PyPlot.fill(X, Y; kwargs...)

polygon(P::AbstractMatrix; kwargs...) = polygon(P[1, :], P[2, :]; kwargs...)

function polygon(P::AbstractVector{T}; kwargs...) where {T<:Union{AbstractVector,Tuple}}
    polygon([p[1] for p in P], [p[2] for p in P]; kwargs...)
end

function circle(p, r; kwargs...)
    t = range(0, 2π, length = Int(max(10, ceil(100 * r))))
    PyPlot.fill(p[1] .+ r * cos.(t), p[2] .+ r * sin.(t); kwargs...)
end

function arc(p, r, t1, t2; kwargs...)
    t = range(t1, t2, length = Int(ceil(100 * abs((t2 - t1) / 2π))))
    PyPlot.plot(p[1] .+ r * cos.(t), p[2] .+ r * sin.(t); kwargs...)
end

circumcenter(PA, PB, PC) = Triangulate.tricircumcenter!([0.0, 0.0], PA, PB, PC)

edgecenter(PA, PB) = [(PA[1] + PB[1]) / 2, (PA[2] + PB[2]) / 2]

export pyplot, pydraw, line, arrow, text, polygon, circle, arc, circumcenter, edgecenter

end
