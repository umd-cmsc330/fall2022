def fib(n)
    arr = Array.new()
    i = 0

    while i < n
        if i == 0
            arr[i] = 0
        elsif i == 1
            arr[i] = 1
        else
            arr[i] = arr[i - 1] + arr[i - 2]
        end  

        i += 1
    end

    arr
end


def isPalindrome(n)
    number = n.to_s
    result = false

    if number == number.reverse
        result = true;
    end

    result
end


def nthmax(n, a)
    arr = a.sort
    arr.reverse!
    arr[n]
end


def freq(s)
    hash = Hash.new
    chars = s.split('')
    answer = ""
    answer_count = 0

    if s == ""
        return ""
    end

    chars.each do |i|
        if hash.key?(i) == true
            hash[i] += 1
        else
            hash[i] = 1
        end

        if hash[i] > answer_count
            answer = i
            answer_count = hash[i]
        end
    end

    answer
end


def zipHash(arr1, arr2)
    if arr1.length != arr2.length
        return nil
    end

    hash = Hash.new
    i = 0

    while i < arr1.length
        hash[arr1[i]] = arr2[i]
        i += 1
    end

    hash
end


def hashToArray(hash)
    arr = Array.new(hash.size) {Array.new(2)}
    i = 0

    if hash == nil
        return []
    end

    hash.each do |k, v|
        arr[i][0] = k
        arr[i][1] = v
        i += 1
    end

    arr
end

