# Ritratto in fase (campo di direzioni + curve integrali) di y' = x*sin(x)
# Soluzione generale: y(x) = sin(x) - x*cos(x) + C
# Richiede: using Pkg; Pkg.add("Plots")

using Plots

f(x, y) = x * sin(x)                       # y' = f(x, y)
y_exact(x, C) = sin(x) - x * cos(x) + C    # famiglia di soluzioni

xmin, xmax = -4π, 4π
ymin, ymax = -15.0, 15.0

p = plot(; xlims = (xmin, xmax), ylims = (ymin, ymax),
         xlabel = "x", ylabel = "y",
         title = "Ritratto in fase di y' = x·sin(x)",
         legend = false, size = (900, 600))

# --- campo di direzioni ---
nx, ny = 29, 21
xs = range(xmin, xmax; length = nx)
ys = range(ymin, ymax; length = ny)
sx = (xmax - xmin)
sy = (ymax - ymin)

for x in xs, y in ys
    m = f(x, y)
    # segmento centrato in (x, y)
    L = 0.4 * (xmax - xmin) / (nx - 1)
    ang = atan(m * sx / sy)                # angolo nel riquadro normalizzato
    hx = L * cos(ang) / 2
    hy = L * sin(ang) * sy / sx / 2
    plot!(p, [x - hx, x + hx], [y - hy, y + hy]; color = :gray70, lw = 1)
end

# --- curve integrali ---
xx = range(xmin, xmax; length = 600)
for C in -12:3:12
    plot!(p, xx, y_exact.(xx, C); lw = 2)
end

display(p)
savefig(p, "ritratto_fase.png")