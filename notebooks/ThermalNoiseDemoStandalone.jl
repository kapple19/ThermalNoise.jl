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

# ╔═╡ c5002144-216c-447f-a7e1-054584ce14d8
begin
	try
		using PlutoUI
	catch
		using Pkg
		Pkg.add("PlutoUI")
		using PlutoUI
	end
	
	try
		using Plots: plot, plot!
	catch
		using Pkg
		Pkg.add("Plots")
		using Plots: plot, plot!
	end
	
	
	try
		using SpecialFunctions: besselj
	catch
		using Pkg
		Pkg.add("SpecialFunctions")
		using SpecialFunctions: besselj
	end
end

# ╔═╡ d3432db0-9821-11eb-2073-cdfe156fcf9b
md"""
# Thermal Noise
This Pluto live script utilizes a Julia implementation of three equations for thermal noise reviewed by [[Readhead 2014](https://www.acoustics.asn.au/conference_proceedings/INTERNOISE2014/papers/p757.pdf)].
"""

# ╔═╡ 965db134-2559-4c00-ad35-b23bd65dea5f
PlutoUI.TableOfContents(title = "Table of Contents", indent = true)

# ╔═╡ f200e91f-ec2b-488d-9125-47e58ec4b0d8
md"""
## References
[Readhead, M. L. (2014, October). Is underwater thermal noise useful?. In _Inter-Noise and Noise-Con Congress and Conference Proceedings_ (Vol. 249, No. 2, pp. 4978-4983). Institute of Noise Control Engineering.](https://www.acoustics.asn.au/conference_proceedings/INTERNOISE2014/papers/p757.pdf)
"""

# ╔═╡ bb39ff2c-5896-436c-a1f4-e69a03483d5f
md"## Implementation"

# ╔═╡ 77542a59-ae78-4f70-8724-9ec5b2552e14
md"""
__Please wait while Julia installs packages (not local to your computer, but in the online environment it's being run in).__
"""

# ╔═╡ 9b428e83-955a-4a99-9d9d-cd669c8b8834
md"""
For each thermal noise equation implementation below, their respective inputs are consistently:
* `T` temperature [K]
* `ρ` density [kg/m³]
* `c` sound tpeed [m/s]
* `f` frequency [Hz]
* `df` frequency interval size [Hz]
* `a` sphere/piston radius [m]
"""

# ╔═╡ ddb99148-700d-4485-8acc-cbb9e940328a
"Boltzmann's constant"
k_B = 1.380649e-23;

# ╔═╡ ce811de3-8bc5-43d9-8545-cd11470ac211
"Convert mean-square pressurein Pa² to noise level in decibels."
pms2nl(p_ms) = 20log10(√p_ms/1e-6);

# ╔═╡ 5acaeee8-30ef-4da6-84b6-a259e60e69cc
md"""
### Point
`point(T::Real, ρ::Real, c::Real, f::Real, df::Real)`

Thermal noise level for a point, derived by Mellen separate from Callen & Welton, but arrived at the exact same formula [Readhead 2014].
"""

# ╔═╡ 48b13d15-dd5d-4fa3-b06f-913f94531eb1
function point(T::Real, ρ::Real, c::Real, f::Real, df::Real)
  Nl = 4π * k_B * T * ρ * f^2 * df / c |> pms2nl
end;

# ╔═╡ 33d5a515-5c8b-482d-a0b6-c5ce24d81f70
md"""
### Spherical Surface
`sphere(T::Real, ρ::Real, c::Real, f::Real, df::Real, a::Real)`

Thermal noise level averaged over the surface of a sphere, derived by Callen & Welton [Readhead 2014].
"""

# ╔═╡ 852ac300-f8ad-4886-a4d5-a3b8c68e3e9d
function sphere(T::Real, ρ::Real, c::Real, f::Real, df::Real, a::Real)
  k = 2π * f / c
  NL = 4π * k_B * T * ρ * f^2 / c / (1 + (k*a)^2) * df |> pms2nl
end;

# ╔═╡ 6e818191-c03c-41a2-a67c-ef7e665a5067
md"""
### Piston Surface
`piston(T::Real, ρ::Real, c::Real, f::Real, df::Real, a::Real)`

Thermal noise level averaged over the surface of a piston, derived by Sivian & White [Readhead 2014].
"""

# ╔═╡ 4a117724-ae3e-4a61-afc5-7b8bd1db2352
function piston(T::Real, ρ::Real, c::Real, f::Real, df::Real, a::Real)
  k = 2π * f / c
  NL = 4k_B * T * ρ * c / π / a^2 * (1 - besselj(1, 2k*a)/k/a) * df |> pms2nl
end

# ╔═╡ d28729da-6160-4f65-9a3d-12afe32977db
md"## Interactive Demonstration"

# ╔═╡ 8113c667-0068-45a2-8092-ca75709dcb8c
md"Temperature: $(@bind T′ Slider(-4.0:20.0, default = 4.0, show_value = true))°C"

# ╔═╡ fe2d3405-619a-4e0a-8a06-4b31374ac22a
md"Density: $(@bind ρ NumberField(1.0:2000.0, default = 1027.3)) kg/m³"

# ╔═╡ e61808e3-4d73-4e49-a89b-2ccd2e9a2b75
md"Sound Speed: $(@bind c Slider(300.0:1600.0, default = 1520.0, show_value = true)) m/s"

# ╔═╡ 55e74759-b51a-489b-8a2d-7cf5b2ba8f7d
@bind df′ Slider(1:6, default = 5.0)

# ╔═╡ b69f726f-6c25-49f6-851e-f5a78a9df01e
@bind a′ Slider(-3:0.1:3, default = -2.0)

# ╔═╡ 386c1210-9731-4382-bc54-12daba3df21e
f = 10.0.^LinRange(1, 6, 501);

# ╔═╡ 852fd43b-0052-4163-b1a8-fd840eb48d66
T = T′ + 273.15;

# ╔═╡ f9b8892c-c086-489d-9f70-b00c220ae782
df = 10.0^df′;

# ╔═╡ eb99feb2-29c2-4269-b19a-4504b5c8cc8a
md"Frequency Interval Size: $df Hz"

# ╔═╡ 7d876c26-74dd-4f6a-b22c-a1562998e320
a = 10.0^a′;

# ╔═╡ 2b07d85d-e380-460a-b343-7fb07235012a
md"Sphere/Piston Radius: $a"

# ╔═╡ 25e018ca-2dbe-421b-966f-94a1a4e24e22
begin
	plot(
		title = "Thermal Noise Levels",
		ylabel = "NL [dB]",
		xlabel = "Frequency [Hz]",
		xscale = :log10,
		legend = :topleft
	)
	plot!(f, f -> point(T, ρ, c, f, df), label = "Point")
	plot!(f, f -> sphere(T, ρ, c, f, df, a), label = "Sphere")
	plot!(f, f -> piston(T, ρ, c, f, df, a), label = "Piston")
end

# ╔═╡ Cell order:
# ╟─d3432db0-9821-11eb-2073-cdfe156fcf9b
# ╟─965db134-2559-4c00-ad35-b23bd65dea5f
# ╟─f200e91f-ec2b-488d-9125-47e58ec4b0d8
# ╟─bb39ff2c-5896-436c-a1f4-e69a03483d5f
# ╟─77542a59-ae78-4f70-8724-9ec5b2552e14
# ╟─9b428e83-955a-4a99-9d9d-cd669c8b8834
# ╠═ddb99148-700d-4485-8acc-cbb9e940328a
# ╠═ce811de3-8bc5-43d9-8545-cd11470ac211
# ╟─5acaeee8-30ef-4da6-84b6-a259e60e69cc
# ╠═48b13d15-dd5d-4fa3-b06f-913f94531eb1
# ╟─33d5a515-5c8b-482d-a0b6-c5ce24d81f70
# ╠═852ac300-f8ad-4886-a4d5-a3b8c68e3e9d
# ╟─6e818191-c03c-41a2-a67c-ef7e665a5067
# ╠═4a117724-ae3e-4a61-afc5-7b8bd1db2352
# ╟─d28729da-6160-4f65-9a3d-12afe32977db
# ╟─8113c667-0068-45a2-8092-ca75709dcb8c
# ╟─fe2d3405-619a-4e0a-8a06-4b31374ac22a
# ╟─e61808e3-4d73-4e49-a89b-2ccd2e9a2b75
# ╟─eb99feb2-29c2-4269-b19a-4504b5c8cc8a
# ╟─55e74759-b51a-489b-8a2d-7cf5b2ba8f7d
# ╟─2b07d85d-e380-460a-b343-7fb07235012a
# ╟─b69f726f-6c25-49f6-851e-f5a78a9df01e
# ╠═386c1210-9731-4382-bc54-12daba3df21e
# ╠═25e018ca-2dbe-421b-966f-94a1a4e24e22
# ╟─c5002144-216c-447f-a7e1-054584ce14d8
# ╟─852fd43b-0052-4163-b1a8-fd840eb48d66
# ╟─f9b8892c-c086-489d-9f70-b00c220ae782
# ╟─7d876c26-74dd-4f6a-b22c-a1562998e320
