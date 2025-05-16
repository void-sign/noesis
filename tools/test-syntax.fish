#!/usr/bin/env fish

function test_func
    echo "test"
end

if test (count $argv) -eq 0 || not contains -- "--no-timeout" $argv
    if true
        echo "Success!"
        exit 0
    else
        echo "Failure!"
        exit 1
    end
end
