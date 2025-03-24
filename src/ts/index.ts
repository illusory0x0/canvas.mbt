import { importObject } from '../ts-import-object/import-object.js'


(globalThis as any)["importObject"] = importObject


let { entry ,add_1000} = await import('../../target/js/release/build/canvas/canvas.js')

entry()

globalThis["add_1000"] = add_1000

setTimeout(add_1000,1000)