### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 4fc7fda6-423b-48ea-8f86-6718a9050ee0
begin
    using Pkg
    Pkg.activate(@__DIR__)
	using Revise
    ENV["LC_NUMERIC"] = "C"
    using PyDraw, SparseArrays, Printf, LaTeXStrings
    using Colors, LinearAlgebra
end


# ╔═╡ 60941eaa-1aea-11eb-1277-97b991548781
begin
    using PlutoUI, HypertextLiteral
end

# ╔═╡ 0850a715-8dd6-468b-932d-7e9a46324ed5
pydraw() do
    circle([0, 0], 0.1)
    X = [1, 2, 3]
    Y = [1, 3, 2]
    polygon(X, Y; fill = false)
    P = [4 5 6; 4 6 5]
    polygon(P; facecolor = :blue, edgecolor = :black, alpha = 0.5)
    P = [[1, 4], [2, 6], [3, 5]]
    polygon(P; facecolor = :blue, edgecolor = :black, alpha = 0.5)
end

# ╔═╡ d9397194-b266-4fcb-bd20-a131c281d462
md"""
## CC definition
"""

# ╔═╡ 95a299ce-033c-43e5-99b8-6bdb051d0877
md"""
PA=[$(@bind PA1 Slider(0:0.01:5,default=3,show_value=true)),
    $(@bind PA2 Slider(1.0:0.01:5,default=3,show_value=true))]
"""

# ╔═╡ 15ba8fe8-760d-48cd-9acc-cc0604828fab
pydraw() do

    PA = [PA1, PA2]
    PC = [5.0, 0.0]
    PB = [0, 0]



    CC = circumcenter(PA, PB, PC)
    line(PA, PB, color = :black)
    line(PB, PC, color = :black)
    line(PA, PC, color = :black)
    line(CC, edgecenter(PA, PB), color = :lightgreen)
    line(CC, edgecenter(PA, PC), color = :lightgreen)
    line(CC, edgecenter(PB, PC), color = :lightgreen)

    text(PB - [0.4, 0], L"$P_B$")
    text(PB + [0.7, 0.2], L"$\omega_B$")
    text(PA + [0, 0.2], L"$P_A$")
    text(PA - [0.1, 0.9], L"$\omega_A$")
    text(PC + [-0.9, 0.2], L"$\omega_C$")
    text(PC + [0.2, 0], L"$P_C$")
    text(CC + [-0.2, 0.3], L"$P_{CC}$")
    text(edgecenter(edgecenter(PB, PC), CC) + [0.1, 0], L"${s}_a$")
    text(edgecenter(edgecenter(PA, PC), CC) + [0, 0.2], L"${s}_b$")
    text(edgecenter(edgecenter(PA, PB), CC) + [0, 0.2], L"${s}_c$")
    text(edgecenter(PB, PC) + [0.5, -0.3], L"$a$")
    text(edgecenter(PB, PC) + [-0.1, -0.3], L"$P_{BC}$")
    text(edgecenter(PA, PC) + [-0.2, 0.5], L"$b$")
    text(edgecenter(PA, PC) + [0.1, 0.1], L"$P_{AC}$")
    text(edgecenter(PA, PB) + [0.0, 0.5], L"$c$")
    text(edgecenter(PA, PB) + [-0.5, 0.0], L"$P_{AB}$")

end


# ╔═╡ 2731d81a-0a16-43d3-a2d8-455dda6727be
md"""
## Voronoi 1D
"""

# ╔═╡ 01395889-c9b9-41a6-a559-3d5d2bf9dac2
pydraw(width = 600, height = 200, savefig = "vorodel1d.png", dpi = 300) do
    P1 = [0, 0]
    P2 = [1, 0]
    P3 = [2, 0]
    P4 = [3.5, 0]
    Pp = [6, 0]
    Pn = [7, 0]

    C1 = P1
    C2 = (P1 + P2) / 2
    C3 = (P2 + P3) / 2
    C4 = (P3 + P4) / 2
    Cp = (Pp + Pn) / 2
    Cn = Pn
    opop = [0, 0.5]
    co = :darkgreen
    lo = 0.5
    line(C1, C1 + opop, color = co)
    line(C2, C2 + opop, color = co)
    line(C3, C3 + opop, color = co)
    line(C4, C4 + opop, color = co)
    line(Cp, Cp + opop, color = co)
    line(Cn, Cn + opop, color = co)

    opop1 = [0, 0.4]
    opop2 = [0, 0.45]
    arrow_kwargs = (color = co, width = 0.005, head_width = 0.05, head_length = 0.1)
    arrow(C1 + opop1, C2 + opop1; doublehead = :true, arrow_kwargs...)
    arrow(C2 + opop1, C3 + opop1; doublehead = :true, arrow_kwargs...)
    arrow(C3 + opop1, C4 + opop1; doublehead = :true, arrow_kwargs...)
    arrow(C4 + 0.33 * (Cp - C4) + opop1, C4 + opop1; arrow_kwargs...)
    line(
        C4 + 0.33 * (Cp - C4) + opop1,
        C4 + 0.66 * (Cp - C4) + opop1;
        color = co,
        lw = lo,
        ls = :dashed,
    )
    arrow(C4 + 0.66 * (Cp - C4) + opop1, Cp + opop1; arrow_kwargs...)
    arrow(Cp + opop1, Cn + opop1; doublehead = :true, arrow_kwargs...)

    text((C1 + C2) / 2 + opop2, L"\omega_1", color = co, ha = :center, va = :bottom)
    text((C2 + C3) / 2 + opop2, L"\omega_2", color = co, ha = :center, va = :bottom)
    text((C3 + C4) / 2 + opop2, L"\omega_3", color = co, ha = :center, va = :bottom)
    text((Cp + Cn) / 2 + opop2, L"\omega_n", color = co, ha = :center, va = :bottom)

    rx = 0.05
    cx = :black
    circle(P1, rx; color = cx)
    circle(P2, rx; color = cx)
    circle(P3, rx; color = cx)
    circle(P4, rx; color = cx)
    circle(Pp, rx; color = cx)
    circle(Pn, rx; color = cx)

    tdrop = [0, -0.1]
    text(P1 + tdrop, L"x_1"; color = cx, ha = :center, va = :top)
    text(P2 + tdrop, L"x_2"; color = cx, ha = :center, va = :top)
    text(P3 + tdrop, L"x_3"; color = cx, ha = :center, va = :top)
    text(P4 + tdrop, L"x_4"; color = cx, ha = :center, va = :top)
    text(Pp + tdrop, L"x_{n-1}"; color = cx, ha = :center, va = :top)
    text(Pn + tdrop, L"x_{n}"; color = cx, ha = :center, va = :top)

    lx = 1
    line(P1, P2; color = cx, lw = lx)
    line(P2, P3; color = cx, lw = lx)
    line(P3, P4, color = cx, lw = lx)
    line(P4, P4 + 0.33 * (Pp - P4); color = cx, lw = lx)
    line(P4 + 0.33 * (Pp - P4), P4 + 0.66 * (Pp - P4), "--"; color = cx, lw = lx)
    line(P4 + 0.66 * (Pp - P4), Pp, "-"; color = cx, lw = lx)
    line(Pp, Pn, color = cx, lw = lx)
end

# ╔═╡ 4f47f767-9e1c-4d23-8d28-67ed21adb4de
md"""
## Voronoi 2D
"""

# ╔═╡ 053f28ec-c039-4cdd-8db9-f3f7013681c6
pydraw(width = 500, height = 400, savefig = "vorodel2d.png", dpi = 600) do
    rx = 0.05
    cx = :gray
    co = :green
    cb = :red
    ro = rx
    lwx = 0.75
    scale = 2
    text(scale * [4, -0.1], L"\omega_l")
    text(scale * [2.5, 0.5], L"\omega_k")
    text(scale * [1.9, 1.6], L"\omega_{l'}")

    text(scale * [1.5, 1.4], L"\gamma_{l'a}")
    text(scale * [1.4, 0.8], L"\Gamma_{a}")
    text(scale * [2.5, 2.1], L"\gamma_{l'b}")
    text(scale * [4, 2.1], L"\Gamma_{b}")

    X = [
        [2, 2],
        [3.5, 2],
        [1.5, 0.5],
        [3, 1],
        [4.5, 0.5],
        [5, 2],
        [6, 0.5],
        [3.1, -0.5],
        [5, -0.5],
        [6.1, 2],
        [1.2, -0.5],
    ]
    X = map(p -> scale * p, X)
    arrow_kwargs = (color = co, width = 0.005, head_width = 0.05, head_length = 0.1)
    nkl1 = (X[5] - X[4]) / norm(X[5] - X[4])
    pkl1 = (X[4] + X[5]) / 2
    skl1 = pkl1 + 0.35 * [nkl1[2], -nkl1[1]]
    arrow(skl1, skl1 + 0.5nkl1; arrow_kwargs...)
    text(skl1 + 0.25nkl1, L"\vec \nu_{kl}", va = :top, ha = :center)
    text(pkl1 - 0.25 * [nkl1[2], -nkl1[1]] + [0.1, 0], L"\sigma_{kl}", ha = :left)
    α1 = 0.4π
    arc(pkl1, 0.35, α1, α1 + 0.5π; color = cx, lw = lwx)
    circle(pkl1 + [-0.1, 0.18], 0.025; color = cx)

    pkl2 = (X[1] + X[4]) / 2
    nkl2 = (X[1] - X[4]) / norm(X[4] - X[1])
    skl2 = pkl2 - 0.35 * [nkl2[2], -nkl2[1]]
    arrow(skl2, skl2 + 0.5nkl2; arrow_kwargs...)
    text(skl2 + 0.2nkl2, L"\vec \nu_{kl'}", va = :top, ha = :right)
    text(pkl2 + 0.025 * [nkl2[2], -nkl2[1]] + [0.2, 0], L"\sigma_{kl'}", ha = :left)
    α2 = 0.25π
    arc(pkl2, 0.35, α2, α2 + 0.5π; color = cx, lw = lwx)
    circle(pkl2 + [-0.05, 0.2], 0.025; color = cx)

    text(X[5] + [-0.1, -0.1], L"\vec x_l", ha = :left, va = :top)
    text(X[4] + [-0.0, -0.1], L"\vec x_k", ha = :left, va = :top)
    text(X[1], L"\vec x_{l'}", ha = :right, va = :bottom)

    ela = X[1] - X[3]
    nla = [-ela[2], ela[1]] / norm(ela)
    sla = [1.85, 1.6] * scale
    arrow(sla, sla + 0.5nla; arrow_kwargs...)
    text(sla + 0.5nla, L"\vec n_{a}", va = :center, ha = :right)

    nlb = [0, 1]
    slb = [2.2, 2] * scale
    arrow(slb, slb + 0.5nlb; arrow_kwargs...)
    text(slb + 0.5nlb, L"\vec n_{b}", va = :center, ha = :left)

    T = [
        [1, 2, 4],
        [2, 5, 4],
        [2, 6, 5],
        [1, 4, 3],
        [5, 6, 7],
        [4, 5, 8],
        [3, 4, 8],
        [5, 8, 9],
        [5, 7, 9],
    ]


    B = [[1, 3], [1, 2], [2, 6], [3, 11], [6, 10]]

    for i = 1:length(X)
        circle(X[i], rx; color = cx)
        #      text(X[i],"\$x_{$(i)}\$",ha=:left,va=:top)
    end
    C = []
    for i = 1:length(T)
        polygon(
            [X[T[i]][1], X[T[i]][2], X[T[i]][3]],
            facecolor = :none,
            edgecolor = cx,
            lw = lwx,
        )
        push!(C, circumcenter(X[T[i]][1], X[T[i]][2], X[T[i]][3]))
        circle(C[i], ro; color = co)
        # text(C[i],"\$c_{$(i)}\$",ha=:left,va=:top,color=co)
    end

    E = [edgecenter(X[e[1]], X[e[2]]) for e in B]
    for i = 1:length(E)
        line(X[B[i][1]], X[B[i][2]], color = cx, lw = 2)
        #    circle(E[i],rx;color=co)
        #  text(E[i],"\$e_{$(i)}\$",ha=:left,va=:top,color=co)
    end
    circle(E[1], rx; color = co)
    circle(E[2], rx; color = co)
    V = [
        [X[1], E[2], C[1], C[4], E[1]],
        [C[1], C[2], C[6], C[7], C[4]],
        [C[2], C[3], C[5], C[9], C[8], C[6]],
    ]
    for v in V
        polygon(v; facecolor = co, alpha = 0.2, edgecolor = co)
        polygon(v; facecolor = :none, edgecolor = co)
    end

end

# ╔═╡ f9b4d4dc-7def-409f-b40a-f4eba1163741
TableOfContents()

# ╔═╡ 7a93e9a8-8a2d-4b11-84ef-691706c0eb0f
begin
    hrule() = html"""<hr>"""
    highlight(mdstring, color) =
        htl"""<blockquote style="padding: 10px; background-color: $(color);">$(mdstring)</blockquote>"""

    macro important_str(s)
        :(highlight(Markdown.parse($s), "#ffcccc"))
    end
    macro definition_str(s)
        :(highlight(Markdown.parse($s), "#ccccff"))
    end
    macro statement_str(s)
        :(highlight(Markdown.parse($s), "#ccffcc"))
    end


    html"""
        <style>
         h1{background-color:#dddddd;  padding: 10px;}
         h2{background-color:#e7e7e7;  padding: 10px;}
         h3{background-color:#eeeeee;  padding: 10px;}
         h4{background-color:#f7f7f7;  padding: 10px;}
        
	     pluto-log-dot-sizer  { max-width: 655px;}
         pluto-log-dot.Stdout { background: #002000;
	                            color: #10f080;
                                border: 6px solid #b7b7b7;
                                min-width: 18em;
                                max-height: 300px;
                                width: 675px;
                                    overflow: auto;
 	                           }
	
    </style>
"""
end

# ╔═╡ 5beb3a0d-e57a-4aea-b7a0-59b8ce9ff5ce
hrule()

# ╔═╡ Cell order:
# ╠═4fc7fda6-423b-48ea-8f86-6718a9050ee0
# ╠═0850a715-8dd6-468b-932d-7e9a46324ed5
# ╟─d9397194-b266-4fcb-bd20-a131c281d462
# ╟─95a299ce-033c-43e5-99b8-6bdb051d0877
# ╠═15ba8fe8-760d-48cd-9acc-cc0604828fab
# ╟─2731d81a-0a16-43d3-a2d8-455dda6727be
# ╠═01395889-c9b9-41a6-a559-3d5d2bf9dac2
# ╟─4f47f767-9e1c-4d23-8d28-67ed21adb4de
# ╠═053f28ec-c039-4cdd-8db9-f3f7013681c6
# ╟─5beb3a0d-e57a-4aea-b7a0-59b8ce9ff5ce
# ╠═60941eaa-1aea-11eb-1277-97b991548781
# ╠═f9b4d4dc-7def-409f-b40a-f4eba1163741
# ╟─7a93e9a8-8a2d-4b11-84ef-691706c0eb0f
