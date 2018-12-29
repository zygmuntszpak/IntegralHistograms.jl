for b = 1:nbins
    img = b*ones(10,10)
    integral = integralimage(img, nbins, minval = 0, maxval = 255)
    nrow, ncol = size(img)
    for r = 1:nrow
        for c = 1:ncol            
            @test integral[r,c,b] == r*c
        end
    end
end
