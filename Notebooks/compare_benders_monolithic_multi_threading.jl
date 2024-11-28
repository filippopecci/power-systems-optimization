# Ensure these packages are installed; if not, use the Pkg package and Pkg.add() function to install
using Pkg; Pkg.activate(dirname(@__DIR__))

using JuMP
using HiGHS
using Plots
using DataFrames, CSV
import Printf

include("benders_cems.jl")

case = "10_days"
inputs_path = "complex_expansion_data/$(case)/"

inputs = load_inputs(inputs_path);

scaling!(inputs)

Expansion_Model = generate_monolithic_model(inputs)

monolithic_runtime = @elapsed optimize!(Expansion_Model);

planning_model = generate_planning_model(inputs);

operation_models = generate_decomposed_operation_models(inputs);

benders_runtime = @elapsed benders_solution = benders_iterations(100,planning_model,operation_models);

println("Solving the monolithic $(case) model required $(monolithic_runtime) seconds")

println("Benders decomposition solved the $(case) model in $(benders_runtime) seconds, using $(Threads.nthreads()) threads")