using DataFrames
using CSV

df_amd = CSV.read("../data/AMD.csv", DataFrame;
    normalizenames  = true,
    ignoreemptyrows = true,
    types = String)

#=
df_coke = CSV.read("../data/COKE.csv", DataFrame;
    normalizenames  = true,
    ignoreemptyrows = true,
    types = String)

df_nvda = CSV.read("../data/NVDA.csv", DataFrame;
    normalizenames  = true,
    ignoreemptyrows = true,
    types = String)

df_tsla = CSV.read("../data/TSLA.csv", DataFrame;
    normalizenames  = true,
    ignoreemptyrows = true,
    types = String)

df_wmt = CSV.read("../data/WMT.csv", DataFrame;
    normalizenames  = true,
    ignoreemptyrows = true,
    types = String)
=#
