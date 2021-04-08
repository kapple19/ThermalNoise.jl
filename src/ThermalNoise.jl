module ThermalNoise
import SpecialFunctions: besselj

"Boltzmann's constant"
k_B = 1.380649e-23

"Convert mean-square pressure to noise level in decibels."
pms2nl(p_ms) = 20log10(√p_ms/1e-6)

"""
`point(T::Real, ρ::Real, c::Real, f::Real, df::Real)`

Thermal noise level for a piston, derived by Mellen [Readhead 2014], with
* `T`  Temperature [K]
* `ρ`  Density [kg/m³]
* `c`  Sound Speed [m/s]
* `f`  Frequency [Hz]
* `df` Frequency Interval Size [Hz]

Readhead, M. L. (2014, October). Is underwater thermal noise useful?. In Inter-Noise and Noise-Con Congress and Conference Proceedings (Vol. 249, No. 2, pp. 4978-4983). Institute of Noise Control Engineering.
"""
function point(
  T::Real, # Temperature [K]
  ρ::Real, # Density [kg/m³]
  c::Real, # Sound Speed [m/s]
  f::Real, # Frequency [Hz]
  df::Real # Frequency Interval Size [Hz]
)
  Nl = 4π * k_B * T * ρ * f^2 * df / c |> pms2nl
end

"""
`sphere(T::Real, ρ::Real, c::Real, f::Real, df::Real, a::Real)`

Thermal noise level averaged over the surface of a sphere, with
* `T`  temperature [K]
* `ρ`  density [kg/m³]
* `c`  sound tpeed [m/s]
* `f`  frequency [Hz]
* `df` frequency interval size [Hz]
* `a`  sphere radius

Readhead, M. L. (2014, October). Is underwater thermal noise useful?. In Inter-Noise and Noise-Con Congress and Conference Proceedings (Vol. 249, No. 2, pp. 4978-4983). Institute of Noise Control Engineering.
"""
function sphere(
  T::Real, # Temperature [K]
  ρ::Real, # Density [kg/m³]
  c::Real, # Sound Speed [m/s]
  f::Real, # Frequency [Hz]
  df::Real, # Frequency Interval Size [Hz]
  a::Real # Sphere Radius [m]
)
  k = 2π * f / c
  NL = 4π * k_B * T * ρ * f^2 / c / (1 + (k*a)^2) * df |> pms2nl
end

"""
`piston(T::Real, ρ::Real, c::Real, f::Real, df::Real, a::Real)`

Thermal noise level averaged over the surface of a piston, with
* `T`  temperature [K]
* `ρ`  density [kg/m³]
* `c`  sound tpeed [m/s]
* `f`  frequency [Hz]
* `df` frequency interval size [Hz]
* `a`  piston radius

Readhead, M. L. (2014, October). Is underwater thermal noise useful?. In Inter-Noise and Noise-Con Congress and Conference Proceedings (Vol. 249, No. 2, pp. 4978-4983). Institute of Noise Control Engineering.
"""
function piston(
  T::Real, # Temperature [K]
  ρ::Real, # Density [kg/m³]
  c::Real, # Sound Speed [m/s]
  f::Real, # Frequency [Hz]
  df::Real, # Frequency Interval Size [Hz]
  a::Real # Piston Radius [m]
)
  k = 2π * f / c
  NL = 4k_B * T * ρ * c / π / a^2 * (1 - besselj(1, 2k*a)/k/a) * df |> pms2nl
end

end