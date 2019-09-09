# TechWeek Website

The repository containing the Techweek website is in Github
[redbrick/techweek](https://github.com/redbrick/TechWeek) repository. The
website was written to have the Google Material Design look and feel.
MaterializeCSS was used to speed up the process.

## Deployment

To deploy to a server just run from the parent of of the folder you want to
deploy too. _example writen assuming folder deployed is techweek/dist_

```bash
git clone https://github.com/redbrick/techweek.git
cd techweek
npm install
```

Currently techweek is stored in `/webtree/t/techwk` and apache is set to serve
from the `dist` folder. DNS for techweek needs to be in ours own DNS records to
point to vhost and in DCU external DNS to point to us.

## How it works

The markdown files in the `pages` dir contains a JSON blob containing all events
details. This blob says what template to use. Each page is a markdown file with
a json blob at the beginning with all the details about that years talks. The
Json is used to fill a mustache template since all the pages are the same format
and layout and output to dist.

The `main.js` file is responsible for displaying the countdown and loading the
video feed. Also, it changes colour of the header and individual days, depending
on the amount of times you have visited the page. It also handles the #Day so a
specific day can be linked to. Gulp concats this with materilize and minifies it
to `dist/js`

## Updating

There is a service set pull the lastest build from git and build it.
`/etc/systemd/system/techweek.service` is as follows

```text
[Unit]
Description=Update Techweek site off git build it

[Service]
Type=oneshot
WorkingDirectory=/webtree/t/techwk
ExecStart=/bin/sh -c '/usr/bin/git pull && /usr/bin/docker run -it --rm --name techweek -v /webtree/t/techwk:/usr/src/app -w /usr/src/app node:boron npm install --unsafe-perm'
```

and a Timer set to do this every hour at `/etc/systemd/system/techweek.timer`

```text
[Unit]
Description=Update Techweek site of git once an hour

[Timer]
OnBootSec=15min
OnUnitActiveSeC=1h
Persistent=true

[Install]
WantedBy=timers.target
```
