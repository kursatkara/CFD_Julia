using DelimitedFiles

using CSV
#using PyPlot
#using GR
using Plots
#plotly()
font = Plots.font("Times New Roman", 18)
#pyplot(guidefont=font, xtickfont=font, ytickfont=font, legendfont=font)

nx = 128
ny = 128
residual_hist = readdlm("residual.txt")#, datarow = 3, type=Float64)
iter_hist =  residual_hist[:,1]
res_hist = residual_hist[:,2:3]

color=[:red :blue]

p = plot(iter_hist,res_hist,lw = 3,
         ylabel = "L2 Norm", yscale = :log10,
         xlabel="Iteration count", #xlims=(0,maximum(iter_hist)+1),
         grid=(:none),
         label=["rms" "rms/rms\$_0\$"], color=color)
         #markershape = [:circle, :circle], markercolor = color,
         #markerstrokecolor = :black, markersize = 7)

savefig(p,"gs_residual.pdf")

init_field = readdlm("field_initial.txt")#, type=Float64)
final_field = readdlm("field_final.txt")#, datarow = 3, type=Float64)

x = convert(Array,init_field[:,1])
y = convert(Array,init_field[:,2])

u_e = convert(Array,init_field[:,5])
u_e = reshape(u_e, (nx+1, ny+1))

u_n = convert(Array,final_field[:,4])
u_n = reshape(u_n, (nx+1, ny+1))

xx = x[1:nx+1]
yy = reshape(y, (nx+1, ny+1))[1,:]

XX = repeat(xx, 1, length(yy))
XX = convert(Matrix,transpose(XX))
YY = repeat(yy, 1, length(xx))

p1 = contour(xx, yy, u_e, fill=true,xlabel="\$X\$", ylabel="\$Y\$", title="Exact")
p2 = contour(xx, yy, u_n, fill=true,xlabel="\$X\$", ylabel="\$Y\$", title="Gauss-Seidel solution")
p3 = plot(p1,p2, size = (1300, 600))
savefig(p3,"gs_contour.png")