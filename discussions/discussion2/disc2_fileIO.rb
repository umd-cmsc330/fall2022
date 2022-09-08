def readlines_example(file_name)

    File.open(file_name, "r") do |file|
        file.readlines.each do |line|
            puts line
        end
    end
end

def readline_example(file_name)

    File.open(file_name, "r") do |file|
        puts file.readline

        1.upto(3) do
            puts file.readline
        end
    end
end

def process_each_line_example(file_name)

    lines_array = Array.new(10)

    File.open("readlines.txt", "r") do |file|
        file.readlines.each do |line|
            if line =~ /^This is line (\d+)$/
                lines_array[$1.to_i] = line
            end
        end
    end
    puts "printing the lines array"

    lines_array.each { |line| puts line }
end

file_name = "readlines.txt"

# readline_example(file_name)
# readlines_example(file_name)
# process_each_line_example(file_name)