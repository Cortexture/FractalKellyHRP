using CSV, DataFrames, DataFramesMeta, Dates

function load_dataframe()
    cd("~/git/FractalKellyHRP/data/")
    files = readdir()
    for file ∈ files
        df_stock = CSV.read(file, DataFrame;
            normalizenames  = true,
            ignoreemptyrows = true,
            types = String)

        @select!(df_stock, :Date, :Open, :Close)
        @transform!(df_stock, 
            :Date = parse.(Date, :Date),
            :Open = parse.(Float64, :Open),
            :Close = parse.(Float64, :Close))
        @subset!(df_stock, :Open .> 0)
        @select!(df_stock, :Date, :return_amd = :Close ./ :Open)
    end
end

#=
df_amd = CSV.read("../data/AMD.csv", DataFrame;
    normalizenames  = true,
    ignoreemptyrows = true,
    types = String)

@select!(df_amd, :Date, :Open, :Close)
@transform!(df_amd, 
    :Date = parse.(Date, :Date),
    :Open = parse.(Float64, :Open),
    :Close = parse.(Float64, :Close))
@subset!(df_amd, :Open .> 0)
@select!(df_amd, :Date, :return_amd = :Close ./ :Open)

df_coke = CSV.read("../data/COKE.csv", DataFrame;
    normalizenames  = true,
    ignoreemptyrows = true,
    types = String)

@select!(df_coke, :Date, :Open, :Close)
@transform!(df_coke, 
    :Date = parse.(Date, :Date),
    :Open = parse.(Float64, :Open),
    :Close = parse.(Float64, :Close))
@subset!(df_coke, :Open .> 0)
@select!(df_coke, :Date, :return_coke = :Close ./ :Open)

df_nvda = CSV.read("../data/NVDA.csv", DataFrame;
    normalizenames  = true,
    ignoreemptyrows = true,
    types = String)

@select!(df_nvda, :Date, :Open, :Close)
@transform!(df_nvda, 
    :Date = parse.(Date, :Date),
    :Open = parse.(Float64, :Open),
    :Close = parse.(Float64, :Close))
@subset!(df_nvda, :Open .> 0)
@select!(df_nvda, :Date, :return_nvda = :Close ./ :Open)

df_tsla = CSV.read("../data/TSLA.csv", DataFrame;
    normalizenames  = true,
    ignoreemptyrows = true,
    types = String)

@select!(df_tsla, :Date, :Open, :Close)
@transform!(df_tsla, 
    :Date = parse.(Date, :Date),
    :Open = parse.(Float64, :Open),
    :Close = parse.(Float64, :Close))
@subset!(df_tsla, :Open .> 0)
@select!(df_tsla, :Date, :return_tsla = :Close ./ :Open)

df_wmt = CSV.read("../data/WMT.csv", DataFrame;
    normalizenames  = true,
    ignoreemptyrows = true,
    types = String)

@select!(df_wmt, :Date, :Open, :Close)
@transform!(df_wmt, 
    :Date = parse.(Date, :Date),
    :Open = parse.(Float64, :Open),
    :Close = parse.(Float64, :Close))
@subset!(df_wmt, :Open .> 0)
@select!(df_wmt, :Date, :return_wmt = :Close ./ :Open)
=#
