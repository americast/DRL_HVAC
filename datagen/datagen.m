for x = 1:1:50
    mkdir(num2str(x))
    for i = 0.1:0.1:0.9
        start3(i, x)
    end
end