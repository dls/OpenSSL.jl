# This file is not an active part of the package. This is the code
# that uses the Clang.jl package to wrap Sundials using the headers.

ENV["JULIAHOME"] = "/Users/dls/jl/julia/"

using Clang.cindex
using Clang.wrap_c

if (!has(ENV, "JULIAHOME"))
  error("Please set JULIAHOME variable to the root of your julia install")
end

clang_includes = map(x->joinpath(ENV["JULIAHOME"], x), [
  "deps/llvm-3.3/build_Release/Release/lib/clang/3.3/include",
  "deps/llvm-3.3/include",
  "deps/llvm-3.3/include",
  "deps/llvm-3.3/build_Release/include/",
  "deps/llvm-3.3/include",
])

clang_extraargs = ["-D", "__STDC_LIMIT_MACROS", "-D", "__STDC_CONSTANT_MACROS"]

header_path = "/Users/dls/jl/openssl-1.0.1e/include/openssl/"
headers_to_wrap = map(x -> joinpath(header_path, x), ["aes.h", "des.h", "md5.h", "md4.h", "mdc2.h", "sha.h", "rand.h", "ecdh.h", "ecdsa.h"])
@show headers_to_wrap

wc = wrap_c.init(CommonFile="libcrypto_common.jl",
                 ClangArgs=clang_extraargs,
                 ClangIncludes=clang_includes,
                 header_wrapped= (th, h) -> contains(headers_to_wrap, h),
                 header_library= h -> "libcrypto",
                 header_outputfile= h -> joinpath("src", "gen", last(split(h, "/")) * ".jl"))

wc.options.wrap_structs = true

wrap_c.wrap_c_headers(wc, map(ascii, headers_to_wrap))
