# Redbrick Site

The Code is hosted on github in the
[redbrick/react-site](https://github.com/redbrick/react-site) repository

The site is comprised of static files generated using the ReactJS framework.

## Google Sheet

The google sheet controlling the information can be found
[here](https://docs.google.com/spreadsheets/d/15pFYVzuFPK4HFOpnnFHuoTNh3L3iThBCpoVMQzT5RlM/edit?usp=sharing).

## Data Endpoint

The events, images, and slides get pulled from the root directory of 'fraz'.
This file gets updated every 24 hours at 00:00 from the google sheet. The google
sheet can only be edited by cmt members.

### Requirements

- **Node** : Download [Node](https://nodejs.org/download/)
- Slight insanity
- general understanding of ReactJS

## Deployment

1. git clone the repo.
2. run npm install.
3. ensure the "homepage" in package.json is set correctly.
4. ensure this.dataURL is set to pull information from the correct JSON file.
5. run npm build.
6. ensure there are no errors in the output.
7. copy &amp; paste the .htaccess file located in the apache folder into the
   build folder.
8. copy &amp; paste the static files in the build folder that has been created.
   This is your site now :)

- Ensure the JSON file this.dataURL is set to pull from is being regularly
  updated (~ once day)

- As of 19/11/2019, the release of this site, the data.json file can be pulled
  from fraz.redbrick.dcu.ie/data.json
    - This file is updated by a cron job running at 00:00 everyday. :)

## I want to make changes

So you want to make changes? okay.

### Installation

1. git clone the repo
2. run npm install in the root directory
3. start a hotreload server with npm start
4. make changes and watch the magical hot reload take action live!

Note: the main code is located in /src

## Common Deployment Issues

### .htaccess

- Since react uses a virtual router all requests to the site should redirect to
  the index.
- The easiest way of doing this if running apache is to drop a .htaccess file
  into the root folder.
- Ensure the permissions of this is readable.

```.htaccess
<IfModule mod_rewrite.c>
  RewriteEngine On
  RewriteBase /
  RewriteRule ^index\.html$ - [L]
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteCond %{REQUEST_FILENAME} !-l
  RewriteRule . /index.html [L]
</IfModule>
```

## Old Site

The old redbrick static site is still available on github under
[redbrick/static-site](https://github.com/redbrick/static-site)
