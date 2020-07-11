# Redbrick Site

The Code is hosted on github in the
[redbrick/react-site](https://github.com/redbrick/react-site) repository

The site is comprised of static files generated using the ReactJS framework
Gatsby.

## Google Sheet

The google sheet controlling the information can be found
[here](https://docs.google.com/spreadsheets/d/15pFYVzuFPK4HFOpnnFHuoTNh3L3iThBCpoVMQzT5RlM/edit?usp=sharing).

Gatsby uses the google sheet as a datasource pulling data every time the site is
built.

### Requirements

- **Node** : Download [Node](https://nodejs.org/download/)
- Slight insanity
- general understanding of ReactJS
- google api key. [refer to
  here](https://www.gatsbyjs.org/packages/gatsby-source-google-spreadsheets/#step-2-set-up-sheetspermissions)

## Deployment

Deployment is handled by a systemd service in nixos. This service will rebuild
the site at 00:00 everyday to ensure latest details from the google sheet.

See
[nix-configs](https://github.com/redbrick/nix-configs/blob/master/services/httpd/react-site.nix)
for details.

To update the site the version of the package in the config will need to
increased.

## I want to make changes

So you want to make changes? okay.

### Installation

1. git clone the repo
2. run `yarn` in the root directory
3. start a hot reload server with `yarn start`
4. make changes and watch the magical hot reload take action live!

Note: the main code is located in `/src`

## Common Deployment Issues

### Virtual Router

Since react uses a virtual router all requests to the site should redirect to
the index. This is handled by Apache config in
[nix-config](https://github.com/redbrick/nix-configs/blob/master/services/httpd/default.nix#L40)

### Permissions

Ensure the permissions of the generate files are readable. All files should be
world readable.
