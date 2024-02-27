using Pipe: @pipe
using CSV, DataFrames, DataFramesMeta, Dates
using HypothesisTests
using StatsBase

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
function find_fraction(vec)::Float64
    for i ∈ 1:-0.01:0
        diff_vec = Vector{Float64}()
        push!(diff_vec, 0)
        for j ∈ 2:length(vec)
            push!(diff_vec, vec[j] - vec[j-1]*i)
        end
        test_statistics = ADFTest(diff_vec, :none, 1)
        if test_statistics.stat < test_statistics.cv[2]
            continue
        else test_statistics.stat > test_statistics.cv[2]
            return i+0.01
        end
    end
end
function make_stationary(vec, frac)
    diff_vec = Vector{Float64}()
    push!(diff_vec, 0.0)
    for i ∈ 2:length(vec)
        push!(diff_vec, vec[i] - vec[i-1]*frac)
    end
    return diff_vec 
end

returns_df = load_dataframe()
amd = returns_df.return_amd
nvda = returns_df.return_nvda

demeaned_amd = amd .- mean(amd)
demeaned_nvda = nvda .- mean(nvda)

println(ADFTest(amd, :none, 0))
println(ADFTest(demeaned_amd, :none, 0))
println(ADFTest(nvda, :none, 0))
println(ADFTest(demeaned_nvda, :none, 0))

