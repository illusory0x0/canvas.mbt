import ViteRestart from 'vite-plugin-restart'

export default {
  plugins: [
    ViteRestart({
      reload: [
        'target/wasm-gc/release/build/mbt/mbt.wasm',
      ]
    })
  ],
}