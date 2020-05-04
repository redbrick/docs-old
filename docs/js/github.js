$(document).ready(function () {
  var git = 'https://github.com/redbrick/docs/edit/master/docs';
  var t1 = window.location.pathname;
  var url = null;
  if (t1 === '/') {
    url = git + '/index.md';
  } else {
    url = git + t1.substr(0, t1.length - 1) + '.md';
  }
  let aGit = $('[href="https://github.com/redbrick/docs"]');
  aGit.attr('href', url).attr('target', '_blank');
});
