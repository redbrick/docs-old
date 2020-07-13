var graphvizs = $('.section').find('code.language-graphviz');
graphvizs.each(function (key, value) {
  try {
    var $value = $(value);
    var $ele = $(value).parent().parent();

    var graphviz = Viz($value.text(), { format: 'png-image-element' });
    if (!graphviz) throw Error('viz.js output empty graph');
    $value.html(graphviz);

    $ele.addClass('graphviz');
    $value.children().unwrap().unwrap();
  } catch (err) {
    console.warn(err);
  }
});
