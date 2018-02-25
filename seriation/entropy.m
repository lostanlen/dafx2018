function H = entropy(X)
    H = sum(X .* log(X), 1);
end