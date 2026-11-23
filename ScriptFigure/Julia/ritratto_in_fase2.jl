# Soluzioni di y' = 2y - y^2, y(0) = y0, al variare di y0
# Esegui con:  julia soluzioni_logistica.jl
# (la prima volta: using Pkg; Pkg.add("Plots"))

using Plots

# Soluzione esatta:  y(x) = 2*y0*e^(2x) / (2 + y0*(e^(2x) - 1))
y(x, y0) = 2y0 * exp(2x) / (2 + y0 * (exp(2x) - 1))

xmin, xmax = -2.0, 3.0
ymin, ymax = -3.0, 4.0
eps = 1e-3

p = plot(xlabel = "x", ylabel = "y(x)",
         xlims = (xmin, xmax), ylims = (ymin, ymax),
         legend = false, size = (800, 550),
         title = "Soluzioni di y' = 2y - y², y(0) = y₀")

# Soluzioni di equilibrio y = 0 e y = 2
hline!(p, [0.0], color = :black, lw = 2.5)
hline!(p, [2.0], color = :black, lw = 2.5, ls = :dash)

for y0 in vcat(-3:0.5:-0.5, 0.25:0.25:1.75, 2.25:0.5:6.0)
    # Tempo di blow-up: 2 + y0*(e^(2x) - 1) = 0  =>  x* = (1/2) ln((y0-2)/y0)
    if y0 < 0          # esplode in avanti (x* > 0): esiste per x < x*
        xs = 0.5 * log((y0 - 2) / y0)
        a, b = xmin, min(xmax, xs - eps)
        col = :red
    elseif y0 > 2      # esplode all'indietro (x* < 0): esiste per x > x*
        xs = 0.5 * log((y0 - 2) / y0)
        a, b = max(xmin, xs + eps), xmax
        col = :green
    else               # 0 < y0 < 2: soluzione globale
        xs = 0.5 * log((y0 - 2) / y0)
        a, b = xmin, xmax
        col = :blue
    end
    X = range(a, b, length = 800)
    plot!(p, X, y.(X, y0), color = col, lw = 1.5)
end

display(p)
savefig(p, "soluzioni_logistica.png")