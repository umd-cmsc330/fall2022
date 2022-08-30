require "minitest/autorun"
require_relative "../../src/warmup.rb"
require_relative "../../src/phonebook.rb"

class PublicTests < MiniTest::Test
    def setup
        @phonebook = PhoneBook.new
    end

    def test_public_fib
        assert_equal([], fib(0))
        assert_equal([0], fib(1))
        assert_equal([0, 1], fib(2))
        assert_equal([0, 1, 1], fib(3))
        assert_equal([0, 1, 1, 2, 3, 5, 8, 13, 21, 34], fib(10))
    end

    def test_public_ispalindrome
        assert_equal(true, isPalindrome(0))
        assert_equal(true, isPalindrome(1))
        assert_equal(false, isPalindrome(10))
        assert_equal(true, isPalindrome(101))
        assert_equal(false, isPalindrome(120210))
    end

    def test_public_nthmax
        assert_equal(3, nthmax(0, [1,2,3,0]))
        assert_equal(2, nthmax(1, [3,2,1,0]))
        assert_equal(4, nthmax(2, [7,3,4,5]))
        assert_nil(nthmax(5, [1,2,3]))
    end

    def test_public_freq
        assert_equal("", freq(""))
        assert_equal("a", freq("aaabb"))
        assert_equal("a", freq("bbaaa"))
        assert_equal("s", freq("ssabcd"))
        assert_equal("x", freq("a12xxxxxyyyxyxyxy"))
    end

    def test_public_ziphash
        assert_equal({}, zipHash([], []))
        assert_equal({1 => 2}, zipHash([1], [2]))
        assert_equal({1 => 2, 5 => 4}, zipHash([1, 5], [2, 4]))
        assert_nil(zipHash([1], [2,3]))
        assert_equal({"Mamat" => "prof", "Hicks" => "prof", "Vinnie" => "TA"},
                      zipHash(["Mamat", "Hicks", "Vinnie"], ["prof", "prof", "TA"]))
    end

    def test_public_hashtoarray
        assert_equal([], hashToArray({}))
        assert_equal([["a", "b"]], hashToArray({"a" => "b"}))
        assert_equal([["a", "b"], [1, 2]], hashToArray({"a" => "b", 1 => 2}))
        assert_equal([["x", "v"], ["y", "w"], ["z", "u"]], hashToArray({"x" => "v", "y" => "w", "z" => "u"}))
    end

    def test_public_phonebook_add
        assert_equal(true, @phonebook.add("John", "110-192-1862", false))
        assert_equal(true, @phonebook.add("Jane", "220-134-1312", false))
        assert_equal(false, @phonebook.add("John", "110-192-1862", false))
    end

    def test_public_phonebook_lookup
        assert_equal(true, @phonebook.add("John", "110-192-1862", false))
        assert_equal(true, @phonebook.add("Jane", "220-134-1312", true))
        assert_equal(true, @phonebook.add("Jack", "114-192-1862", false))
        assert_equal(true, @phonebook.add("Jessie", "410-124-1131", true))
        assert_nil(@phonebook.lookup("John"))
        assert_nil(@phonebook.lookup("Jack"))
        assert_equal("220-134-1312", @phonebook.lookup("Jane"))
        assert_equal("410-124-1131", @phonebook.lookup("Jessie"))
    end

    def test_public_phonebook_lookup_by_num
        assert_equal(true, @phonebook.add("John", "110-192-1862", false))
        assert_equal(true, @phonebook.add("Jane", "220-134-1312", true))
        assert_equal(true, @phonebook.add("Jack", "114-192-1862", false))
        assert_equal(true, @phonebook.add("Jessie", "410-124-1131", true))
        assert_nil(@phonebook.lookupByNum("110-192-1862"))
        assert_nil(@phonebook.lookupByNum("114-192-1862"))
        assert_equal("Jane", @phonebook.lookupByNum("220-134-1312"))
        assert_equal("Jessie", @phonebook.lookupByNum("410-124-1131"))
    end

    def test_public_names_by_ac
        assert_equal(true, @phonebook.add("John", "110-192-1862", false))
        assert_equal(true, @phonebook.add("Jane", "110-134-1312", true))
        assert_equal(true, @phonebook.add("Jack", "114-192-1862", false))
        assert_equal(true, @phonebook.add("Jessie", "110-124-1131", true))
        assert_equal(["John", "Jane", "Jessie"].sort, @phonebook.namesByAc("110").sort)
        assert_equal(["Jack"], @phonebook.namesByAc("114"))
        assert_equal([], @phonebook.namesByAc("111"))
    end
end
