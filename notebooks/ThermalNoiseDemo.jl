### A Pluto.jl notebook ###
# v0.14.1

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 3d0d953e-976a-11eb-1e22-eddc92db0a7e
begin
	include("../src/ThermalNoise.jl")
	using .ThermalNoise
	using PlutoUI
	using Plots
end

# ╔═╡ b9373760-0139-495c-9405-3592ee260458
md"""
# Thermal Noise
This Pluto live script utilizes a Julia implementation of three equations for thermal noise reviewed by [[Readhead 2014](https://www.acoustics.asn.au/conference_proceedings/INTERNOISE2014/papers/p757.pdf)].

## References
[Readhead, M. L. (2014, October). Is underwater thermal noise useful?. In _Inter-Noise and Noise-Con Congress and Conference Proceedings_ (Vol. 249, No. 2, pp. 4978-4983). Institute of Noise Control Engineering.](https://www.acoustics.asn.au/conference_proceedings/INTERNOISE2014/papers/p757.pdf)

## Interactive Demonstration
"""

# ╔═╡ cffd7901-6801-4653-bba3-d25749683a7c
md"Temperature: $(@bind T′ Slider(-4.0:20.0, default = 4.0, show_value = true))°C"

# ╔═╡ 36dc15bf-fb76-4bd0-b3eb-be47f867b2af
md"Density: $(@bind ρ NumberField(1.0:2000.0, default = 1027.3)) kg/m³"

# ╔═╡ a1b547f9-50bf-478f-a79a-a17125a2493c
md"Sound Speed: $(@bind c Slider(300.0:1600.0, default = 1520.0, show_value = true)) m/s"

# ╔═╡ e6afc6dd-bf7a-4886-9fed-9f11334af8a3
@bind df′ Slider(1:6, default = 5.0)

# ╔═╡ 8f5ecd2f-caa5-4498-a78a-5c1a40614cc5
@bind a′ Slider(-3:0.1:3, default = -2.0)

# ╔═╡ 6f322496-0a40-41b8-a060-70d3cbd4ec0f
f = 10.0.^LinRange(1, 6, 501);

# ╔═╡ a767a33b-8cd7-4bd0-835d-55b1624fd525
df = 10.0^df′;

# ╔═╡ 4ca048a8-873b-4f6a-abc9-3cd3c1baf498
md"Frequency Interval Size: $df Hz"

# ╔═╡ f03e2940-0224-41d7-a8e6-2e363ef995c5
a = 10.0^a′;

# ╔═╡ 860196e1-992f-4657-94f0-664d0e1356f2
md"Sphere/Piston Radius: $a"

# ╔═╡ a78aca07-8bff-45ff-a5ba-4fdb686c65b2
begin
	T = T′ + 273.15
	NL_mellen = ThermalNoise.point.(T, ρ, c, f, df)
	NL_callenwelton = ThermalNoise.sphere.(T, ρ, c, f, df, a)
	NL_sivianwhite = ThermalNoise.piston.(T, ρ, c, f, df, a)
	nothing
end

# ╔═╡ e1b5135b-d95a-44fb-b7b5-e854f267ea41
plot(
	f/1e3, [NL_mellen, NL_callenwelton, NL_sivianwhite],
	labels = ["Point" "Sphere" "Piston"],
	title = "Thermal Noise Levels",
	ylabel = "NL [dB]",
	xlabel = "Frequency [kHz]",
	xscale = :log10,
	legend = :topleft
)

# ╔═╡ Cell order:
# ╟─b9373760-0139-495c-9405-3592ee260458
# ╟─cffd7901-6801-4653-bba3-d25749683a7c
# ╟─36dc15bf-fb76-4bd0-b3eb-be47f867b2af
# ╟─a1b547f9-50bf-478f-a79a-a17125a2493c
# ╟─4ca048a8-873b-4f6a-abc9-3cd3c1baf498
# ╟─e6afc6dd-bf7a-4886-9fed-9f11334af8a3
# ╟─860196e1-992f-4657-94f0-664d0e1356f2
# ╟─8f5ecd2f-caa5-4498-a78a-5c1a40614cc5
# ╠═6f322496-0a40-41b8-a060-70d3cbd4ec0f
# ╠═a78aca07-8bff-45ff-a5ba-4fdb686c65b2
# ╠═e1b5135b-d95a-44fb-b7b5-e854f267ea41
# ╟─3d0d953e-976a-11eb-1e22-eddc92db0a7e
# ╟─a767a33b-8cd7-4bd0-835d-55b1624fd525
# ╟─f03e2940-0224-41d7-a8e6-2e363ef995c5
