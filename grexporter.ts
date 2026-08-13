/** @module std/portable *//***/

let globalScope = typeof window !== "undefined" && window || typeof global !== "undefined" && global || self;
if (typeof globalScope.ASC_TARGET === "undefined") {

  globalScope.ASC_TARGET = 0; // Target.JS
  globalScope.ASC_RUNTIME = 0; // Runtime.Stub
  globalScope.ASC_NO_ASSERT = false;
  globalScope.ASC_MEMORY_BASE = 0;
  globalScope.ASC_OPTIMIZE_LEVEL = 3;
  globalScope.ASC_SHRINK_LEVEL = 0;
  globalScope.ASC_FEATURE_MUTABLE_GLOBAL = false;
  globalScope.ASC_FEATURE_SIGN_EXTENSION = false;
  globalScope.ASC_FEATURE_BULK_MEMORY = false;
  globalScope.ASC_FEATURE_SIMD = false;
  globalScope.ASC_FEATURE_THREADS = false;

  let F64 = new Float64Array(1);
  let U64 = new Uint32Array(F64.buffer);

  Object.defineProperties(
    globalScope["i8"] = function i8(value) { return value << 24 >> 24; },
    {
      "MIN_VALUE": { value: -128 },
      "MAX_VALUE": { value:  127 },

      parse(str, radix) { return parseInt(str, radix) << 24 >> 24; }
    }
  );
