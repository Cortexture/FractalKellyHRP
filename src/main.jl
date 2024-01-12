using CSV, DataFrames, DataFramesMeta, Dates

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
@select!(df_amd, :Date = :date, :return_amd = :Close ./ :Open)

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
@select!(df_coke, :Date = :date, :return_coke = :Close ./ :Open)

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
@select!(df_nvda, :Date = :date, :return_nvda = :Close ./ :Open)

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
@select!(df_tsla, :Date = :date, :return_tsla = :Close ./ :Open)

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
@select!(df_wmt, :Date = :date, :return_wmt = :Close ./ :Open)

