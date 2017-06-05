var graphvizs = $('.section').find('code.graphviz')
graphvizs.each(function (key, value) {
  try {
    var $value = $(value)
    var $ele = $(value).parent().parent()

    var graphviz = Viz($value.text())
    if (!graphviz) throw Error('viz.js output empty graph')
    $value.html(graphviz)

    $ele.addClass('graphviz')
    $value.children().unwrap().unwrap()
  } catch (err) {
    console.warn(err)
  }
})
