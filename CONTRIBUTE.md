# Ontodocs Auto-Deployment

Previously, documentation for new releases of *CASE*/*UCO* would have to be manually built using gendocs/ontodocs, in order to deploy documentation via the project websites ([CASE](https://caseontology.org/)/[UCO](https://unifiedcyberontology.org)). With this repository, building the documentation and deploying it on the web will be a more automated process, and allow for local documentation to be built for necessary cases.

For those interested in local documentation, the routing infrastructure currently assumes HTTP service (whether ontology documentation or machine-consummable RDF formats) will be done using HTTPS only.


## Directions for generating and deploying documentation for a new release

The intended audience for this section is documentation maintainers.


### Warnings

The documentation generation must be carried out on a case-sensitive file system. (macOS's default file system deployment is case-insensitive.)

**Do not** commit changes under the `/uco` directory on a case-insensitive file system.  Conflicts due to upper-vs.-lower casing will create erroneous concept files.  Be aware that changes will be present on a fresh `git clone` in a case-insensitive file system.


### Generation directions

When a new ontology release is created, follow these steps:

1. Update the ontology-tracking submodule pointer in this repository to point at the new release's commit.
2. Run `make clean`.
3. Run `make`.  (`make -j` will work.)
4. Run `git add uco documentation`.  This will pick up all file deletions and new file creations.
5. Run `git add` for the other refreshed text files in `${top_srcdir}`.
6. Commit the changes.
7. Push to GitHub.


## Directions for deployment of this repository as a documentation service

For the deployment of the documentation, we assume this repository is cloned to a Linux server, becoming the directory `/srv/http/ontology.unifiedcyberontology.org/`. The nginx configuration file and `ucodocs` `systemctl` service file are pathed to this directory by default.

Note that this service is only tested under the operational assumption that the documentation will be served over HTTPS.  All routing initiated over HTTP will be upgraded to HTTPS.  Please plan TLS certificates accordingly.


### Initial configuration

To deploy, the system will need to have **Nginx** installed and this repository cloned on it. We will use a simple **flask** router and a series of version-specific mapping files to route traffic to the proper documentation pages. This `CONTRIBUTE.md` page will outline installing **Nginx** and utilizing the **Makefile** to test the setup. All commands will assume the deployment system is a Debian-based system *(such as Ubuntu)*.

First, update the package repositories and update the system:

```bash
$ sudo apt-get update
$ sudo apt-get -y upgrade
```

Then, install Nginx on the server, and `python3-venv` if the server's operating system is Ubuntu:

```bash
$ sudo apt-get install nginx python3-venv
```

Create a directory where the UCO autodocs repository will live, and a dedicated system user:

```bash
$ sudo mkdir -p /srv/http/ontology.unifiedcyberontology.org
$ sudo useradd --create-home --shell /usr/sbin/nologin --system ucodocs
$ sudo chown ucodocs:ucodocs /srv/http/ontology.unifiedcyberontology.org
```

(`--create-home` is suggested for shell auditing purposes, and would create `/home/ucodocs` if passed.)

Use the new system user to clone this repository on the machine, you will need to initalize a repository in the service directory, to be able to pull to the non-empty target:

```bash
$ sudo su ucodocs -s /bin/bash
$ cd /srv/http/ontology.unifiedcyberontology.org
$ git init
$ git remote add origin https://github.com/ucoProject/ontology.unifiedcyberontology.org.git
$ git fetch
$ git checkout main
```

Change directories to the `router/` directory, and build the flask router:

```bash
$ cd router/
$ make clean
$ make
$ # (Work as the 'ucodocs' user is concluded.)
$ exit
```

Link the `ucodocs.service` file so that systemctl can use it, reload, and enable the service.  *Note:* If this deployment expects to modify the service file, e.g. to change the `User` line, it should be copied (`cp`) instead of soft-linked as documented.

```bash
$ cd /etc/systemd/system
$ sudo ln -s /srv/http/ontology.unifiedcyberontology.org/router/ucodocs.service
$ sudo systemctl daemon-reload
$ sudo systemctl enable ucodocs.service
$ # Start the flask router and check the status of it
$ sudo service ucodocs start
$ sudo service ucodocs status
```

Assuming that the ucodocs service starts successfully, you can proceed to copy the nginx configuration file to the `sites-enabled` directory and remove the default file.  *Note:* Again, if this deployment expects to adapt the nginx configuration file, e.g. to change the server name, it should be copied instead of soft-linked as documented.

```bash
$ cd /etc/nginx/sites-enabled
$ sudo ln -s /srv/http/ontology.unifiedcyberontology.org/router/uco.nginx.conf
$ sudo rm default
$ sudo service nginx configtest
$ sudo service nginx restart
```

You should now be able to navigate to the IP address of your system and see the documentation live:

```bash
$ # (to get the IP information)
$ ip a s
```

To modify the nginx configuration file and add a hostname, change the `server_name` line as follows:

```patch
 server {
     listen 80;
-    server_name ontology.unifiedcyberontology.org;
+    server_name mywebsite.com;
 
     location /documentation {
         root /srv/http/ontology.unifiedcyberontology.org;
         try_files $uri $uri/ /index.html =404;
     }
 
     location / {
         proxy_pass http://127.0.0.1:5000;
         proxy_set_header Host $host;
         proxy_set_header X-Real-IP $remote_addr;
         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
     }
 }
```


### Updating existing deployment

To refresh served files (i.e. RDF-XML, Turtle, HTML and HTML-supporting files), these are the only steps that need to be run:

```bash
$ sudo su ucodocs -s /bin/bash
$ cd /srv/http/ontology.unifiedcyberontology.org
$ git pull
$ exit
```

If there were no revisions under `router/`, the update process is complete.

If there are revisions to `router/uco.nginx.conf` or `router/ucodocs.service`, and those files are soft-linked under `/etc`, these commands will restart and reload web service.  If the files were not soft-linked, review the diffs and apply the same changes to the copied files under `/etc`.

```bash
$ sudo systemctl daemon-reload
$ sudo service ucodocs restart
$ sudo service ucodocs status
$ sudo service nginx configtest
$ sudo service nginx restart
$ sudo service nginx status
```


## Optional Localhost

If you are running the deployment on a system that does not access the internet, or you wish to only provide the documentation locally, you may want to add an entry to your hosts file.

```bash
$ sudo vi /etc/hosts
```


## Testing

To test the deployment, run the **Makefile** to ensure expected URL behaviors and content types.  Unparameterized, this call will confirm files retrieved from `localhost` content-match expected files in the source tree:

```bash
$ make check-service
```

If you have set the `server_name` on nginx as anything besides `localhost`, you will want to supply this prefix with the `HOST_PREFIX` parameter.  For example, to test the production service, run:

```bash
$ make HOST_PREFIX=https://ontology.unifiedcyberontology.org check-service
```

As another example, if you have a local deployment at `https://documentation.intranet.example.org/`, run:

```bash
$ make HOST_PREFIX=https://documentation.intranet.example.org check-service
```


## Debugging

There are a variety of errors that you can face, but we are going to address the most common ones.

**403** - For 403 errors, check to ensure that the permissions are properly set on the folder and files. For this, we will use the example directory `/srv/http/ontology.unifiedcyberontology.org`:

```bash
$ sudo find /srv/http/ontology.unifiedcyberontology.org -type d -exec chmod 775 {} \;
$ sudo find /srv/http/ontology.unifiedcyberontology.org -type f -exec chmod 664 {} \;
$ sudo chown -R ucodocs:ucodocs /srv/http/ontology.unifiedcyberontology.org
```

**404** - For 404 errors, is commonly a symptom of the pathing between nginx and the flask router being incorrect:
- Ensure that the paths defined in the systemctl file (`/etc/systemd/system`) are correctly pointing to the router
- Check the nginx configuration file (`/etc/nginx/sites-enabled/`) to ensure that the pathing to the documentation is correct
- Ensure that `default` config for nginx is deleted (no longer in `/etc/nginx/sites-enabled/*`)
- Check that the requested file actually exists! `tail -f /var/log/nginx/error.log`

**500** - For any 500 errors, the server may be mis-configured, you can check the following areas to see if there is relevant outputs. This is commonly due to a typo (perhaps an updated path?) in one of the sites which are enabled.

```bash
$ sudo tail -f /var/log/nginx/error.log
$ journalctl
```
