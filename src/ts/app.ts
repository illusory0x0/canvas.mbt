import * as spectest from "./io"

let wasm_url = 'target/wasm-gc/release/build/mbt/mbt.wasm'

let importObject = { spectest }

const wasmModule = await WebAssembly.instantiateStreaming(fetch(wasm_url), importObject);
const exports = wasmModule.instance.exports;

let add: arrow2<number, number, number> = (exports["add"] as any);
let entry: arrow<void, void> = (exports["entry"] as any);

entry();
console.log(add(5, 6));