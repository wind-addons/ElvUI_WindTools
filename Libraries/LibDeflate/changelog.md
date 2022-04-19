### v1.0.2-release

* Change the license to the zlib license (Formerly LGPLv3). This license is more permissive than LGPLv3.
* Increase compression speed by up to 25% on high compression level on non-JIT lua interpreter.
* Bump the World of Warcraft toc version to 80300

### v1.0.1-release

* 2019/11/18
* No functional change
* Bump the World of Warcraft toc version to 80205
* No longer "Load on Demand" in Warcraft toc, because this library does not consume much memory. This makes easier to load and test this library.
* Change the license to LGPLv3 (Formerly GPLv3)

### v1.0.0-release

* 2018/7/30
* Documentation updates.

### v0.9.0-beta4

* 2018/5/25
* "DecodeForPrint" always remove prefixed or trailing control or space characters before decoding. This makes this API easier to use.

### v0.9.0-beta3

* 2018/5/23
* Fix an issue in "DecodeForPrint" that certain undecodable string
  could cause an Lua error.
* Add an parameter to "DecodeForPrint". If set, remove trailing spaces in the
input string before decode it.
* Add input type checks for all encode/decode functions.

### v0.9.0-beta2

* 2018/5/22
* API "Encode6Bit" is renamed to "EncodeForPrint"
* API "Decode6Bit" is renamed to "DecodeForPrint"

### v0.9.0-beta1

* 2018/5/22
* No change

### v0.9.0-alpha2

* 2018/5/21
* Remove API LibDeflate:VerifyDictionary
* Remove API LibDeflate:DictForWoW
* Changed API LibDeflate:CreateDictionary

### v0.9.0-alpha1

* 2018/5/20
* The first working version.
