import { importObject } from '../ts-import-object/import-object.js'


(globalThis as any)["importObject"] = importObject


let { entry } = await import('../../target/js/release/build/canvas/canvas.js')

entry()
