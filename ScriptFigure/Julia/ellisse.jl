using Plots

θs = range(0,2π; length = 120)

x = [2*cos(θ) for θ in θs]
y = [3*sin(θ) for θ in θs]

p = Plots.plot(x,y;
    framestyle = :none,
    grid = false,
    legend = false,
    color = :black,
)

display(p)