# Ritratto in fase dell'equazione autonoma  x' = x*sin(x)
# Equilibri: x = k*pi (k intero), perché x*sin(x) = 0  <=>  x = 0 oppure sin(x) = 0
# Stabilità: f'(x) = sin(x) + x*cos(x)  =>  f'(k*pi) = k*pi*(-1)^k
#   k = 0            : f'(0) = 0, ma f(x) ~ x^2 => semistabile
#   k*(-1)^k < 0     : stabile      (es. k = 1, 3, -2)
#   k*(-1)^k > 0     : instabile    (es. k = 2, -1, -3)
# Richiede: using Pkg; Pkg.add("Plots")

using Plots

f(x) = x * sin(x)

xmin, xmax = -3.5π, 3.5π
ks = -3:3

function stab(k)
    k == 0 && return :semi
    return k * (-1)^k < 0 ? :stable : :unstable
end

# ---------------- Pannello 1: grafico di f(x) e retta di fase ----------------
xx = range(xmin, xmax; length = 800)
p1 = plot(xx, f.(xx); lw = 2, color = :steelblue, legend = false,
          xlabel = "x", ylabel = "x'", title = "Ritratto in fase di x' = x·sin(x)",
          xlims = (xmin, xmax))
hline!(p1, [0]; color = :black, lw = 1)

# frecce di flusso sugli intervalli tra equilibri
pts = [k * π for k in ks]
edges = [xmin; pts; xmax]
for i in 1:length(edges)-1
    xm = (edges[i] + edges[i+1]) / 2
    s = sign(f(xm))
    annotate!(p1, xm, 0, text(s > 0 ? "→" : "←", 16, :crimson))
end

# equilibri: pieno = stabile, vuoto = instabile, grigio = semistabile
for k in ks
    st = stab(k)
    if st == :stable
        scatter!(p1, [k * π], [0]; markersize = 8, color = :black, markerstrokecolor = :black)
    elseif st == :unstable
        scatter!(p1, [k * π], [0]; markersize = 8, color = :white, markerstrokecolor = :black)
    else
        scatter!(p1, [k * π], [0]; markersize = 8, color = :gray, markerstrokecolor = :black)
    end
end

# ---------------- Pannello 2: traiettorie x(t) (RK4) ----------------
function rk4(x0, T, h)
    ts = 0:h:T
    xs = similar(collect(ts), Float64)
    x = x0
    for (i, _) in enumerate(ts)
        xs[i] = x
        k1 = f(x)
        k2 = f(x + h / 2 * k1)
        k3 = f(x + h / 2 * k2)
        k4 = f(x + h * k3)
        x += h / 6 * (k1 + 2k2 + 2k3 + k4)
    end
    return ts, xs
end

p2 = plot(; legend = false, xlabel = "t", ylabel = "x(t)",
          title = "Traiettorie", ylims = (xmin, xmax))
for k in ks
    hline!(p2, [k * π]; color = :gray70, ls = :dash, lw = 1)
end
x0s = sort(vcat(collect(range(-3.4π, 3.4π; length = 29)),
                [k * π + δ for k in ks for δ in (-0.15, 0.15)]))
for x0 in x0s
    ts, xs = rk4(x0, 8.0, 0.01)
    plot!(p2, ts, xs; lw = 1.5)
end

p = plot(p1, p2; layout = (1, 2), size = (1200, 500))
display(p)
savefig(p, "ritratto_fase_autonoma.png")