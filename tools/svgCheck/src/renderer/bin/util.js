export let isSame = function (a, b) {
  if (a.length !== b.length) {
    return false
  }
  let count = 0
  for (let j = 0; j < a.length; j = j + 4) {
    for (let i = 0; i < 4; i++) {
      let index = i + j
      if (a[index] !== b[index]) {
        count++
        break
      }
    }
  }
  return {
    total: a.length / 4,
    bad: count,
    rate: 1 - (count / (a.length / 4))
  }
}
