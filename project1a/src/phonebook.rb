class PhoneBook

    require 'set'

    def initialize()
        @names = Set.new
        @listednum = Set.new
        @nametonum = {}
        @numtoname = {}
        @achash = {}
    end

    def add(name, number, is_listed)
        ac = self.checkNum(number)
        if ac.nil? or @names.include?(name)
            return false
        end
        @names.add(name)
        if is_listed
            if @listednum.include?(number)
                return false
            else 
                @nametonum[name] = number
                @numtoname[number] = name
                @listednum.add(number)
            end
        end
        if @achash[ac].nil?
            list = [name]
            @achash[ac] = list
        else
            @achash[ac] = @achash[ac] << name
        end   
        return true
    end

    def lookup(name)
        return @nametonum[name]
    end
    def lookupByNum(number)
        return @numtoname[number]
    end

    def namesByAc(areacode)
        list = @achash[areacode]
        if list.nil?
            list = []
        end
        return list
    end

    def checkNum(number)
        if number.length != 12
            return nil
        end
        if number[3] != "-" or number[7] != "-"
            return nil
        end
        if number[0..2].to_i == 0 or number[4..6].to_i == 0 or number[8..-1].to_i == 0
            return nil
        end
        return number[0..2]
    end
end
