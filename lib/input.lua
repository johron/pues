return function(message)
    io.write(message)
    local str = io.read("*l")
    return str
end