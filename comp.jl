using DataFrames
using Clustering
using CSV
using Statistics

FILE_PATH = "your file path here"

# Import the file
df = CSV.read(FILE_PATH)

# Drop the missing values and duplicates
df = df[completecases(df), :]
df = df[.!nonunique(df), :]

# Keep only some columns
df = df[:, [:CustomerID, :InvoiceNo, :InvoiceDate, :Quantity, :UnitPrice]]

# Remove the cancelled order as it isn't useful for what we want, and messes up the prices with negative values
for i = 1:size(df)[1]
    if occursin("C", df[i, :InvoiceNo])
        df[i, :InvoiceNo] = "toRemove"
    else
        df[i, :InvoiceNo] = df[i, :InvoiceNo]
    end
end
df = df[df[:InvoiceNo] .!= "toRemove", :]

# Simply calculate the amount by multiplying the quantity time the unit price, then remove the two latter columns
df.Amount = df.Quantity .* df.UnitPrice
deletecols!(df, [:Quantity, :UnitPrice])

# Group by invoice, calculating the sum of the purchases' amounts
db = groupby(df, :InvoiceNo)
dfa = DataFrame(CustomerID = Int64[], InvoiceNo = String[], InvoiceDate = String[], Amount = Float64[])
for i = 1:length(db)[1]
    cid = db[i][1, :CustomerID]
    invn = db[i][1, :InvoiceNo]
    invd = db[i][1, :InvoiceDate]
    am = round(sum(db[i][:Amount]), digits=2)
    push!(dfa, [cid invn invd am])
end

# Remove the hours & minutes from the date
dfa[:InvoiceDate] = map(string -> split(string)[1], dfa[:InvoiceDate])

# group by CustomerID, averaging the sums of amounts, and counting the number of different days
dc = groupby(dfa, :CustomerID)
dfb = DataFrame(CustomerID = Int64[], OrderDays = Int64[], Amount = Float64[])
for i = 1:length(dc)[1]
    cid = dc[i][1, :CustomerID]
    invd = length(unique(dc[i][:InvoiceDate]))
    am = round(mean(dc[i][:Amount]), digits=2)
    push!(dfb, [cid invd am])
end

showall(first(dfb, 6))
println("\n")
println(nrow(dfb))
println(ncol(dfb))

# convert the dataframe to a matrix so that the KMeans would be doable
X = convert(Matrix, dfb[:,[:OrderDays, :Amount]])

# Apply the algorithm to find 4 group (In my visualization I kept only 3, because an outlier group of 2 customers was making the graph lose clarity)
r = kmeans(X', 4)

# Add the cluster number as new column in dataframe
dfb.cluster = r.assignments

println(dfb)
