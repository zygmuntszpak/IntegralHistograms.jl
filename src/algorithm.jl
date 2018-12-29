function integralimage(img, bins; minval = 0, maxval = 1)
    # if typeof(img) == Array{RGB{Normed{UInt8,8}},2}
    #     arrayimg = float.(Gray.(img))
    # elseif typeof(img) == Array{Float64,2}
    #     arrayimg = img
    # end

    row, col = size(img)
    integral_image = zeros(row, col, bins)
    #edges = range(0, step = 1/bins, stop = 1)
    #edges = range(minval, step = maxval/bins, stop = maxval)
    edges = StatsBase.histrange([minval, maxval], bins) # Make this work
    @show collect(edges)

    for i = 1:row
        for j = 1:col
            bin = searchsortedlast(edges, img[i,j])
            @show bin, img[i,j]
            integral_image[i, j, bin] = 1
            # Cummulative sum for each layer at that pixel
            for b = 1:bins
                if i == 1 && j == 1
                    left = 0
                    top = 0
                    topleft = 0
                elseif i == 1 && j != 1
                    left = 0
                    topleft = 0
                    top = integral_image[i, j - 1, b]
                elseif i != 1 && j == 1
                    top = 0
                    topleft = 0
                    left = integral_image[i - 1, j, b]
                else
                    left = integral_image[i - 1, j, b]
                    top = integral_image[i, j - 1, b]
                    topleft = integral_image[i - 1, j - 1, b]
                end
                integral_image[i, j, b] = left + top - topleft + integral_image[i, j, b]
            end
        end
    end

    return integral_image

end

function integralhistogram(interal_image, k, m, l, n)
    if k == 1
        k = 2
    end

    if m == 1
        m = 2
    end

    bins = size(integral_image)[3]
    hist = zeros(bins)
    for b = 1:bins
        hist[b] = integral_image[k - 1, m - 1, b] + integral_image[l, n, b]

            - integral_image[k - 1, n, b] - integral_image[l, m - 1, b]
    end

    return hist

end
