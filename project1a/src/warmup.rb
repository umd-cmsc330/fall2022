def fib(n)
    arr = Array.new()
    i = 0

    while i < n
        if i == 0 || i == 1
            arr[i] = 1
        else
            arr[i] = arr[i - 1] + arr[1 - 2]
        end  

        i++
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
    a.sort
    a.reverse

    a[n]
end


def freq(s)
    hash = {}
    chars = s.split('')
    answer = nil
    answer_count = 0

    if s == ""
        return ""
    end
    
    for i in chars do
        if hash.key?(i) == true
            hash[i]++
        else
            hash[:i] = 1
        end

        if hash[i] > answer_count
            answer = i
            answer_count = hash[i]
        end
    end

    answer
end


def zipHash(arr1, arr2)
    
end


def hashToArray(hash)
    raise Exception, "Not Implemented"
end
