def fib(n)
    count = 0
    a = 0
    b = 1
    output = []
    while count < n
        if count == 0 or count == 1 then
            output[count] = count
        else
            output[count] = a + b
            a = b
            b = output[count]
        end
        count += 1
    end
    return output
end

def isPalindrome(n)
    val = n.to_s
    lim = val.length/2
    curr = 0
    while curr < lim
        if val[curr] != val[val.length - curr - 1]
            return false
        end
        curr += 1
    end
    return true
end

def nthmax(n, a)
    curr = 0
    temp = 0
    count = 0
    if n > a.length
        return nil
    end
    if a.length == 1
        return a[0]
    end
    while count < n + 1
        while curr < a.length - 1
            if a[curr] > a[curr+1]
                temp = a[curr+1]
                a[curr+1] = a[curr]
                a[curr] = temp
            end
            curr += 1
        end
        curr = 0
        count += 1
    end
    return a[a.length - n - 1] 
end

def freq(s)
    hash = {}
    curr = 0
    max = ""
    temp = ""
    while curr < s.length
        temp = s[curr]
        hash[temp] = (hash[temp] ||= 0) + 1
        if hash[temp] > (hash[max] ||= 0)
            max = temp
        end
        curr += 1
    end
    return max   
end

def zipHash(arr1, arr2)
    if arr1.length != arr2.length
        return nil
    end
    curr = 0
    hash = {}
    while curr < arr1.length
        hash[arr1[curr]] = arr2[curr]
        curr += 1
    end
    return hash
end

def hashToArray(hash)
    output = []
    hash.each do |key, value|
        curr = [key,value]
        output << curr
    end
    return output
end
