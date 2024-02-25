using Pipe: @pipe
using CSV, DataFrames, DataFramesMeta, Dates

function load_dataframe()
    cd("../data/")
    names = @pipe readdir() .|> chop(_, tail = 4) .|> lowercase
    files = readdir(join = true)
    stocks = Vector{DataFrame}()
    for i in eachindex(files)
        stock = CSV.read(files[i], DataFrame;
            normalizenames  = true,
            ignoreemptyrows = true,
            types = String)
        @select!(stock, :Date, :Open, :Close)
        @transform!(stock, 
            :Date = parse.(Date, :Date),
            :Open = parse.(Float64, :Open),
            :Close = parse.(Float64, :Close))
        @subset!(stock, :Open .> 0)
        @select!(stock, :Date, :Return = :Close ./ :Open)
        name = names[i]
        rename!(stock, :Date => "date", :Return => "return_$name")
        push!(stocks, stock)
    end

    # Hardcoded this, need a better implementation
    stocks_df = innerjoin(stocks[1], stocks[2], stocks[3], stocks[4], stocks[5];
        on = :date, makeunique = true)

end

test = load_dataframe()
