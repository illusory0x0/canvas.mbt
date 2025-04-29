import { importObject } from '../ts-import-object/import-object.js'


(globalThis as any)["importObject"] = importObject


import('../../target/js/release/build/widgets/widgets.js')