new StaticArray<T>(length: i32) === ()> 
getRandomValues(array: Uint8Array): ][ void


  
--runtime             Specifies the runtime variant to include in the program.

                         incremental  TLSF + incremental GC (default)
                         minimal      TLSF + lightweight GC invoked externally
                         stub         Minimal runtime stub (never frees)
                         ...          Path to a custom runtime implementation

  --exportRuntime       Exports the runtime helpers (__new, __collect etc.).
