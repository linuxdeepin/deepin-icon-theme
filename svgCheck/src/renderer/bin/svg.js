function imageToCanvas (svgId, path) {
  let canvas = document.querySelector(svgId)
  let context = canvas.getContext('2d')
  context.clearRect(0, 0, 200, 200)
  let image = new window.Image(200, 200)
  image.src = 'file://' + path
  return new Promise(function (resolve, reject) {
    image.onload = () => {
      context.drawImage(image, 0, 0, 200, 200)
      // console.log(canvas.toDataURL('image/png', 1))
      resolve(context.getImageData(0, 0, 200, 200))
    }
  })
}

export default imageToCanvas
