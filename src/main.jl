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

returns_df = load_dataframe()

amd = returns_df.return_amd

# now need to get the fractional differences
# amd[2]*fraction - amd[1] and so on and so on

function find_fraction(vec)::Float64
    for i ∈ 1:-0.01:0
        diff_vec = Vector{Float64}()
        push!(diff_vec, 0)
        for j ∈ 2:length(vec)
            push!(diff_vec, vec[j]*i - vec[j-1])
        end
        test_statistics = ADFTest(diff_vec, :none, 1)
        if test_statistics.stat < test_statistics.cv[2]
            continue
        else test_statistics.stat > test_statistics.cv[2]
            return i+0.01
        end
    end
end

fraction = find_fraction(amd)

function get_differences(vec, frac)
    diff_vec = Vector{Float64}()
    push!(diff_vec, 0.0)
    for i ∈ 2:length(vec)
        push!(diff_vec, vec[i]*frac - vec[i-1])
    end
    return diff_vec
end

println(first(amd, 10))
println(mean(amd))

diff_amd = get_differences(amd, fraction) 
stationary_amd = diff_amd .- mean(diff_amd)

println(first(stationary_amd, 10))
println(mean(stationary_amd))

#=blah = ADFTest(amd, :none, 0)
println(blah.stat)
println(blah.cv[2])
println(blah.stat < blah.cv[2])
=#
