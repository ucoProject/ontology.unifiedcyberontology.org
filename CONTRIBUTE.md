# Ontodocs Auto-Deployment

Previously, documentation for new releases of *CASE*/*UCO* would have to be manually built using gendocs/ontodocs, in order to deploy documentation via the project websites ([CASE](https://caseontology.org/)/[UCO](https://unifiedcyberontology.org)). With this repository, building the documentation and deploying it on the web will be a more automated process, and allow for local documentation to be built for necessary cases.


## Directions for generating documentation for a new release

The intended audience for this section is documentation maintainers.


### Warnings

The documentation generation must be carried out on a case-sensitive file system.  (macOS's default file system deployment is case-insensitive.)

**Do not** commit changes under the `/uco` directory on a case-insensitive file system.  Conflicts due to upper-vs.-lower casing will create erroneous symlink references.  Be aware that changes will be present on a fresh `git clone` in a case-insensitive file system.


### Generation directions

When a new ontology release is created, follow these steps:

1. Update the ontology-tracking submodule pointer in this repository to point at the new release's commit.
2. The version of UCO is hard-coded in `uco/Makefile` as part of titling the documentation.  Update it to the new version.
3. Run `make clean`.
4. Run `make`.  (`make -j` will work.)
5. Run `git add uco`.  This will pick up all file deletions and new file creations.
6. Commit the changes.
7. Push to Github.
8. Run `git pull` in the deployment space.


## Directions for deployment of this repository as a documentation service

For the deployment of the documentation, we assume this repository is cloned to a Linux server, becoming the directory `/srv/http/uco-docs/public/`.  If you clone it to another directory, ensure that any commands which tell you to alter the permissions to the mentioned directory or configuration files that use it are updated.


### Configuration
To deploy, the system will need to have **Apache2** installed and this repository cloned on it. We will use  *Apache2's VirtualHost* feature and *mod_rewrite* extension to route traffic to the proper documentation pages. This CONTRIBUTE.md page will outline installing **Apache2** and utilizing the **Makefile** to test the setup. All commands will assume the deployment system is a debian-based system *(such as Ubuntu)*.



First, update the package repositories and update the system:

```bash
$ sudo apt-get update
$ sudo apt-get -y upgrade
```

Then, install Apache2 on the server:

```bash
$ sudo apt-get install apache2
```



Once Apache2 is installed, we are going to want to enable *mod_rewrite* and disable the default website that is displayed at *localhost*

```bash
# enable mod_rewrite, without manually editing /etc/apache/apache2.conf
$ sudo a2enmod rewrite
# disable the default website
$ sudo a2dissite 000-default.conf
# finally, restart the apache service
$ sudo service apache2 restart
```



We can confirm that *mod_rewrite* is running:

```bash
$ apache2ctl -M | grep rewrite
```
The command should provide output, otherwise *mod_rewrite* is not running on the system.



Now that we have enabled *mod_rewrite*, we can create the *VirtualHost* for the documentation website:

```bash
$ sudo vi /etc/apache2/sites-available/uco-docs.conf
```

Inside this file, we can include the following configuration:

```shell
<VirtualHost *:80>
		# replace the ServerName with your domain
    ServerName example.com
    
    # replace the DocumentRoot with the path to the repo
    DocumentRoot /path/to/files
    
    ServerAdmin webmaster@localhost
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

		# replace the path in the <Directory> directive with the path to the repo
    <Directory /path/to/files>
      Options Indexes FollowSymLinks
      AllowOverride All
      Require all granted
    </Directory>
</VirtualHost>
```

(If you use an alternate mechanism to a text editor to move the configuration file into place, after it is moved the file ownership should be `root:root`.)

This configuration will define a `ServerName`, which is the domain name that the server will listen for and the `DocumentRoot`, which is the path to the files. You will also need to modify the path in the `<Directory></Directory>` directive to enable the proper **.htaccess** settings needed for *mod_rewrite*.



Finally, enable the new website then restart apache:

```bash
$ sudo a2ensite uco-docs.conf
$ sudo service apache2 restart
```



#### Optional Localhost

If you are running the deployment on a system that does not access the internet, or you wish to only provide the documentation locally, you may want to add an entry to your hosts file.

```bash
$ sudo vi /etc/hosts
```



### Debugging

There are a variety of errors that you can face, but we are going to address the most common ones. 

**403** - For 403 errors, check to ensure that the permissions are properly set on the folder and files. For this, we will use the example directory `/srv/http/uco-docs/public`:

```bash
$ sudo find /srv/http/uco-docs/public -type d -exec chmod 775 {} \;
$ sudo find /srv/http/uco-docs/public -type f -exec chmod 664 {} \;
$ sudo chown -R www-data:www-data /srv/http/uco-docs/public
```

**404** - For 404 errors, this means that apache2 is having trouble finding the file it is trying to serve. There are a few things which can cause this:
- Ensure that the website's DocumentRoot which is defined in the VirtualHost config in `/etc/apache2/sites-available/*`, actually exists. In addition, ensure you enabled the website and the file exists in `/etc/apache2/sites-enabled/*`.
- Ensure that `000-default.conf` has been disabled (no longer in `/etc/apache2/sites-enabled/*`)
- Check that the file actually exists! `tail -f /var/log/apache2/error.log`

**500** - For any 500 errors, the server may be mis-configured, you can check the following areas to see if there is relevant outputs. This is commonly due to `/etc/apache/apache.conf` being mis-configured, or a typo in one of the sites which are enabled.

```bash
$ sudo tail -f /var/log/apache/error.log
$ journalctl # or check -u apache2
```

**symlinks** - This repository relies on soft-links to translate some paths from IRI format to generated-documentation format.  Under some conditions, these soft-links can be cloned and appear to be regular files, containing only a relative path.  This is detected by running the `make check-service` prescribed below.

The issue is likely due to the repository being cloned with `core.symlinks` set to `false`.  To correct the issue, run the following from within your cloned directory.

```bash
# First, confirm whether core.symlinks is returning "false".
git config core.symlinks
# If so, proceed with setting to "true".
git config core.symlinks true
# A git status now will report that file types changed.
git status
# git-checkout will restore the file types to their tracked versions.
git checkout -- .
# git-status should now report no revisions.
git status
```


### Testing

To test the deployment, run the **Makefile** to ensure expected URL behaviors and content types.

```bash
$ make check-service
```

If you have set the VirtualHost on apache as anything besides `localhost`, you will want to supply this prefix with the `HOST_PREFIX` parameter.  For example, to test the production service, run:

```bash
$ make HOST_PREFIX=https://ontology.ucoontology.org check-service
```

As another example, if you have a local deployment at `https://documentation.intranet.example.org/`, run:

```bash
$ make HOST_PREFIX=https://documentation.intranet.example.org check-service
```
