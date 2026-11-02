# Quadrica proiettiva in P^3:  x1^2 + x2^2 - x3^2 - x0^2 = 0
# Nella carta affine x0 = 1 (x = x1/x0, ecc.) diventa  x^2 + y^2 - z^2 = 1,
# l'iperboloide a una falda (rigato). I punti all'infinito (x0 = 0) sono la

using GLMakie

# --- superficie (parametrizzata da angolo θ e quota z) -----------------------
θs = range(0, 2π; length = 120)
zs = range(-2, 2; length = 80)

X = [sqrt(1 + z^2) * cos(θ) for θ in θs, z in zs]
Y = [sqrt(1 + z^2) * sin(θ) for θ in θs, z in zs]
Z = [z                      for θ in θs, z in zs]

fig = Figure(size = (900, 800))
ax  = Axis3(fig[1, 1];
            title  = "Quadrica in P³:  x₁² + x₂² − x₃² − x₀² = 0   (carta x₀ = 1)",
            aspect = :data)

surface!(ax, X, Y, Z; colormap = [:lightsteelblue, :lightsteelblue],
         alpha = 0.35, transparency = true)

save("quadrica.png",fig)
 
# Se lo script è lanciato da terminale (julia quadrica.jl) la finestra si
# chiuderebbe subito: aspettiamo che l'utente la chiuda.
if !isinteractive()
    wait(screen)
end
