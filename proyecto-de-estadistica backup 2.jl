### A Pluto.jl notebook ###
# v0.20.27

using Markdown
using InteractiveUtils

# ╔═╡ 227e93c0-5563-11f1-b720-87d0cae8072d
begin
	using CSV
	using DataFrames
	using Downloads
end

# ╔═╡ 96b88ff7-9e05-4090-8a4e-474131f302ad
url = "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-07/coffee_ratings.csv"

# ╔═╡ f6aa2fce-dfa5-445f-bc36-a0e0abb4be02
Downloads.download(url, "coffee_ratings.csv")

# ╔═╡ a361fe22-839f-4109-97bd-0fe370f4fb00
df = CSV.read("coffee_ratings.csv", DataFrame)

# ╔═╡ a87e2edf-a78c-40a9-86c0-8af6b87de400
first(df, 10)

# ╔═╡ 7ce47789-4bad-4a76-8281-07d9b98aa6db


# ╔═╡ Cell order:
# ╠═227e93c0-5563-11f1-b720-87d0cae8072d
# ╠═96b88ff7-9e05-4090-8a4e-474131f302ad
# ╠═f6aa2fce-dfa5-445f-bc36-a0e0abb4be02
# ╠═a361fe22-839f-4109-97bd-0fe370f4fb00
# ╠═a87e2edf-a78c-40a9-86c0-8af6b87de400
# ╠═7ce47789-4bad-4a76-8281-07d9b98aa6db
