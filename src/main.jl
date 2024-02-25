using Pipe: @pipe
using CSV, DataFrames, DataFramesMeta, Dates
using HypothesisTests

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
    stocks_df = innerjoin(stocks[1], stocks[2];
        on = :date, makeunique = true)
end

returns_df = load_dataframe()

amd = returns_df.return_amd
blah = ADFTest(amd, :none, 0)
println(blah.stat)
println(blah.cv[2])
println(blah.stat < blah.cv[2])

