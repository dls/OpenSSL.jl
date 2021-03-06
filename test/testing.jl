macro assert_equal(a, b)
    quote
        aval = $a
        bval = $b
        if aval != bval
            println("Failure: (", aval, " != ", bval, "), expected it to ==")
        else
            print(".")
        end
    end
end

macro assert_not_equal(a, b)
    quote
        aval = $a
        bval = $b
        if aval == bval
            println("Failure: (", aval, " == ", bval, "), expected it to !=")
        else
            print(".")
        end
    end
end
