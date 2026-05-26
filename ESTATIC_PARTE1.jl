### A Pluto.jl notebook ###
# v0.20.27

using Markdown
using InteractiveUtils

# ╔═╡ 227e93c0-5563-11f1-b720-87d0cae8072d
begin
	using CSV
	using Statistics
	using StatsBase
	using DataFrames
	using Downloads
end

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
md"""
Buscamos demostrar estadísticamente que factores influyen en la calidad del café según el SCA(Specialty Coffe Association) para poder tomar decisiones de compra,precio y mejoras
"""

# ╔═╡ fdfbdcd8-47a9-4997-af87-a7e8f6322935
md"""
# Tabla de definición de variables 
"""


# ╔═╡ 4f5a9055-0a92-4bb7-9631-66287b3dc7ae
variables = DataFrame(
		Variable = ["total_cup_points", "aroma", "flavor", "country_of_origin"],
		Tipo = ["Cuantitativa Continua", "Cuantitativa Continua", "Cuantitativa Continua", "Cualitativa"],
		Escala = ["Razón", "Intervalo", "Intervalo", "Nominal"],
		Descripción = [
			"Puntaje total de catación. Rango 0-100. >80 = especialidad",
			"Calificación del aroma. Rango 0-10",
			"Calificación del sabor. Rango 0-10", 
			"País donde se cultivó el café"
		]
	)
	


# ╔═╡ 7ce47789-4bad-4a76-8281-07d9b98aa6db
begin
		md"""
Para este análisis se usan 4 variables principales de la base de
	1339 cafés:
	
**total_cup_points:** variable de estudio principal porque resume en un solo valor la calidad global del café, incluyendo aroma, sabor, acidez, cuerpo y balance. Es el estándar usado por la Specialty Coffee Association para clasificar cafés de especialidad
- Puntaje final 0-100 otorgado por catadores certificados SCA. Suma ponderada de atributos como aroma, sabor, acidez, cuerpo.  
- Es la variable dependiente principal. Con ella calculo medidas de tendencia central, dispersión, posición, forma y atípicos. También es la variable respuesta en ANOVA y correlación.  
- Define si un café clasifica como "especialidad". Media >80 indica que la base general es de alta calidad.

**species**  
- Especie botánica del café. Valores: `Arabica` o `Robusta`.  
- Se usa como factor para ANOVA de un factor. Permite comparar si la media de `total_cup_points` es significativamente diferente entre Arabica y Robusta.  
- Explica la variabilidad y los atípicos bajos. Robusta tiene genéticamente menor puntaje SCA y más cafeína, lo que impacta el promedio general.

**country_of_origin**   
- País de cultivo del café. Ej: `Ethiopia`, `Colombia`, `Brazil`, `Vietnam`.  
- Se usa como factor principal para ANOVA de un factor. Permite probar la hipótesis de si el "terroir" u origen geográfico influye en el puntaje final de calidad.  
- Permite segmentar el mercado y validar si ciertos orígenes justifican un precio premium por mayor calidad promedio.

**aroma**  
- Calificación de 0-10 otorgada por el catador solo al olor del café, evaluado en seco y en taza.  
- Se usa como variable independiente para calcular el Coeficiente de Correlación de Pearson contra `total_cup_points`.  
- Es uno de los atributos con mayor peso en la ficha SCA. Determina qué tanto influye el olor en el puntaje final.

**flavor**   
- Calificación de 0-10 otorgada por el catador solo al sabor percibido en boca.  
- Se usa como variable independiente para calcular el Coeficiente de Correlación de Pearson contra `total_cup_points` y compararla con `aroma`.  
- Junto con aroma, es el atributo sensorial más determinante. Permite decidir si se debe invertir en mejorar procesos de finca que impacten el sabor.

**processing_method**   
- Método de beneficio post-cosecha. Valores: `Washed / Wet`, `Natural / Dry`, `Honey`.  
- Se puede usar como factor adicional para ANOVA. Permite determinar si el método de proceso genera diferencias significativas en `total_cup_points`.  
- El procesamiento afecta directamente el perfil sensorial. Un ANOVA significativo justificaría la elección de un método sobre otro para alcanzar cafés de especialidad.

		"""
end

# ╔═╡ 76416780-2b92-4d85-bcba-8d87b2bf9e75
md"""
## Medidas de Tendencia Central
"""

# ╔═╡ 694e3dab-1817-497a-91ac-c4575c879c2a
begin
	# Filtramos valores > 0 por si hay errores en la base
	datos = filter(x -> x > 0, df.total_cup_points)
	p = 2  # Para la media cuadrática
	
	# Cálculo de las 6 medidas
	media_arit = mean(datos)
	mediana = median(datos)
	moda = mode(datos)
	media_geo = geomean(datos)
	media_arm = harmmean(datos)
	media_orden = (mean(datos.^p))^(1/p)  # Media cuadrática
	
	# Tabla de resultados con código
	resultados_tendencia = DataFrame(
		Medida = ["Media Aritmética", "Mediana", "Moda", "Media Geométrica", "Media Armónica", "Media Orden p=2"],
		Valor = [round(media_arit, digits=2), mediana, moda, round(media_geo, digits=2), round(media_arm, digits=2), round(media_orden, digits=2)],
		Interpretación = [
			"Promedio estándar de los 1339 cafés",
			"El 50% de cafés tiene puntaje menor a $(mediana)",
			"Puntaje que más se repite en la base",
			"Media usada para tasas. Menor que la aritmética",
			"Media para ratios. Siempre es la menor de todas",
			"Media cuadrática. Da más peso a puntajes altos"
		]
	)
	end


# ╔═╡ ab701fc2-849a-40a5-af46-cd59d1e2d93f
md"""
Se cumple la regla matemática obligatoria: **Armónica ≤ Geométrica ≤ Aritmética ≤ Cuadrática**.  
**82.06 ≤ 82.11 ≤ 82.15 ≤ 82.2**.  
Esto valida que los cálculos están bien y que la distribución tiene asimetría negativa leve, típica de bases de café de especialidad donde predominan los puntajes buenos.
**Media Aritmética = 82.15**  
Es el promedio estándar. Según SCA, un café >80 es especialidad. Como la media 82.15 > 80, **la base general es de alta calidad**. Si vendes este lote, el precio promedio es premium.

*Mediana = 82.5**  
El 50% de los cafés tiene puntaje menor a 82.5 y el otro 50% mayor. Como **Mediana 82.5 > Media 82.15**, confirma asimetría negativa: hay pocos cafés muy malos como el Robusta 73.75 que jalan la media hacia abajo.

**Moda = 83.0**  
Es el puntaje que más se repite en la base. **Moda > Mediana > Media** confirma de nuevo la asimetría negativa. La mayoría de cafés están en 83, que es un puntaje comercial muy bueno.

**Media Geométrica = 82.11**  
Se usa para tasas de crecimiento. Aquí demuestra que los datos son muy homogéneos, porque es casi igual a la aritmética. **Geométrica ≤ Aritmética** se cumple: 82.11 ≤ 82.15.

**Media Armónica = 82.06**  
Se usa para promedios de ratios o velocidades. Es la menor de todas porque castiga más los valores bajos. **Armónica ≤ Geométrica** se cumple: 82.06 ≤ 82.11.

**Media Cuadrática = 82.2**  
También llamada RMS. Da más peso a puntajes altos. Como es la mayor de todas, **Aritmética ≤ Cuadrática** se cumple: 82.15 ≤ 82.2. Confirma que hay más puntajes altos que bajos.
"""

# ╔═╡ 3dc07da7-d1b3-4a5f-a3ac-d0c220982e88
md"""
## Medidas de Dispersión
"""

# ╔═╡ 7f8bea0a-6e02-4ad3-a36d-fea145ab91a5
begin
	# Cambiamos el nombre para que no choque con la Celda 4
	datos_puntaje = filter(x -> x > 0, df.total_cup_points)
	
	# Cálculo de las 5 medidas
	varianza = var(datos_puntaje)
	desv_std = std(datos_puntaje)
	rango = maximum(datos_puntaje) - minimum(datos_puntaje)
	q1 = quantile(datos_puntaje, 0.25)
	q3 = quantile(datos_puntaje, 0.75)
	ric = q3 - q1
	cv = (desv_std / mean(datos_puntaje)) * 100
	
	# Tabla con código
	resultados_dispersion = DataFrame(
		Medida = ["Varianza", "Desviación Estándar", "Rango", "Rango Intercuartílico RIC", "Coeficiente de Variación %"],
		Valor = [round(varianza, digits=2), round(desv_std, digits=2), round(rango, digits=2), round(ric, digits=2), round(cv, digits=2)],
		Interpretación = [
			"Dispersión promedio al cuadrado. Unidades no interpretables",
			"En promedio, los puntajes se desvían $(round(desv_std, digits=2)) puntos de la media",
			"Distancia entre el mejor café $(maximum(datos_puntaje)) y el peor $(minimum(datos_puntaje))",
			"El 50% central de cafés está en un rango de solo $(round(ric, digits=2)) puntos",
			"CV = $(round(cv, digits=2))%. Como es < 10%, los datos son muy homogéneos"
		]
	)
	
		
end

# ╔═╡ 12d1fcc1-9062-4e23-9e99-06f2bbae16f7
md"""
Aunque existen atípicos que generan un rango amplio de 30.75 puntos, el **CV = 3.27% y el RIC = 2.57** demuestran que la base es altamente consistente. El 50% central de los cafés varía menos de 3 puntos SCA. Para Mateus, esto significa: **la dispersión es baja, la calidad es predecible, el negocio es estable**

**Varianza = 7.22**  
Mide la dispersión promedio al cuadrado. Sus unidades son "puntos al cuadrado" por eso es difícil de interpretar sola. Sirve como base para calcular la desviación estándar. Entre más pequeña, más juntos están los datos.

**Desviación Estándar = 2.69**  
En promedio, los puntajes se desvían ±2.69 puntos de la media 82.15. **Interpretación de negocio:** Si compras un café al azar de esta base, lo más probable es que esté entre 79.46 y 84.84 puntos. Como es baja, hay poca volatilidad en calidad.

**Rango = 30.75**  
Es la distancia entre el mejor café 90.58 y el peor 59.83. **Interpretación:** El rango es grande porque incluye atípicos. Hay cafés élite de subasta y cafés Robusta comerciales en la misma base. Para análisis, el RIC es más confiable que el rango.

**Rango Intercuartílico RIC = 2.57**  
El 50% central de los cafés está en un rango de solo 2.57 puntos. **Interpretación:** Esto es lo clave profe. Aunque el rango total es 30.75 por atípicos, la mitad de la base está súper apretada. Confirma que la mayoría son cafés consistentes entre 81 y 83.5 puntos.

**Coeficiente de Variación = 3.27%**  
CV = 2.69 / 82.15 × 100 = 3.27%. Como es **< 10%, los datos son muy homogéneos**. **Interpretación para negocio:** Esta es la medida más importante. CV < 10% significa que la calidad es muy predecible y estable. Un comprador puede confiar en que cualquier lote va a salir parecido. Riesgo bajo.

"""

# ╔═╡ 203bc6e2-52b3-41bc-a7ec-2d5465e3ecba


# ╔═╡ 0686f9f9-839f-4e01-bfb9-adb4d15e1386


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Downloads = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
CSV = "~0.10.16"
DataFrames = "~1.8.2"
StatsBase = "~0.34.10"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.6"
manifest_format = "2.0"
project_hash = "d890d3311760a68d0ff755623a50dd42042ce7b7"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "8d8e0b0f350b8e1c91420b5e64e5de774c2f0f4d"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.16"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "962834c22b66e32aa10f7611c08c8ca4e20749a9"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.8"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "9d8a54ce4b17aa5bdce0ea5c34bc5e7c340d16ad"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.18.1"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.3.0+1"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "5fab31e2e01e70ad66e3e24c968c264d1cf166d6"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.8.2"

[[deps.DataStructures]]
deps = ["OrderedCollections"]
git-tree-sha1 = "e86f4a2805f7f19bec5129bc9150c38208e5dc23"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.19.4"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.DocStringExtensions]]
git-tree-sha1 = "7442a5dfe1ebb773c29cc2962a8980f47221d76c"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.5"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.7.0"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates"]
git-tree-sha1 = "3bab2c5aa25e7840a4b065805c0cdfc01f3068d2"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.24"

    [deps.FilePathsBase.extensions]
    FilePathsBaseMmapExt = "Mmap"
    FilePathsBaseTestExt = "Test"

    [deps.FilePathsBase.weakdeps]
    Mmap = "a63ad114-7e13-5084-954f-fe012c677804"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"
version = "1.11.0"

[[deps.InlineStrings]]
git-tree-sha1 = "8f3d257792a522b4601c24a577954b0a8cd7334d"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.5"

    [deps.InlineStrings.extensions]
    ArrowTypesExt = "ArrowTypes"
    ParsersExt = "Parsers"

    [deps.InlineStrings.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"
    Parsers = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.InvertedIndices]]
git-tree-sha1 = "6da3c4316095de0f5ee2ebd875df8721e7e0bdbe"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.1"

[[deps.IrrationalConstants]]
git-tree-sha1 = "b2d91fe939cae05960e760110b328288867b5758"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.6"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JuliaSyntaxHighlighting]]
deps = ["StyledStrings"]
uuid = "ac6e5ff7-fb65-4e79-a425-ec3bc9c03011"
version = "1.12.0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "OpenSSL_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.15.0+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "OpenSSL_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.3+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.12.0"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "13ca9e2586b89836fd20cccf56e57e2b9ae7f38f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.29"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Markdown]]
deps = ["Base64", "JuliaSyntaxHighlighting", "StyledStrings"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2025.11.4"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.3.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.29+0"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.5.4+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "05868e21324cede2207c6f0f466b4bfef6d5e7ee"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.1"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "5d5e0a78e971354b1c7bff0655d11fdc1b0e12c8"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.4"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "edbeefc7a4889f528644251bdb5fc9ab5348bc2c"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.3.4"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "8b770b60760d4451834fe79dd483e318eee709c4"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.5.2"

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "REPL", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "624de6279ab7d94fc9f672f0068107eb6619732c"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "3.3.2"

    [deps.PrettyTables.extensions]
    PrettyTablesTypstryExt = "Typstry"

    [deps.PrettyTables.weakdeps]
    Typstry = "f0ed7684-a786-439e-b1e3-3b82803b501e"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.PtrArrays]]
git-tree-sha1 = "4fbbafbc6251b883f4d2705356f3641f3652a7fe"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.4.0"

[[deps.REPL]]
deps = ["InteractiveUtils", "JuliaSyntaxHighlighting", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "084c47c7c5ce5cfecefa0a98dff69eb3646b5a80"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.10"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "64d974c2e6fdf07f8155b5b2ca2ffa9069b608d9"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.2"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.12.0"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"
weakdeps = ["SparseArrays"]

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "178ed29fd5b2a2cfc3bd31c13375ae925623ff36"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.8.0"

[[deps.StatsBase]]
deps = ["AliasTables", "DataAPI", "DataStructures", "IrrationalConstants", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "aceda6f4e598d331548e04cc6b2124a6148138e3"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.10"

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "d05693d339e37d6ab134c5ab53c29fce5ee5d7d5"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.4.4"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.8.3+2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "f2c1efbc8f3a609aadf318094f8fc5204bdaf344"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.12.1"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "0716e01c3b40413de5dedbc9c5c69f27cddfddfc"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.3"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.3.1+2"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.15.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.64.0+1"
"""

# ╔═╡ Cell order:
# ╟─b94943b5-3377-4139-b130-1ea58a31d0a1
# ╠═227e93c0-5563-11f1-b720-87d0cae8072d
# ╠═96b88ff7-9e05-4090-8a4e-474131f302ad
# ╟─f6aa2fce-dfa5-445f-bc36-a0e0abb4be02
# ╟─a361fe22-839f-4109-97bd-0fe370f4fb00
# ╟─a87e2edf-a78c-40a9-86c0-8af6b87de400
# ╟─fdfbdcd8-47a9-4997-af87-a7e8f6322935
# ╟─4f5a9055-0a92-4bb7-9631-66287b3dc7ae
# ╟─7ce47789-4bad-4a76-8281-07d9b98aa6db
# ╟─76416780-2b92-4d85-bcba-8d87b2bf9e75
# ╟─694e3dab-1817-497a-91ac-c4575c879c2a
# ╟─ab701fc2-849a-40a5-af46-cd59d1e2d93f
# ╟─3dc07da7-d1b3-4a5f-a3ac-d0c220982e88
# ╟─7f8bea0a-6e02-4ad3-a36d-fea145ab91a5
# ╟─12d1fcc1-9062-4e23-9e99-06f2bbae16f7
# ╠═203bc6e2-52b3-41bc-a7ec-2d5465e3ecba
# ╠═0686f9f9-839f-4e01-bfb9-adb4d15e1386
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
