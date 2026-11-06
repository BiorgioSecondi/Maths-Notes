# Animazione: parametrizzazione della conica x^2 + y^2 = z^2 tramite P^1
#
#   phi : P^1 -> P^2,  [s:t] |-> [s^2 - t^2 : 2st : s^2 + t^2]
#
# Si verifica che (s^2-t^2)^2 + (2st)^2 = (s^2+t^2)^2, quindi l'immagine sta sulla conica.
# Nella carta affine z = 1 la conica e' la circonferenza unitaria, e phi coincide con
# la proiezione dal punto (-1,0): la retta per (-1,0) di direzione (s,t) incontra la
# circonferenza proprio in phi([s:t]). Il punto [0:1] (m = infinito) va in (-1,0)
# (la retta limite e' la tangente).
#
# Uso:  julia conica_p1.jl     (la prima volta: ] add Plots)

using Plots

conic(s, t) = (s^2 - t^2, 2s * t, s^2 + t^2)
aff(X) = (X[1] / X[3], X[2] / X[3])

N = 120
θs = range(0, π, length = N + 1)[1:end-1]    # [s:t] = [cos θ : sin θ], θ in [0, π) copre tutta P^1
pts = [aff(conic(2*cos(θ), sin(θ))) for θ in θs]

circ = range(0, 2π, length = 400)
cx, cy = 2*cos.(circ), sin.(circ)

anim = @animate for (k, θ) in enumerate(θs)
    s, t = cos(θ), sin(θ)

    # Pannello destro: la conica nella carta z = 1
    p2 = plot(cx, cy; aspect_ratio = 1, legend = false, color = :gray,
              xlims = (-1.3, 1.3), ylims = (-1.3, 1.3),
              title = "Conica x² + y² = z²  (z = 1)")
    λ = range(-0.3, 2.5, length = 50)
    plot!(p2, -1 .+ λ .* s, λ .* t; color = :blue, lw = 2)   # retta per (-1,0) di direzione (s,t)
    scatter!(p2, [-1], [0]; color = :black, markersize = 4)  # centro di proiezione
    plot!(p2, first.(pts[1:k]), last.(pts[1:k]); color = :red, lw = 3)  # scia
    scatter!(p2, [pts[k][1]], [pts[k][2]]; color = :red, markersize = 6)

    plot(p1, p2; layout = (1, 2), size = (900, 450))
end

gif(anim, "conica_p1.gif"; fps = 30)
println("Salvato conica_p1.gif")