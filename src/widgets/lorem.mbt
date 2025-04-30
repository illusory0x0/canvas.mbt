///|
const Lorem =
  #| Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce nec sagittis urna. Proin accumsan dapibus convallis. Duis quis ultrices ligula. Duis gravida tincidunt turpis, nec placerat quam lacinia vitae. Sed a porta sem, nec mattis elit. Nunc pharetra varius tellus, nec condimentum justo suscipit a. Proin molestie, ligula nec ultrices viverra, ante erat congue quam, eget vulputate leo purus quis elit. Nullam luctus urna at pretium tincidunt. Pellentesque at dictum libero, ac cursus sem.
  #| Nullam tortor ipsum, consectetur vel efficitur eu, faucibus vitae ligula. Aliquam egestas arcu sit amet leo gravida, in tincidunt ipsum viverra. Nunc at mauris eros. Nam sit amet venenatis elit. Nullam sed nulla eget magna bibendum consectetur ut eu ipsum. Nulla ullamcorper, urna eget laoreet luctus, elit diam luctus magna, sed lacinia dolor nisi sit amet diam. Nam lectus leo, rhoncus nec risus vitae, euismod commodo lacus. Duis et purus cursus, sodales velit ac, auctor elit. Maecenas cursus efficitur urna non mattis. Donec vitae justo nec nisi pharetra sagittis a a nisi. Etiam lacinia erat nec posuere feugiat. Nulla gravida fermentum neque sit amet varius.
  #| Phasellus varius mauris a aliquet ultricies. Nam erat eros, hendrerit ac est at, scelerisque pellentesque risus. Proin malesuada nibh id vehicula tincidunt. Proin ac nulla id est facilisis semper. Proin egestas id augue sit amet pretium. Curabitur efficitur risus sit amet mauris blandit blandit. Nam tempor sollicitudin ligula, non venenatis eros interdum in. Curabitur luctus malesuada odio, sed sollicitudin erat ullamcorper vitae. Vestibulum et porttitor tellus.
  #| Aliquam ac laoreet neque. Sed mauris urna, venenatis vitae purus in, cursus aliquet nunc. Maecenas sit amet lacinia ante, nec placerat eros. Cras consectetur, risus tincidunt sollicitudin malesuada, leo purus lacinia risus, sit amet rhoncus dui tellus id tortor. Proin et nulla diam. Suspendisse dignissim at leo at ultricies. Mauris tellus enim, cursus ut vestibulum a, laoreet vel libero. Cras elementum hendrerit neque egestas gravida.
  #| Nam a mi at nisl tincidunt ultrices sit amet non tellus. Quisque elit dui, blandit id justo non, cursus cursus justo. Curabitur vel orci velit. Donec accumsan ante libero, id blandit arcu vehicula et. Maecenas nibh magna, laoreet eget posuere scelerisque, fermentum ut risus. Ut tincidunt lacinia nisl a convallis. Sed a euismod neque. In magna ante, posuere non orci in, cursus placerat lorem. Maecenas consequat condimentum neque, vel tempor nisi finibus non. Donec facilisis, nunc nec porttitor feugiat, odio lorem posuere est, id mollis nibh quam et eros. Mauris non arcu sit amet turpis semper auctor. Curabitur aliquam urna turpis, eget sagittis quam iaculis ultricies.

///|
let xs : Array[String] = {
  let buf = StringBuilder::new(size_hint=Lorem.length() * 2)
  let res = []
  let mut i = 0
  for x in Lorem {
    buf.write_char(x)
    if i > 80 {
      res.push(buf.to_string())
      buf.reset()
      i = 0
    }
    i += 1
  }
  res
}
