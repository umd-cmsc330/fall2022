class PhoneBook
    def initialize
        @listed = Hash.new
        @unlisted = Hash.new
    end

    def add(name, number, is_listed)
        num = /[0-9]{3}-[0-9]{3}-[0-9]{4}/
        if num !~ number 
            return false
        end

        if listed.key?(name) == true or unlisted.key?(name)
            return false
        end

        if is_listed == true
            if listed.value?(number) == true
                return false
            else
                listed[name] = number
            end
        else
            unlisted[name] = number
        end

        true
    end

    def lookup(name)
        raise Exception, "Not implemented"
    end

    def lookupByNum(number)
        raise Exception, "Not implemented"
    end

    def namesByAc(areacode)
        raise Exception, "Not implemented"
    end
end
