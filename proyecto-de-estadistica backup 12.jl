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

# ╔═╡ 227e93c0-5563-11f1-b720-87d0cae8072d
begin
	using CSV
	using Statistics
	using StatsBase
	using DataFrames
	using StatsPlots
	using Downloads
end

>>>>>>> daff1e15975601d9874f386e93b75cc90e99bfb

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


<<<<<<< HEA

# ╔═╡ 4f2dec43-9141-4581-9d76-1e735e6adb20
md"""
## Medidas de dispersión

Las medidas de dispersión permiten evaluar qué tan alejados o concentrados se encuentran los datos respecto a una medida central, generalmente la media. Estas medidas ayudan a comprender la variabilidad del conjunto de datos y el grado de homogeneidad o heterogeneidad presente en los puntajes analizados.
"""

# ╔═╡ ed5c804d-3791-4676-afa5-f46776357cf4
md"""
Antes de calcular las medidas estadísticas, se crea la variable **puntajes**, que almacena los valores del puntaje total de calidad del café (`total_cup_points`), excluyendo datos faltantes para garantizar un análisis correcto.
======

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

# ╔═╡ 7aaa6a5a-db2c-4c76-bdeb-2c9b2b32977a
md"""
## Medidas de posición
"""

# ╔═╡ fae065c2-3bf6-4457-8522-2ea2d605a7df
md"""
Las medidas de posición permiten identificar la ubicación relativa de los datos dentro de una distribución estadística. Estas medidas dividen el conjunto de observaciones en partes proporcionales, facilitando el análisis de cómo se distribuyen los puntajes de calidad del café y permitiendo reconocer valores representativos dentro del conjunto de datos.
"""

# ╔═╡ 203bc6e2-52b3-41bc-a7ec-2d5465e3ecba
begin

    # PREPARACIÓN DE DATOS
    md"""
    ## Preparación de los datos
    """

    md"""
    Antes de calcular las medidas estadísticas, se crea la variable *puntajes*, que almacena únicamente los valores correspondientes al puntaje total de calidad del café (total_cup_points). Para garantizar un análisis correcto, se excluyen los valores faltantes.
    """
end

# ╔═╡ 9c0af810-49a7-4fe5-b394-f4d24d54ba14
md"""
    ### Cuartil 1 (Q1)
    """


# ╔═╡ 876077a7-9650-4b92-b7a2-63e3c54c1a56
md"""
    ### Cuartil 2 (Q2 - Mediana)
    """

# ╔═╡ d36ee750-8875-40d5-a719-7ed0d0bf9d1a
md"""
    ### Cuartil 3 (Q3)
    """

# ╔═╡ 4d92a9cc-8012-4ac8-a086-608fc06bae3c
md"""
    ### Decil 9 (D9)
    """

# ╔═╡ 5740e568-fcea-4f22-bb36-451bbe28b2ed
md"""
    ### Percentil 95 (P95)
    """

# ╔═╡ 179623d2-0661-48b4-baa3-d32e07704a95
md"""
## Medidas de forma
"""

# ╔═╡ 4065c088-7333-46a3-9326-431c1d10b1ad
begin

    md"""
    ## Forma de la distribución
    """

    md"""
    Las medidas de forma de la distribución permiten analizar la estructura general de los datos, evaluando aspectos como la simetría, el grado de concentración alrededor de la media y la presencia de valores atípicos. Estas medidas permiten comprender con mayor profundidad el comportamiento estadístico de los puntajes de calidad del café.
    """
end

# ╔═╡ 939d7670-e30b-4d4f-a6ef-d7dbb777b0d9
md"""
    ### Asimetría
    """

# ╔═╡ c69b4a9d-bf5c-4554-b889-bfad2fbdeb92
md"""
    ### Curtosis
    """

# ╔═╡ d8fd09e6-92fb-40d4-bdeb-bea0d05bc1cb
md"""
    ### Valores atípicos
    """

# ╔═╡ 07982cf8-14ee-4afc-91b1-1d4837b4f1c8
md"""
    *Interpretación:*  
    El diagrama de caja permite identificar observaciones extremas alejadas del comportamiento general de los datos. Estos valores atípicos representan cafés con puntajes significativamente diferentes respecto al resto del conjunto analizado.
    """


# ╔═╡ da42fea7-182b-4397-aac0-c7d0a0431f76
begin

	md"""
	## Visualizaciones
	"""

	md"""
	Las visualizaciones estadísticas permiten representar gráficamente el comportamiento de los datos, facilitando la identificación de patrones, dispersión, concentración, relaciones entre variables y posibles valores atípicos dentro del conjunto de puntajes de calidad del café.
    """
end


# ╔═╡ 7790ed1f-d0af-4867-a8b6-565b9d6b1aed
md"""
    ### Histograma
    """

# ╔═╡ e57a8e9d-4e78-4608-8d6e-daee2805298c
md"""
    *Interpretación:*  
    El histograma permite observar la forma general de la distribución de los puntajes de calidad del café, identificando concentración de datos, dispersión y posible comportamiento similar a una distribución normal.
    """

# ╔═╡ 92c30f03-4113-461a-b35a-3e0f7aeecacc
md"""
    ### Boxplot-Diagrama de Caja
    """

# ╔═╡ 7b2bd41b-b19c-49b4-953e-c66209101852
 md"""
    *Interpretación:*  
    El diagrama de caja permite visualizar la mediana, los cuartiles, la dispersión general y la presencia de valores atípicos dentro del conjunto de datos analizado.
    """

# ╔═╡ d7be6ae2-93a9-4c93-9ef6-be531bbce794
md"""
    ### Scatterplot: Aroma vs Puntaje Total
    """

# ╔═╡ 90ec9a3f-b3ba-4f1d-88ce-69498a3e79f2
 scatter(
        df.aroma,
        df.total_cup_points,
        title="Relación entre aroma y puntaje total",
        xlabel="Aroma",
        ylabel="Puntaje total",
        legend=false
    )

# ╔═╡ 95f123ef-754d-480c-9839-78d565b42bc5
md"""
    *Interpretación:*  
    El gráfico de dispersión permite analizar visualmente la relación entre el aroma y el puntaje total del café, permitiendo identificar si existe una tendencia positiva, negativa o ausencia de relación entre ambas variables.
    """

# ╔═╡ 71e8d200-3ee4-4fee-bb4c-543cd4ed90a7
md"""
    ### Gráfico de barras por país
    """


# ╔═╡ 1f57797a-4835-4d95-8e64-b0b478c3e6ee
begin
    top_paises = combine(groupby(df, :country_of_origin), nrow => :cantidad)
    top_paises = sort(top_paises, :cantidad, rev=true)[1:10, :]
    
    bar(
        top_paises.country_of_origin,
        top_paises.cantidad,
        title="Cantidad de cafés evaluados por país",
        xlabel="País",
        ylabel="Frecuencia",
        legend=false,
        xrotation=45
    )
end

# ╔═╡ d0e6e86b-a2c8-428c-acf7-41c6688c8e9f
md"""
    *Interpretación:*  
    El gráfico de barras permite comparar la cantidad de observaciones por país de origen, identificando qué países tienen mayor representación dentro del conjunto de datos analizado.
    """

# ╔═╡ b3eb56a4-f26d-46f9-ad47-04307c342825
md"""
    ### Gráfico de densidad
    """

# ╔═╡ e6f49e7a-8821-43ca-b58a-69744d96dcb1
md"""
    *Interpretación:*   
    El gráfico de barras permite comparar la cantidad de observaciones por país de origen, identificando qué países tienen mayor representación dentro del conjunto de datos analizado.
    """

# ╔═╡ 5afc7194-ac15-4540-ab7d-173747f57c5d
md"""
    ### Intervarianza
    """

# ╔═╡ af29cf8d-5049-4a90-ba48-e3603c9eeb34
begin
    datos_anova = dropmissing(df, [:country_of_origin, :total_cup_points])
        grupos = groupby(datos_anova, :country_of_origin)
        media_general = mean(datos_anova.total_cup_points)
    
        intervarianza = sum(
            nrow(g) * (mean(g.total_cup_points) - media_general)^2
            for g in grupos
        ) / (length(grupos) - 1)
end

# ╔═╡ 84a93e59-4574-40c1-a25e-9987e0ede31e
md"""
    *Resultado:* $(intervarianza)

    *Interpretación:*  
    La intervarianza obtenida representa la variabilidad existente entre los promedios de calidad del café según el país de origen.
    """

# ╔═╡ 80bdd05e-548f-4cd7-b00f-2c13a1bb2604
md"""
    ### Intravarianza
    """

# ╔═╡ 2bc94540-0c3f-4efb-a32e-8ce81008405f
intravarianza = sum(
        sum((g.total_cup_points .- mean(g.total_cup_points)).^2)
        for g in grupos
    ) / (nrow(datos_anova) - length(grupos))

# ╔═╡ e4be2e93-8a0e-4d50-8800-119d6a5ae045
md"""
    *Resultado:* $(intravarianza)

    *Interpretación:*  
    La intravarianza obtenida refleja la dispersión de los puntajes dentro de cada país analizado.
    """

# ╔═╡ f0dd29ad-9a1e-447c-af50-9a982102f12a
#=╠═╡
Q3 = Statistics.quantile(puntajes, 0.75)
  ╠═╡ =#

# ╔═╡ 5ed9491b-8abf-46cd-a2b5-1414fb4c3da7
#=╠═╡
md"""
    *Resultado:* $(Q3)

    *Interpretación:*  
    El tercer cuartil indica el valor por debajo del cual se encuentra el 75% de los puntajes, mostrando el límite superior del comportamiento típico de los datos.
    """
  ╠═╡ =#

# ╔═╡ d709dcf5-493f-4b45-aa8b-0475fd4a3a45
#=╠═╡
D9 = Statistics.quantile(puntajes, 0.90)
  ╠═╡ =#

# ╔═╡ 0b3c49f3-c36a-4e62-9ad5-35d0a55eb8c9
#=╠═╡
md"""
    *Resultado:* $(D9)

    *Interpretación:*  
    El noveno decil representa el valor por debajo del cual se encuentra el 90% de los puntajes, lo que significa que solo el 10% de los cafés evaluados superan esta calificación.
    """
  ╠═╡ =#

# ╔═╡ 4f2bb7c0-4ffa-4977-af1b-3bdd805068e0
#=╠═╡
 P95 = Statistics.quantile(puntajes, 0.95)

  ╠═╡ =#

# ╔═╡ affb4dc2-77a7-4fd2-bbba-488d6ca68200
#=╠═╡
md"""
    *Resultado:* $(P95)

    *Interpretación:*  
    El percentil 95 indica el valor por debajo del cual se encuentra el 95% de los cafés evaluados, identificando el grupo con mejor desempeño dentro del conjunto de datos.
    """
  ╠═╡ =#

# ╔═╡ 751aeadd-2d6d-4fa7-850c-8162e291b6d9
asimetria = skewness(puntajes)


# ╔═╡ aec34622-adb0-4b38-a8c5-c57e5c03aaaa
md"""
    *Resultado:* $(asimetria)

    *Interpretación:*  
    La asimetría permite identificar si la distribución de los puntajes es simétrica o presenta inclinación hacia alguno de sus extremos. Un valor cercano a cero indica una distribución equilibrada; valores positivos sugieren una cola hacia la derecha y valores negativos una cola hacia la izquierda.
    """

# ╔═╡ 7c1d0ba1-2e46-4e6a-8aa0-884581760b46
curtosis_valor = kurtosis(puntajes)

# ╔═╡ 87e0b421-4506-4652-b149-82e7914662e5
md"""
    *Resultado:* $(curtosis_valor)

    *Interpretación:*  
    La curtosis mide el grado de concentración de los datos alrededor de la media. Valores cercanos a cero indican una distribución similar a la normal; valores positivos reflejan una mayor concentración central y valores negativos una distribución más dispersa.
    """

# ╔═╡ b3e46d7d-deef-4ea9-978a-1df9c48f2cba
boxplot(
        puntajes,
        title="Detección de valores atípicos en los puntajes del café",
        ylabel="Puntaje total",
        legend=false
    )


# ╔═╡ 66aa8ecb-ba40-48e2-b42b-f83b31dfe5c2
 histogram(
        puntajes,
        bins=30,
        title="Distribución de puntajes del café",
        xlabel="Puntaje total",
        ylabel="Frecuencia",
        legend=false
    )

# ╔═╡ f381cf1a-074c-4aa5-98a2-457fba965754
#=╠═╡
StatsPlots.boxplot(
        puntajes,
        title="Distribución y valores atípicos",
        ylabel="Puntaje total",
        legend=false
    )

  ╠═╡ =#

# ╔═╡ 56428798-e084-4a14-9d32-bb68b24abf5c
density(
    puntajes,
    title="Densidad de los puntajes del café",
    xlabel="Puntaje total",
    ylabel="Densidad",
    legend=false
)

# ╔═╡ 9138876f-9802-4348-a630-4eede374ea85
#=╠═╡
md"""
    *Resultado:* $(Q1)

    *Interpretación:*  
    El primer cuartil representa el valor por debajo del cual se encuentra el 25% de los puntajes totales de calidad del café, permitiendo identificar el límite inferior del comportamiento general de los datos.
    """
  ╠═╡ =#

# ╔═╡ 7959c8ae-69af-4eea-9807-5e825298565e
#=╠═╡
md"""
### Cuartil 1 (Q1)

**Resultado:** $(Q1)

**Interpretación:**  
El primer cuartil representa el valor por debajo del cual se encuentra el 25% de los puntajes totales de calidad del café. Esto significa que una cuarta parte de los cafés evaluados obtuvieron un puntaje igual o inferior a este valor, permitiendo identificar el límite inferior del comportamiento general de la distribución.
"""
  ╠═╡ =#

# ╔═╡ 1996ef19-b17c-41de-8455-7437cfe7e640
#=╠═╡
md"""
    *Resultado:* $(Q2)

    *Interpretación:*  
    El segundo cuartil corresponde a la mediana, indicando que el 50% de los cafés evaluados presentan puntajes inferiores a este valor y el otro 50% superiores.
    """
  ╠═╡ =#

# ╔═╡ 954ae7f5-10c8-4dca-829a-b502982cefc5


# ╔═╡ f10de084-c8f3-40dc-af5c-c62b7f31c29d
#=╠═╡
Q1 = Statistics.quantile(puntajes, 0.25)
  ╠═╡ =#

# ╔═╡ 68100664-160b-4dca-8860-62d737268472
puntajes = collect(skipmissing(df.total_cup_points))

# ╔═╡ 840e4a98-8c42-4c98-bb3f-953d60f3e427
#=╠═╡
using Statistics
  ╠═╡ =#

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

# ╔═╡ a765604b-d166-44b1-9755-ca764c834109
#=╠═╡
 Q2 = Statistics.quantile(puntajes, 0.50)
  ╠═╡ =#

# ╔═╡ 657b9860-aded-42d9-8e89-b02b847021ba
#=╠═╡
Q1 = Statistics.quantile(puntajes, 0.25)
  ╠═╡ =#

# ╔═╡ c2d9a4c0-5628-11f1-bd96-611d4e388fd9
#=╠═╡
begin
	using CSV
	using DataFrames
	using Downloads
end
  ╠═╡ =#

# ╔═╡ fb91a7cc-fcb5-4fb5-a714-35cef32579f6
#=╠═╡
Q2 = Statistics.quantile(puntajes, 0.50)
  ╠═╡ =#

# ╔═╡ 0686f9f9-839f-4e01-bfb9-adb4d15e1386
 puntajes = collect(skipmissing(df.total_cup_points))

# ╔═╡ Cell order:
# ╟─b94943b5-3377-4139-b130-1ea58a31d0a1
# ╠═227e93c0-5563-11f1-b720-87d0cae8072d
# ╠═96b88ff7-9e05-4090-8a4e-474131f302ad
# ╠═f6aa2fce-dfa5-445f-bc36-a0e0abb4be02
# ╠═a361fe22-839f-4109-97bd-0fe370f4fb00
# ╠═a87e2edf-a78c-40a9-86c0-8af6b87de400
# ╠═fdfbdcd8-47a9-4997-af87-a7e8f6322935
# ╠═4f2dec43-9141-4581-9d76-1e735e6adb20
# ╠═ed5c804d-3791-4676-afa5-f46776357cf4
# ╠═4f5a9055-0a92-4bb7-9631-66287b3dc7ae
# ╠═7ce47789-4bad-4a76-8281-07d9b98aa6db
# ╠═76416780-2b92-4d85-bcba-8d87b2bf9e75
# ╠═694e3dab-1817-497a-91ac-c4575c879c2a
# ╠═ab701fc2-849a-40a5-af46-cd59d1e2d93f
# ╠═3dc07da7-d1b3-4a5f-a3ac-d0c220982e88
# ╠═7f8bea0a-6e02-4ad3-a36d-fea145ab91a5
# ╠═12d1fcc1-9062-4e23-9e99-06f2bbae16f7
# ╠═7aaa6a5a-db2c-4c76-bdeb-2c9b2b32977a
# ╠═fae065c2-3bf6-4457-8522-2ea2d605a7df
# ╠═203bc6e2-52b3-41bc-a7ec-2d5465e3ecba
# ╠═0686f9f9-839f-4e01-bfb9-adb4d15e1386
# ╠═9c0af810-49a7-4fe5-b394-f4d24d54ba14
# ╠═657b9860-aded-42d9-8e89-b02b847021ba
# ╠═9138876f-9802-4348-a630-4eede374ea85
# ╠═876077a7-9650-4b92-b7a2-63e3c54c1a56
# ╠═a765604b-d166-44b1-9755-ca764c834109
# ╠═1996ef19-b17c-41de-8455-7437cfe7e640
# ╠═d36ee750-8875-40d5-a719-7ed0d0bf9d1a
# ╠═f0dd29ad-9a1e-447c-af50-9a982102f12a
# ╠═5ed9491b-8abf-46cd-a2b5-1414fb4c3da7
# ╠═4d92a9cc-8012-4ac8-a086-608fc06bae3c
# ╠═d709dcf5-493f-4b45-aa8b-0475fd4a3a45
# ╠═0b3c49f3-c36a-4e62-9ad5-35d0a55eb8c9
# ╠═5740e568-fcea-4f22-bb36-451bbe28b2ed
# ╠═4f2bb7c0-4ffa-4977-af1b-3bdd805068e0
# ╠═affb4dc2-77a7-4fd2-bbba-488d6ca68200
# ╠═179623d2-0661-48b4-baa3-d32e07704a95
# ╠═4065c088-7333-46a3-9326-431c1d10b1ad
# ╠═939d7670-e30b-4d4f-a6ef-d7dbb777b0d9
# ╠═751aeadd-2d6d-4fa7-850c-8162e291b6d9
# ╠═aec34622-adb0-4b38-a8c5-c57e5c03aaaa
# ╠═c69b4a9d-bf5c-4554-b889-bfad2fbdeb92
# ╠═7c1d0ba1-2e46-4e6a-8aa0-884581760b46
# ╠═87e0b421-4506-4652-b149-82e7914662e5
# ╠═d8fd09e6-92fb-40d4-bdeb-bea0d05bc1cb
# ╠═b3e46d7d-deef-4ea9-978a-1df9c48f2cba
# ╠═07982cf8-14ee-4afc-91b1-1d4837b4f1c8
# ╠═da42fea7-182b-4397-aac0-c7d0a0431f76
# ╠═7790ed1f-d0af-4867-a8b6-565b9d6b1aed
# ╠═66aa8ecb-ba40-48e2-b42b-f83b31dfe5c2
# ╠═e57a8e9d-4e78-4608-8d6e-daee2805298c
# ╠═92c30f03-4113-461a-b35a-3e0f7aeecacc
# ╠═f381cf1a-074c-4aa5-98a2-457fba965754
# ╠═7b2bd41b-b19c-49b4-953e-c66209101852
# ╠═d7be6ae2-93a9-4c93-9ef6-be531bbce794
# ╠═90ec9a3f-b3ba-4f1d-88ce-69498a3e79f2
# ╠═95f123ef-754d-480c-9839-78d565b42bc5
# ╠═71e8d200-3ee4-4fee-bb4c-543cd4ed90a7
# ╠═1f57797a-4835-4d95-8e64-b0b478c3e6ee
# ╠═d0e6e86b-a2c8-428c-acf7-41c6688c8e9f
# ╠═b3eb56a4-f26d-46f9-ad47-04307c342825
# ╠═56428798-e084-4a14-9d32-bb68b24abf5c
# ╠═e6f49e7a-8821-43ca-b58a-69744d96dcb1
# ╠═5afc7194-ac15-4540-ab7d-173747f57c5d
# ╠═af29cf8d-5049-4a90-ba48-e3603c9eeb34
# ╠═84a93e59-4574-40c1-a25e-9987e0ede31e
# ╠═80bdd05e-548f-4cd7-b00f-2c13a1bb2604
# ╠═2bc94540-0c3f-4efb-a32e-8ce81008405f
# ╠═e4be2e93-8a0e-4d50-8800-119d6a5ae045
# ╠═68100664-160b-4dca-8860-62d737268472
# ╠═f10de084-c8f3-40dc-af5c-c62b7f31c29d
# ╠═7959c8ae-69af-4eea-9807-5e825298565e
# ╠═fb91a7cc-fcb5-4fb5-a714-35cef32579f6
# ╠═954ae7f5-10c8-4dca-829a-b502982cefc5
# ╠═840e4a98-8c42-4c98-bb3f-953d60f3e427
# ╠═c2d9a4c0-5628-11f1-bd96-611d4e388fd9
# ╠═5a8bf30c-3529-41d1-a343-d17b5183648a
