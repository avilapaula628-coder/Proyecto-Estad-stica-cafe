### A Pluto.jl notebook ###
# v0.20.27

using Markdown
using InteractiveUtils

# ╔═╡ b94943b5-3377-4139-b130-1ea58a31d0a1
md"""
# TRABAJO ESTADÍSTICO
**Autores:** 

Paula Ávila

Marilyn Mateus

**Fecha:** 20 de Mayo del 2026

**Universidad:** USTA
"""

# ╔═╡ 96b88ff7-9e05-4090-8a4e-474131f302ad
url = "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-07/coffee_ratings.csv"

# ╔═╡ f6aa2fce-dfa5-445f-bc36-a0e0abb4be02
Downloads.download(url, "coffee_ratings.csv")

# ╔═╡ a361fe22-839f-4109-97bd-0fe370f4fb00
df = CSV.read("coffee_ratings.csv", DataFrame)

# ╔═╡ a87e2edf-a78c-40a9-86c0-8af6b87de400
first(df, 10)

# ╔═╡ 4f2dec43-9141-4581-9d76-1e735e6adb20
md"""
## Medidas de dispersión

Las medidas de dispersión permiten evaluar qué tan alejados o concentrados se encuentran los datos respecto a una medida central, generalmente la media. Estas medidas ayudan a comprender la variabilidad del conjunto de datos y el grado de homogeneidad o heterogeneidad presente en los puntajes analizados.
"""

# ╔═╡ ed5c804d-3791-4676-afa5-f46776357cf4
md"""
Antes de calcular las medidas estadísticas, se crea la variable **puntajes**, que almacena los valores del puntaje total de calidad del café (`total_cup_points`), excluyendo datos faltantes para garantizar un análisis correcto.
"""

# ╔═╡ 68100664-160b-4dca-8860-62d737268472
puntajes = collect(skipmissing(df.total_cup_points))

# ╔═╡ f10de084-c8f3-40dc-af5c-c62b7f31c29d
Q1 = Statistics.quantile(puntajes, 0.25)

# ╔═╡ 7959c8ae-69af-4eea-9807-5e825298565e
md"""
### Cuartil 1 (Q1)

**Resultado:** $(Q1)

**Interpretación:**  
El primer cuartil representa el valor por debajo del cual se encuentra el 25% de los puntajes totales de calidad del café. Esto significa que una cuarta parte de los cafés evaluados obtuvieron un puntaje igual o inferior a este valor, permitiendo identificar el límite inferior del comportamiento general de la distribución.
"""

# ╔═╡ fb91a7cc-fcb5-4fb5-a714-35cef32579f6
Q2 = Statistics.quantile(puntajes, 0.50)

# ╔═╡ 954ae7f5-10c8-4dca-829a-b502982cefc5


# ╔═╡ 840e4a98-8c42-4c98-bb3f-953d60f3e427
using Statistics

# ╔═╡ 227e93c0-5563-11f1-b720-87d0cae8072d
begin
	using CSV
	using DataFrames
	using Downloads
end

# ╔═╡ 5a8bf30c-3529-41d1-a343-d17b5183648a
# ╠═╡ disabled = true
#=╠═╡
begin
    using Statistics
    using StatsBase
    using DataFrames
    using Plots
    using StatsPlots
end
  ╠═╡ =#

# ╔═╡ Cell order:
# ╠═b94943b5-3377-4139-b130-1ea58a31d0a1
# ╠═227e93c0-5563-11f1-b720-87d0cae8072d
# ╠═96b88ff7-9e05-4090-8a4e-474131f302ad
# ╠═f6aa2fce-dfa5-445f-bc36-a0e0abb4be02
# ╠═a361fe22-839f-4109-97bd-0fe370f4fb00
# ╠═a87e2edf-a78c-40a9-86c0-8af6b87de400
# ╠═5a8bf30c-3529-41d1-a343-d17b5183648a
# ╠═4f2dec43-9141-4581-9d76-1e735e6adb20
# ╠═ed5c804d-3791-4676-afa5-f46776357cf4
# ╠═68100664-160b-4dca-8860-62d737268472
# ╠═840e4a98-8c42-4c98-bb3f-953d60f3e427
# ╠═f10de084-c8f3-40dc-af5c-c62b7f31c29d
# ╠═7959c8ae-69af-4eea-9807-5e825298565e
# ╠═fb91a7cc-fcb5-4fb5-a714-35cef32579f6
# ╠═954ae7f5-10c8-4dca-829a-b502982cefc5
